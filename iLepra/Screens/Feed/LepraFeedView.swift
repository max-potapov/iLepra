//
//  LepraFeedView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraFeedView: View {
    @EnvironmentObject private var viewModel: LepraFeedViewModel
    @Binding private var navigationPath: NavigationPath
    @Binding private var shouldReload: Bool
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

    init(
        navigationPath: Binding<NavigationPath>,
        shouldReload: Binding<Bool>
    ) {
        _navigationPath = navigationPath
        _shouldReload = shouldReload
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

struct LepraFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LepraFeedView(
            navigationPath: .constant(.init()),
            shouldReload: .constant(false)
        )
    }
}
