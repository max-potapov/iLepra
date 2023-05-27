//
//  LepraChartView.swift
//  iLepra
//
//  Created by Maxim Potapov on 15.04.2023.
//

import Charts
import SwiftUI

struct LepraChartView: View {
    @Binding var comments: [LepraComment]

    #if os(macOS)
        private let limit: Int = 30
    #else
        private let limit: Int = 10
    #endif
    private let grouped: [LepraUser: [LepraComment]]
    private let rated: [(key: LepraUser, value: [LepraComment])]
    private let topCount: [BarData]
    private let topPositive: [BarData]
    private let topNegative: [BarData]

    var body: some View {
        List {
            let tops = [topCount, topPositive, topNegative]
            ForEach(tops.indices, id: \.self) { index in
                Section {
                    switch index {
                    case 0:
                        Text("По количеству")
                    case 1:
                        Text("Верх рейтинга [sum(rating)/count]")
                    case 2:
                        Text("Низ рейтинга [sum(rating)/count]")
                    default:
                        EmptyView()
                    }
                    Chart(tops[index]) { bar in
                        BarMark(
                            x: .value("x", bar.label),
                            y: .value("y", bar.value)
                        )
                        .foregroundStyle(by: .value("color", bar.value))
                    }
                    .chartXAxis {
                        AxisMarks { value in
                            if let label = value.as(String.self),
                               let userName = label.components(separatedBy: "\n").first,
                               let stats = label.components(separatedBy: "\n").last
                            { // swiftlint:disable:this opening_brace
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    VStack {
                                        Text(userName)
                                        Text(stats)
                                    }
                                    .font(.footnote)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                }
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
    }

    init(comments: Binding<[LepraComment]>) {
        _comments = comments

        grouped = Dictionary(grouping: comments.wrappedValue, by: \.user)
        rated = grouped.sorted { $0.value.avgRating > $1.value.avgRating }

        let barDataLabel = { (key: LepraUser, value: [LepraComment]) -> String in
            key.login
                .appending("\n")
                .appending("\(value.count)/\(value.avgRating)")
        }

        let toBarDataCount = { (key: LepraUser, value: [LepraComment]) -> BarData in
            .init(
                label: barDataLabel(key, value),
                value: value.count
            )
        }

        let toBarDataRating = { (key: LepraUser, value: [LepraComment]) -> BarData in
            .init(
                label: barDataLabel(key, value),
                value: value.avgRating
            )
        }

        topCount = grouped
            .sorted { $0.value.count > $1.value.count }
            .prefix(limit)
            .map(toBarDataCount)

        topPositive = rated
            .prefix(limit)
            .map(toBarDataRating)

        topNegative = rated
            .suffix(limit)
            .reversed()
            .map(toBarDataRating)
    }
}

extension LepraChartView {
    private struct BarData: Identifiable, Hashable {
        var id: String { label }
        let label: String
        let value: Int
    }
}

struct LepraChartView_Previews: PreviewProvider {
    static var previews: some View {
        LepraChartView(comments: .constant([
            .init(id: 0),
            .init(id: 1),
        ]))
    }
}
