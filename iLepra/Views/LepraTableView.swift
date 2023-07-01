//
//  LepraTableView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.07.2023.
//

import SwiftUI

// swiftformat:sort
private struct LepraTableRecord: Identifiable {
    let avgRating: String
    let count: String
    var id: String { login }
    let login: String
}

struct LepraTableView: View {
    #if os(iOS)
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
        private var isCompact: Bool { horizontalSizeClass == .compact }
    #else
        private let isCompact: Bool = false
    #endif
    @Binding var comments: [LepraComment]
    private let limit: Int = 50

    private var records: [LepraTableRecord] {
        Dictionary(grouping: comments, by: \.user)
            .sorted {
                $0.value.count > $1.value.count
            }
            .prefix(limit)
            .map { (user: LepraUser, comments: [LepraComment]) -> LepraTableRecord in
                .init(
                    avgRating: .init(comments.avgRating),
                    count: .init(comments.count),
                    login: user.login
                )
            }
            .sorted(using: sortOrder)
    }

    @State private var sortOrder = [KeyPathComparator(\LepraTableRecord.count, order: .reverse)]

    var body: some View {
        Table(records, sortOrder: $sortOrder) {
            TableColumn("%username%", value: \.login) { record in
                VStack(alignment: .leading) {
                    Text(record.login)
                    if isCompact {
                        HStack {
                            Text("комментариев: \(record.count)")
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Divider()
                            Text("средний рейтинг: \(record.avgRating)")
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            TableColumn("комментариев", value: \.count)
            TableColumn("средний рейтинг", value: \.avgRating)
        }
    }
}

struct LepraTableView_Previews: PreviewProvider {
    static var previews: some View {
        LepraTableView(comments: .constant([
            .init(id: 0),
            .init(id: 1),
        ]))
    }
}
