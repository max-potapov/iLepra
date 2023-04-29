//
//  RandomAccessCollection+Safe.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import Foundation

extension RandomAccessCollection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    /// - complexity: O(1)
    subscript(safe index: Index) -> Element? {
        guard index >= startIndex, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
