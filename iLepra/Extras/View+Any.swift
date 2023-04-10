//
//  View+Any.swift
//  iLepra
//
//  Created by Maxim Potapov on 10.04.2023.
//

import SwiftUI

extension View {
    func eraseToAny() -> AnyView {
        .init(self)
    }
}
