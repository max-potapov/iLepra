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
    private let limit: Int = 10

    private var grouped: [LepraUser: [LepraComment]] {
        Dictionary(grouping: comments, by: \.user)
    }

    private var topCount: [BarData] {
        grouped
            .sorted { $0.value.count > $1.value.count }
            .prefix(limit)
            .map { .init(label: $0.key.login, value: $0.value.count) }
    }

    private var topPositive: [BarData] {
        grouped
            .sorted { $0.value.avgRating > $1.value.avgRating }
            .prefix(limit)
            .map { .init(label: $0.key.login, value: $0.value.avgRating) }
    }

    private var topNegative: [BarData] {
        grouped
            .sorted { $0.value.avgRating < $1.value.avgRating }
            .prefix(limit)
            .map { .init(label: $0.key.login, value: $0.value.avgRating) }
    }

    var body: some View {
        List {
            let tops = [topCount, topPositive, topNegative]
            ForEach(tops.indices, id: \.self) { index in
                Section {
                    switch index {
                    case 0:
                        Text("По количеству")
                    case 1:
                        Text("В плюсах")
                    case 2:
                        Text("В минусах")
                    default:
                        Text("ХЗ")
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
