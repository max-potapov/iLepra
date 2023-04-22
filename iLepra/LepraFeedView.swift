//
//  LepraFeedView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraFeedView: View {
    @EnvironmentObject private var viewModel: LepraViewModel
    @State private var isLoading = false
    @State private var navigationPath: NavigationPath = .init()

    var body: some View {
        Group {
            if viewModel.feedPosts.isEmpty {
                LepraEmptyContentPlaceholderView {
                    fetch()
                }
            } else {
                NavigationStack(path: $navigationPath) {
                    LepraPostsView(
                        isLoading: $isLoading,
                        navigationPath: $navigationPath,
                        posts: $viewModel.feedPosts,
                        onLastSectionAppear: {
                            fetch()
                        }
                    )
                }
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
        try? await viewModel.fetchFeed()
        isLoading = false
    }
}

struct LepraFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LepraFeedView()
            .environmentObject(LepraViewModel())
    }
}
