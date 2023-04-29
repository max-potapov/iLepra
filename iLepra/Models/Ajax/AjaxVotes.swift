//
//  AjaxVotes.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import Foundation

// swiftformat:sort
struct AjaxVotes: Codable, Hashable {
    let cons: [AjaxVote]
    let consCount: Int
    let offset: Int?
    let pros: [AjaxVote]
    let prosCount: Int
    let rating: Int
    let status: String
    let totalCount: Int

    init(
        cons: [AjaxVote],
        consCount: Int,
        offset: Int? = nil,
        pros: [AjaxVote],
        prosCount: Int,
        rating: Int,
        status: String,
        totalCount: Int
    ) {
        self.cons = cons
        self.consCount = consCount
        self.offset = offset
        self.pros = pros
        self.prosCount = prosCount
        self.rating = rating
        self.status = status
        self.totalCount = totalCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cons = (try? container.decode([AjaxVote].self, forKey: .cons)) ?? []
        consCount = try container.decode(Int.self, forKey: .consCount)
        offset = try container.decodeIfPresent(Int.self, forKey: .offset)
        pros = (try? container.decode([AjaxVote].self, forKey: .pros)) ?? []
        prosCount = try container.decode(Int.self, forKey: .prosCount)
        rating = try container.decode(Int.self, forKey: .rating)
        status = try container.decode(String.self, forKey: .status)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
    }
}
