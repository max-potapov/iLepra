//
//  LepraPostsView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import SwiftUI

struct LepraPostsView: View {
    @Binding var isLoading: Bool
    @Binding var navigationPath: NavigationPath
    @Binding var posts: [LepraPost]
    let onLastSectionAppear: () -> Void

    var body: some View {
        if posts.isEmpty {
            LepraEmptyContentPlaceholderView {
                onLastSectionAppear()
            }
        } else {
            List {
                ForEach($posts, id: \.self) { $post in
                    Section {
                        LepraPostSectionView(
                            navigationPath: $navigationPath,
                            post: $post
                        )
                    }
                    .onTapGesture {
                        navigationPath.append(post)
                    }
                    #if os(iOS)
                    .onAppear {
                        if post == posts.last {
                            onLastSectionAppear()
                        }
                    }
                    #endif
                }

                LepraLoadingSectionView(isLoading: $isLoading)
            }
            .navigationDestination(for: LepraPost.self) { post in
                LepraCommentsView(
                    post: .constant(post)
                )
            }
        }
    }
}

struct LepraPostsView_Previews: PreviewProvider {
    static var previews: some View {
        LepraPostsView(
            isLoading: .constant(false),
            navigationPath: .constant(.init()),
            posts: .constant([.init()]),
            onLastSectionAppear: {}
        )
    }
}
