//
//  LepraProfileView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraProfileView: View {
    @StateObject private var viewModel: LepraProfileViewModel = .init()
    @Binding private var shouldReload: Bool

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
        .onChange(of: shouldReload) { reload in
            if reload {
                viewModel.reset()
            }
        }
    }

    init(shouldReload: Binding<Bool>) {
        _shouldReload = shouldReload
    }

    private func fetch() {
        Task {
            await fetch()
        }
    }

    @MainActor
    private func fetch() async {
        try? await viewModel.fetch()
        shouldReload = false
    }
}

struct LepraProfileView_Previews: PreviewProvider {
    static var previews: some View {
        LepraProfileView(
            shouldReload: .constant(false)
        )
    }
}
