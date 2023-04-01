//
//  LepraDomain.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Foundation

// swiftformat:sort
struct LepraDomain: Codable, Identifiable, Hashable {
    let description: String // HTML
    let id: Int
    let isInBookmarks: Bool
    let isSubscribed: Bool
    let logoUrl: URL
    let name: String
    let owner: LepraUser
    let prefix: String
    let readersCount: Int
    let title: String
}
