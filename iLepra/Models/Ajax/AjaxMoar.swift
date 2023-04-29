//
//  AjaxMoar.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import Foundation

// swiftformat:sort
struct AjaxMoar: Codable, Hashable {
    let docs: [AjaxPost]
    let offset: Int
    let status: String
    let unreadCount: [Int]
}
