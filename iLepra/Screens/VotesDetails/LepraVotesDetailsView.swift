//
//  LepraVotesDetailsView.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import SwiftUI

struct LepraVotesDetailsView: View {
    @Binding var votes: AjaxVotes
    let onLastSectionAppear: () -> Void

    var body: some View {
        if votes.totalCount == 0 {
            Text("Тут рыбы нет!")
        } else {
            List {
                VStack {
                    Text("Рейтинг: \(votes.rating)")
                        .font(.title2)
                    HStack {
                        Text("плюсов – \(votes.prosCount)")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Text("минусов – \(votes.consCount)")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                }
                let count = max(votes.cons.count, votes.pros.count)
                ForEach(0 ..< count, id: \.self) { index in
                    HStack {
                        Group {
                            if let pro = votes.pros[safe: index] {
                                Text("\(pro.user.login)[\(pro.user.karma)] \(pro.vote > 0 ? "+" : "")\(pro.vote)")
                            } else {
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Divider()
                        Group {
                            if let con = votes.cons[safe: index] {
                                Text("\(con.user.login)[\(con.user.karma)] \(con.vote > 0 ? "+" : "")\(con.vote)")
                            } else {
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
                    #if os(iOS)
                        .onAppear {
                            if index + 1 == count {
                                onLastSectionAppear()
                            }
                        }
                    #endif
                }
            }
        }
    }
}

struct LepraVotesDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LepraVotesDetailsView(votes: .constant(.init())) {}
    }
}