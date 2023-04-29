//
//  AjaxUser.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import Foundation

// swiftformat:sort
struct AjaxUser: Codable, Identifiable, Hashable {
    let active: Int
    let deleted: Int
    let gender: LepraGender
    let id: Int
    let ignored: Int?
    let karma: Int
    let login: String
    let rank: String?
}
