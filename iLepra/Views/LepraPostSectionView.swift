//
//  LepraPostSectionView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import SwiftUI

struct LepraPostSectionView: View {
    @StateObject private var viewModel: LepraVotesDetailsViewModel = .init()
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Binding var navigationPath: NavigationPath
    @Binding var post: LepraPost
    @State private var isPresented: Bool = false
    @State private var isLoading: Bool = false

    var useHorizontalLayout: Bool {
        dynamicTypeSize <= .accessibility2
    }

    var layout: AnyLayout {
        useHorizontalLayout ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 24))
    }

    var commentsCount: String {
        [
            "\(post.commentsCount)",
            (post.unreadCommentsCount == post.commentsCount)
                || (post.unreadCommentsCount == 0) ? "" : "/\(post.unreadCommentsCount)",
        ]
        .joined()
    }

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: useHorizontalLayout ? 8 : 24) {
                LepraHTMLView(html: post.body)

                Divider()

                Text("\(post.user.wroteOnceText(when: post.created))")
                    .font(.footnote)

                layout {
                    Button {
                        navigationPath.append(post)
                    } label: {
                        HStack {
                            Image(systemName: post.unreadCommentsCount == 0 ? "bubble.right" : "bubble.right.fill")
                            Text(commentsCount)
                        }
                    }
                    .buttonStyle(.borderless)
                    .tint(.accentColor)

                    if useHorizontalLayout {
                        Spacer()
                    }

                    LepraVotesView(
                        id: post.id,
                        rating: post.rating,
                        userVote: post.userVote ?? 0,
                        voteWeight: post.voteWeight
                    ) { _, vote in
                        setVote(vote)
                    } showAction: { _ in
                        showVotes()
                    }
                }
                .frame(maxWidth: .infinity, alignment: useHorizontalLayout ? .leading : .center)
            }
            .sheet(isPresented: $isPresented) {
                LepraSheetView(.medium) {
                    if let votes = viewModel.votes {
                        LepraVotesDetailsView(votes: .constant(votes)) {
                            fetch()
                        }
                    } else {
                        LepraTextLoadingIndicatorView()
                            .onAppear {
                                fetch()
                            }
                    }
                }
            }
        }
    }

    private func setVote(_ vote: Int) {
        Task {
            await setVote(vote)
        }
    }

    @MainActor
    private func setVote(_ vote: Int) async {
        try? await viewModel.vote(postID: post.id, value: vote)
    }

    private func showVotes() {
        isPresented.toggle()
    }

    private func fetch() {
        Task {
            await fetch()
        }
    }

    @MainActor
    private func fetch() async {
        isLoading = true
        try? await viewModel.fetchVotes(postID: post.id)
        isLoading = false
    }
}

struct LepraPostSectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LepraPostSectionView(
                navigationPath: .constant(.init()),
                post: .constant(.init())
            )
        }
    }
}
