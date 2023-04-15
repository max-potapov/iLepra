//
//  LepraComment.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import Foundation

// swiftformat:sort
struct LepraComment: Codable, Identifiable, Hashable {
    let body: String
    let canBan: Bool
    let canDelete: Bool
    let canEdit: Bool
    let canModerate: Bool
    let canRemoveCommentThreads: Bool
    let created: Date
    let dateOrder: Int
    let id: Int
    let parentId: ID?
    let rating: Int
    let ratingOrder: Int
    let treeLevel: Int
    let unread: Bool
    let user: LepraUser
    let userVote: Int?
}
