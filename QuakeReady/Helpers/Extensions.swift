//
//  Extensions.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension View {
    func grammarCorrectedText(count: Int, baseString: String) -> Text {
        Text("^[\(count) \(baseString)](inflect: true)")
    }
}
