//
//  LepraCommentsView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import MarkdownUI
import SwiftUI

struct LepraCommentsView: View {
    @EnvironmentObject var viewModel: LepraViewModel
    @Binding var post: LepraPost
    @State private var showAlert = false

    @State private var error: Error? {
        didSet {
            showAlert = error != nil
        }
    }

    var body: some View {
        ZStack {
            let nodes = LepraNode<LepraComment>.make(from: viewModel.postComments)

            if viewModel.postComments.isEmpty {
                LepraEmptyContentPlaceholderView(onAppear: {})
            } else if nodes.isEmpty, !viewModel.postComments.isEmpty {
                Text("Тут больше нет непрочитанных комментариев, %username%!")
                    .font(.headline)
            } else {
                List(nodes, children: \.children) { node in
                    let comment = node.value
                    VStack(alignment: .leading) {
                        Markdown(comment.body.htmlToMarkdown())
                            .markdownInlineImageProvider(.webImage)
                        Spacer()
                            .frame(height: 8)
                        HStack(alignment: .center) {
                            LepraVotesView(isReversed: true, rating: comment.rating, userVote: comment.userVote)
                            Text("\(comment.user.wroteOnceText(when: comment.created))")
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .badge(comment.unread ? "!" : "")
                }
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
        .task {
            do {
                try await viewModel.fetchComments(for: post)
            } catch {
                self.error = error
            }
        }
        .navigationTitle("💩🪭🤬")
    }
}

struct LepraCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        LepraCommentsView(post: .constant(.init()))
            .environmentObject(LepraViewModel())
    }
}
