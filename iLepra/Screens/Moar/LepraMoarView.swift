//
//  LepraMoarView.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import SwiftUI

struct LepraMoarView: View {
    @EnvironmentObject private var viewModel: LepraMoarViewModel
    @Binding var navigationPath: NavigationPath
    @Binding var shouldReload: Bool
    @State private var isLoading = false

    var body: some View {
        Group {
            if viewModel.posts.isEmpty {
                LepraEmptyContentPlaceholderView {
                    fetch()
                }
            } else {
                NavigationStack(path: $navigationPath) {
                    LepraPostsView(
                        isLoading: $isLoading,
                        navigationPath: $navigationPath,
                        posts: $viewModel.posts,
                        onLastSectionAppear: {
                            fetch()
                        }
                    )
                }
            }
        }
        .onChange(of: shouldReload) { reload in
            if reload {
                navigationPath = .init()
                viewModel.reset()
            }
        }
    }

    private func fetch() {
        Task {
            await fetch()
        }
    }

    @MainActor
    private func fetch() async {
        guard !isLoading else { return }

        isLoading = true
        try? await viewModel.fetch()
        isLoading = false
        shouldReload = false
    }
}

struct LepraMoarView_Previews: PreviewProvider {
    static var previews: some View {
        LepraMoarView(
            navigationPath: .constant(.init()),
            shouldReload: .constant(false)
        )
        .environmentObject(LepraMoarViewModel())
    }
}
