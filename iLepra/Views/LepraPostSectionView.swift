//
//  LepraPostSectionView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import MarkdownUI
import SwiftUI

struct LepraPostSectionView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Binding var navigationPath: NavigationPath
    @Binding var post: LepraPost

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
                Markdown(post.body.htmlToMarkdown())
                    .markdownInlineImageProvider(.webImage)

                Divider()

                Text("\(post.user.wroteOnceText(when: post.created))")

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

                    HStack {
                        Button {
                            // down vote
                        } label: {
                            Image(systemName: post.userVote ?? 0 < 0 ? "minus.square.fill" : "minus.square")
                        }
                        .buttonStyle(.borderless)
                        .tint(.accentColor)

                        Button {
                            // up vote
                        } label: {
                            Image(systemName: post.userVote ?? 0 > 0 ? "plus.square.fill" : "plus.square")
                        }
                        .buttonStyle(.borderless)
                        .tint(.accentColor)

                        Button {
                            // show votes
                        } label: {
                            Text(post.rating.description)
                        }
                        .buttonStyle(.borderless)
                        .tint(.accentColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: useHorizontalLayout ? .leading : .center)
            }
        }
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
