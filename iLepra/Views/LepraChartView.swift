//
//  LepraChartView.swift
//  iLepra
//
//  Created by Maxim Potapov on 15.04.2023.
//

import Charts
import SwiftUI

struct LepraChartView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var comments: [LepraComment]

    private let limit: Int = 10
    private let grouped: [LepraUser: [LepraComment]]
    private let rated: [(key: LepraUser, value: [LepraComment])]
    private let topCount: [BarData]
    private let topPositive: [BarData]
    private let topNegative: [BarData]

    var body: some View {
        VStack {
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
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .onTapGesture {
                dismiss()
            }
            #if os(macOS)
            .frame(minWidth: 500, minHeight: 500)
            #endif
            #if os(macOS)
                Button("Закрыть") {
                    dismiss()
                }
                .padding()
            #endif
        }
    }

    init(comments: Binding<[LepraComment]>) {
        _comments = comments

        grouped = Dictionary(grouping: comments.wrappedValue, by: \.user)
        rated = grouped.sorted { $0.value.avgRating > $1.value.avgRating }

        topCount = grouped
            .sorted { $0.value.count > $1.value.count }
            .prefix(limit)
            .map { .init(label: $0.key.login, value: $0.value.count) }

        topPositive = rated
            .prefix(limit)
            .map { .init(label: $0.key.login, value: $0.value.avgRating) }

        topNegative = rated
            .suffix(limit)
            .reversed()
            .map { .init(label: $0.key.login, value: $0.value.avgRating) }
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
        LepraChartView(comments: .constant([.init(id: 0)]))
    }
}
