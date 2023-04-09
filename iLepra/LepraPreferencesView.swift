//
//  LepraPreferencesView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraPreferencesView: View {
    @EnvironmentObject var viewModel: LepraViewModel

    var body: some View {
        Group {
            if let leper = viewModel.leper {
                VStack {
                    Text(leper.login)
                        .font(.largeTitle)
                    Text("#" + leper.id.description)
                        .font(.headline)
                    Text(leper.kind)
                        .font(.subheadline)
                }
            } else {
                LepraEmptyContentPlaceholderView {
                    fetch()
                }
            }
        }
        .navigationTitle("Профиль")
    }

    func fetch() {
        Task {
            try await viewModel.fetchMe()
        }
    }
}

struct LepraPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        LepraPreferencesView()
            .environmentObject(LepraViewModel())
    }
}
