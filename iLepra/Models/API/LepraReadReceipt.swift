//
//  LepraReadReceipt.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import Foundation

// swiftformat:sort
struct LepraReadReceipt: Codable, Hashable {
    let commentsRead: Int
    let lastRead: Date
    let postId: Int
    let viewsCount: Int
}
