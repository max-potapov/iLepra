//
//  LepraVotesView.swift
//  iLepra
//
//  Created by Maxim Potapov on 08.04.2023.
//

import SwiftUI

struct LepraVotesView: View {
    @State var isReversed: Bool = false
    let id: Int
    @State var rating: Int
    @State var userVote: Int
    let voteWeight: Int
    let voteAction: (_ id: Int, _ vote: Int) -> Void
    let showAction: (_ id: Int) -> Void

    var body: some View {
        HStack {
            Button {
                // down vote
                userVote = userVote < 0 ? 0 : -voteWeight
                rating += userVote == 0 ? voteWeight : -voteWeight
                voteAction(id, userVote < 0 ? -1 : 0)
            } label: {
                Image(systemName: userVote < 0 ? "minus.square.fill" : "minus.square")
            }
            .buttonStyle(.borderless)
            .tint(.accentColor)

            Button {
                // up vote
                userVote = userVote > 0 ? 0 : voteWeight
                rating -= userVote == 0 ? voteWeight : -voteWeight
                voteAction(id, userVote > 0 ? 1 : 0)
            } label: {
                Image(systemName: userVote > 0 ? "plus.square.fill" : "plus.square")
            }
            .buttonStyle(.borderless)
            .tint(.accentColor)

            Button {
                // show votes
                showAction(id)
            } label: {
                Text(rating.description)
            }
            .buttonStyle(.borderless)
            .tint(.accentColor)
        }
        .environment(\.layoutDirection, isReversed ? .rightToLeft : .leftToRight)
    }
}

struct LepraVotesView_Previews: PreviewProvider {
    static var previews: some View {
        LepraVotesView(
            id: 0,
            rating: 42,
            userVote: 0,
            voteWeight: 13
        ) { _, _ in
        } showAction: { _ in }
    }
}
