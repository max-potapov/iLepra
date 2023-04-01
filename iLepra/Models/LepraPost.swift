//
//  LepraPost.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Foundation

// swiftformat:sort
struct LepraPost: Codable, Identifiable, Hashable {
    let body: String // HTML
    let commentsCount: Int
    let created: Date
    let golden: Bool
    let id: Int
    let rating: Int
    let unreadCommentsCount: Int
    let user: LepraUser
    let userVote: Int?
    let voteWeight: Int
}
