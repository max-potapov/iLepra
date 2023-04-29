//
//  AjaxVote.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import Foundation

// swiftformat:sort
struct AjaxVote: Codable, Hashable {
    let user: AjaxUser?
    let vote: Int
}
