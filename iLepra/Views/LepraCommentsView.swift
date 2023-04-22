//
//  LepraCommentsView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import SwiftUI

struct LepraCommentsView: View {
    @EnvironmentObject private var viewModel: LepraViewModel
    @Binding var post: LepraPost
    @State private var sortByDate: Bool = true
    @State private var showUnreadOnly: Bool = true
    @State private var isChartPresented = false
    @State private var showAlert = false

    @State private var error: Error? {
        didSet {
            showAlert = error != nil
        }
    }

    var body: some View {
        Group {
            let nodes: [LepraNode] = LepraNode.make(
                from: viewModel.postComments,
                sortByDate: sortByDate,
                showUnreadOnly: showUnreadOnly
            )

            if viewModel.postComments.isEmpty {
                LepraEmptyContentPlaceholderView(onAppear: {})
            } else if nodes.isEmpty, !viewModel.postComments.isEmpty {
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
            LepraChartView(comments: .constant(viewModel.postComments))
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
    }
}

struct LepraCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LepraCommentsView(post: .constant(.init()))
                .environmentObject(LepraViewModel())
        }
    }
}
