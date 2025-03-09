//
//  Extensions.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

extension Collection {
    /// Safely access an element at a given index.
    /// Returns nil if the index is out of bounds.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension View {
    /// Correctly pluralizes a base string based on a count.
    /// - Parameters:
    ///   - count: The number of items to pluralize the string for
    ///   - baseString: The base string to pluralize
    /// - Returns: A Text view with the pluralized string
    func grammarCorrectedText(count: Int, baseString: String) -> Text {
        Text("^[\(count) \(baseString)](inflect: true)")
    }
}
