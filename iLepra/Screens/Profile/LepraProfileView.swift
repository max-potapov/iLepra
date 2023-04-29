//
//  LepraProfileView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import SwiftUI

struct LepraProfileView: View {
    @EnvironmentObject private var viewModel: LepraProfileViewModel
    @StateObject private var votesDetailsViewModel: LepraVotesDetailsViewModel = .init()
    @Binding private var shouldReload: Bool
    @State private var isPresented: Bool = false

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
                    if let karma = votesDetailsViewModel.votes?.karma {
                        Button("\(karma > 0 ? "+" : "")\(karma)") {
                            isPresented.toggle()
                        }
                        .font(.headline)
                        .disabled(isPresented)
                    }
                }
                .sheet(isPresented: $isPresented) {
                    LepraSheetView(.medium) {
                        if let votes = votesDetailsViewModel.votes {
                            LepraVotesDetailsView(votes: .constant(votes)) {
                                fetchVotes()
                            }
                        } else {
                            LepraTextLoadingIndicatorView()
                                .onAppear {
                                    fetchVotes()
                                }
                        }
                    }
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
                votesDetailsViewModel.reset()
            }
        }
    }

    init(shouldReload: Binding<Bool>) {
        _shouldReload = shouldReload
    }

    private func fetch() {
        Task {
            await fetch()
            await fetchVotes()
        }
    }

    @MainActor
    private func fetch() async {
        try? await viewModel.fetch()
        shouldReload = false
    }

    private func fetchVotes() {
        Task {
            await fetchVotes()
        }
    }

    @MainActor
    private func fetchVotes() async {
        guard let id = viewModel.leper?.id else { return }
        try? await votesDetailsViewModel.fetchVotes(userID: id)
    }
}

struct LepraProfileView_Previews: PreviewProvider {
    static var previews: some View {
        LepraProfileView(
            shouldReload: .constant(false)
        )
    }
}
