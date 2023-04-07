//
//  Models+Mocks.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import Foundation

extension LepraDomain {
    init() {
        description = "<b>description</b>"
        id = .random(in: 0 ..< 100)
        isInBookmarks = .random()
        isSubscribed = .random()
        logoUrl = URL(string: "https://localhost")!
        name = ["idiod", "cinema", "divan"].randomElement() ?? "n/a"
        owner = .init()
        prefix = name
        readersCount = .random(in: 0 ..< 100)
        title = name
    }
}

extension LepraPost {
    init() {
        body = "kek"
        commentsCount = .random(in: 0 ..< 10)
        created = .distantPast
        golden = .random()
        id = .random(in: 0 ..< 100)
        rating = .random(in: 0 ..< 100)
        unreadCommentsCount = .random(in: 0 ..< 100)
        user = .init()
        userVote = .random(in: -10 ..< 10)
        voteWeight = .random(in: -10 ..< 10)
    }
}

extension LepraUser {
    init() {
        active = .random()
        deleted = .random()
        gender = Bool.random() ? .female : .male
        id = .random(in: 0 ..< 100)
        isIgnored = [true, false].randomElement()
        login = ["john", "bob", "kate"].randomElement() ?? ""
        rank = ["kek", "lol"].randomElement()
    }
}
