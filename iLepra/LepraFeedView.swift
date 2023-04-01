//
//  LepraFeedView.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import MarkdownUI
import SwiftSoup
import SwiftUI

struct LepraFeedView: View {
    @EnvironmentObject var viewModel: LepraViewModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var isLoading = false

    var body: some View {
        if viewModel.feedPosts.isEmpty {
            ProgressView()
                .tint(.accentColor)
                .onAppear {
                    fetch()
                }
        } else {
            List {
                ForEach(viewModel.feedPosts.indices, id: \.self) { index in
                    Section {
                        let useHorizontal = dynamicTypeSize <= .accessibility2
                        VStack(alignment: .leading, spacing: useHorizontal ? 8 : 24) {
                            let post = viewModel.feedPosts[index]
                            let doc = try! SwiftSoup.parse(post.body)

                            let nodes = doc.body()!.getChildNodes()
                            let text = nodes.map { node -> String in
                                do {
                                    switch node {
                                    case let element as Element:
                                        let text = try element.text()
                                        switch element.tagNameNormal() {
                                        case "a":
                                            return try! "[" + element.attr("href") + "](" + element.attr("href") + ")"
                                        case "b":
                                            return "**" + text + "**"
                                        case "br":
                                            return ""
                                        case "i":
                                            return "*" + text + "*"
                                        case "img":
                                            return try! "![IMAGE](" + element.attr("src") + ")"
                                        case "span":
                                            return "```" + text + "```"
                                        default:
                                            return "[" + element.tagNameNormal() + "]" + text
                                        }
                                    case let textNode as TextNode:
                                        return textNode.text()
                                    default:
                                        return "N/A"
                                    }
                                } catch {
                                    return "\(error)"
                                }
                            }
                            .filter { !$0.isEmpty }
                            .joined(separator: "  \n")

                            Markdown(text)
                                .markdownInlineImageProvider(.webImage)

                            Divider()

                            Text("\(post.user.wroteOnceText(when: post.created))")

                            let layout = useHorizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 24))

                            layout {
                                Button {
                                    // TODO: open comments
                                } label: {
                                    HStack {
                                        let text = [
                                            "\(post.commentsCount)",
                                            (post.unreadCommentsCount == post.commentsCount) || (post.unreadCommentsCount == 0) ? "" : "/\(post.unreadCommentsCount)",
                                        ]
                                        .joined()

                                        Image(systemName: post.unreadCommentsCount == 0 ? "bubble.right" : "bubble.right.fill")
                                        Text(text)
                                    }
                                }
                                .buttonStyle(.borderless)
                                .tint(.accentColor)

                                if useHorizontal {
                                    Spacer()
                                }

                                HStack {
                                    Button {
                                        // TODO: vote using index
                                    } label: {
                                        Image(systemName: post.userVote ?? 0 < 0 ? "minus.square.fill" : "minus.square")
                                    }
                                    .buttonStyle(.borderless)
                                    .tint(.accentColor)

                                    Button {
                                        // TODO: vote using index
                                    } label: {
                                        Image(systemName: post.userVote ?? 0 > 0 ? "plus.square.fill" : "plus.square")
                                    }
                                    .buttonStyle(.borderless)
                                    .tint(.accentColor)

                                    Text(post.rating.description)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: useHorizontal ? .leading : .center)
                        }
                    }
                    .onAppear {
                        if index == viewModel.feedPosts.indices.last {
                            fetch()
                        }
                    }
                }

                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .tint(.accentColor)
                        Spacer()
                    }
                }
            }
            #if os(macOS)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            #endif
            #if os(iOS)
            .listStyle(.insetGrouped)
            #endif
        }
    }

    func fetch() {
        guard !isLoading else { return }

        defer {
            isLoading = false
        }

        isLoading = true

        Task {
            try await viewModel.fetchFeed()
        }
    }
}

struct LepraFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LepraFeedView()
            .environmentObject(LepraViewModel())
    }
}
