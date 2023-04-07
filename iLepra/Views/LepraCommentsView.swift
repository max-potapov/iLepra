//
//  LepraCommentsView.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import SwiftUI

struct LepraCommentsView: View {
    @Binding var post: LepraPost

    var body: some View {
        Text("\(post.commentsCount) comments")
    }
}

struct LepraCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        LepraCommentsView(post: .constant(.init()))
    }
}
