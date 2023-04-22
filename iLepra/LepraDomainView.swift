//
//  LepraDomainView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraDomainView: View {
    @EnvironmentObject private var viewModel: LepraViewModel
    @State private var isLoading: Bool = false
    @State private var isLoadingPosts: Bool = false
    @State private var navigationPath: NavigationPath = .init()

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
                            posts: $viewModel.domainPosts,
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
        try? await viewModel.fetchDomains()
        isLoading = false
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
        LepraDomainView()
            .environmentObject(LepraViewModel())
    }
}
