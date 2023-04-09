//
//  LepraDomainView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraDomainView: View {
    @EnvironmentObject var viewModel: LepraViewModel
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
        .navigationTitle("Подлепры")
    }

    func fetch() {
        guard !isLoading else { return }

        defer {
            isLoading = false
        }

        isLoading = true

        Task {
            try await viewModel.fetchDomains()
        }
    }

    func fetchPosts() {
        guard !isLoadingPosts else { return }

        defer {
            isLoadingPosts = false
        }

        isLoadingPosts = true

        Task {
            try await viewModel.fetchPosts()
        }
    }
}

struct LepraDomainView_Previews: PreviewProvider {
    static var previews: some View {
        LepraDomainView()
            .environmentObject(LepraViewModel())
    }
}
