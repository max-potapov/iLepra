//
//  LepraFeedView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraFeedView: View {
    @StateObject private var viewModel: LepraFeedViewModel = .init()
    @Binding private var shouldReload: Bool
    @State private var isLoading = false
    @State private var navigationPath: NavigationPath = .init()

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
            shouldReload: .constant(false)
        )
    }
}
