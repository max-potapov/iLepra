//
//  LepraVotesView.swift
//  iLepra
//
//  Created by Maxim Potapov on 08.04.2023.
//

import SwiftUI

struct LepraVotesView: View {
    @State var isReversed: Bool = false
    @State var rating: Int
    @State var userVote: Int?

    var body: some View {
        HStack {
            Button {
                // down vote
            } label: {
                Image(systemName: userVote ?? 0 < 0 ? "minus.square.fill" : "minus.square")
            }
            .buttonStyle(.borderless)
            .tint(.accentColor)

            Button {
                // up vote
            } label: {
                Image(systemName: userVote ?? 0 > 0 ? "plus.square.fill" : "plus.square")
            }
            .buttonStyle(.borderless)
            .tint(.accentColor)

            Button {
                // show votes
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
        LepraVotesView(rating: 42, userVote: 10)
    }
}
