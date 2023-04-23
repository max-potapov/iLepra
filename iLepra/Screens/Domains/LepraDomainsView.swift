//
//  LepraDomainsView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraDomainsView: View {
    @EnvironmentObject private var viewModel: LepraDomainsViewModel
    @Binding private var navigationPath: NavigationPath
    @Binding private var shouldReload: Bool
    @State private var isLoading: Bool = false
    @State private var isLoadingPosts: Bool = false

    var body: some View {
        Group {
            if viewModel.domains.isEmpty {
                LepraEmptyContentPlaceholderView {
                    fetch()
                }
            } else {
                NavigationStack(path: $navigationPath) {
                    List {
                        ForEach($viewModel.domains, id: \.self) { $domain in
                            LepraDomainSectionView(domain: $domain)
                        }
                        LepraLoadingSectionView(isLoading: $isLoading)
                    }
                    .navigationDestination(for: LepraDomain.self) { domain in
                        LepraPostsView(
                            isLoading: $isLoadingPosts,
                            navigationPath: $navigationPath,
                            posts: $viewModel.posts,
                            onLastSectionAppear: {
                                fetchPosts()
                            }
                        )
                        .onAppear {
                            viewModel.setCurrentDomain(domain)
                        }
                        .navigationTitle(domain.title)
                    }
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

    private func fetchPosts() {
        Task {
            await fetchPosts()
        }
    }

    @MainActor
    private func fetchPosts() async {
        guard !isLoadingPosts else { return }

        isLoadingPosts = true
        try? await viewModel.fetchPosts()
        isLoadingPosts = false
    }
}

struct LepraDomainView_Previews: PreviewProvider {
    static var previews: some View {
        LepraDomainsView(
            navigationPath: .constant(.init()),
            shouldReload: .constant(false)
        )
    }
}
