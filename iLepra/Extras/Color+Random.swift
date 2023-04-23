//
//  Color+Random.swift
//  iLepra
//
//  Created by Maxim Potapov on 22.04.2023.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var random: Self {
        .init(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1)
        )
    }
}
