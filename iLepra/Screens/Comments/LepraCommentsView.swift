//
//  LepraCommentsView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import SwiftUI

struct LepraCommentsView: View {
    @StateObject private var viewModel: LepraCommentsViewModel = .init()
    @StateObject private var votesDetailsViewModel: LepraVotesDetailsViewModel = .init()

    @Binding var post: LepraPost
    @State private var sortByDate: Bool = true
    @State private var showUnreadOnly: Bool = true
    @State private var isChartPresented = false
    @State private var showAlert = false

    @State private var selectedCommentID: Int = -1
    @State private var isVotesPresented: Bool = false
    @State private var isVotesLoading: Bool = false

    @State private var error: Error? {
        didSet {
            showAlert = error != nil
        }
    }

    var body: some View {
        Group {
            let nodes: [LepraNode] = LepraNode.make(
                from: viewModel.comments,
                sortByDate: sortByDate,
                showUnreadOnly: showUnreadOnly
            )

            if viewModel.comments.isEmpty {
                LepraEmptyContentPlaceholderView {
                    fetch()
                }
            } else if nodes.isEmpty, !viewModel.comments.isEmpty {
                Text("Тут больше нет непрочитанных комментариев, %username%!")
                    .font(.headline)
            } else {
                List(nodes, children: \.children) { node in
                    let comment = node.value
                    VStack(alignment: .leading) {
                        LepraHTMLView(html: comment.body)
                        Spacer()
                            .frame(height: 8)
                        HStack(alignment: .center) {
                            LepraVotesView(
                                isReversed: true,
                                id: comment.id,
                                rating: comment.rating,
                                userVote: comment.userVote ?? 0,
                                voteWeight: post.voteWeight
                            ) { id, vote in
                                setVote(vote, for: id)
                            } showAction: { id in
                                showVotes(for: id)
                            }
                            Text("\(comment.user.wroteOnceText(when: comment.created))")
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .badge(comment.unread ? "!" : "")
                }
            }
        }
        .sheet(isPresented: $isVotesPresented) {
            LepraSheetView(.medium) {
                if let votes = votesDetailsViewModel.votes {
                    LepraVotesDetailsView(votes: .constant(votes)) {
                        fetchVotes(for: selectedCommentID)
                    }
                } else {
                    LepraTextLoadingIndicatorView()
                        .onAppear {
                            fetchVotes(for: selectedCommentID)
                        }
                }
            }
        }
        #if os(iOS)
        .toolbar(.visible, for: .navigationBar)
        #endif
        .toolbar {
            ToolbarItemGroup {
                Toggle(isOn: $sortByDate) {
                    Text("🕓")
                }
                let sortByRating = Binding(
                    get: { !sortByDate },
                    set: { _ in sortByDate.toggle() }
                )
                Toggle(isOn: sortByRating) {
                    Text("🏆")
                }
            }
            ToolbarItemGroup {
                Toggle(isOn: $showUnreadOnly) {
                    Text(showUnreadOnly ? "📬" : "📭")
                }
                Toggle(isOn: $isChartPresented) {
                    Text("📊")
                }
            }
        }
        .sheet(isPresented: $isChartPresented) {
            LepraSheetView {
                LepraChartView(comments: .constant(viewModel.comments))
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("( ‾́ ◡ ‾́ )"),
                message: Text("\(error?.localizedDescription ?? "(×﹏×)")"),
                dismissButton: .default(Text("(◕‿◕)")) {
                    error = .none
                }
            )
        }
    }

    private func fetch() {
        Task {
            await fetch()
        }
    }

    @MainActor
    private func fetch() async {
        do {
            try await viewModel.fetch(for: post)
        } catch {
            self.error = error
        }
    }

    private func setVote(_ vote: Int, for commentID: LepraComment.ID) {
        Task {
            await setVote(vote, for: commentID)
        }
    }

    @MainActor
    private func setVote(_ vote: Int, for commentID: LepraComment.ID) async {
        try? await votesDetailsViewModel.vote(commentID: commentID, value: vote)
    }

    private func showVotes(for commentID: LepraComment.ID) {
        selectedCommentID = commentID
        votesDetailsViewModel.reset()
        isVotesPresented.toggle()
    }

    private func fetchVotes(for commentID: LepraComment.ID) {
        Task {
            await fetchVotes(for: commentID)
        }
    }

    @MainActor
    private func fetchVotes(for commentID: LepraComment.ID) async {
        isVotesLoading = true
        try? await votesDetailsViewModel.fetchVotes(commentID: commentID)
        isVotesLoading = false
    }
}

struct LepraCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LepraCommentsView(
                post: .constant(.init())
            )
        }
    }
}
