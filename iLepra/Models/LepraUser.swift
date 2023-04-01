//
//  LepraUser.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Foundation

// swiftformat:sort
struct LepraUser: Codable, Identifiable, Hashable {
    let active: Bool
    let deleted: Bool
    let gender: LepraGender
    let id: Int
    let isIgnored: Bool
    let login: String
    let rank: String?
}
