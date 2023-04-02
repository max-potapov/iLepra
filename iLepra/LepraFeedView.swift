//
//  LepraFeedView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraFeedView: View {
    @EnvironmentObject var viewModel: LepraViewModel
    @State private var isLoading = false
    @State private var navigationPath: NavigationPath = .init()

    var body: some View {
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
                .navigationTitle("Главная")
            }
        }
    }

    func fetch() {
        guard !isLoading else { return }

        defer {
            isLoading = false
        }

        isLoading = true

        Task {
            try await viewModel.fetchFeed()
        }
    }
}

struct LepraFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LepraFeedView()
            .environmentObject(LepraViewModel())
    }
}
