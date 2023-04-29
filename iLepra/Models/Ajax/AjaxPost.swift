//
//  AjaxPost.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import Foundation

// swiftformat:sort
struct AjaxPost: Codable, Identifiable, Hashable {
    let body: String // HTML
    let commentsCount: Int
    let created: Date
    let golden: Int
    let id: Int
    let rating: Int
    let unreadCommentsCount: Int
    let user: AjaxUser
    let userVote: AjaxVote?
    let voteWeight: Int
}
