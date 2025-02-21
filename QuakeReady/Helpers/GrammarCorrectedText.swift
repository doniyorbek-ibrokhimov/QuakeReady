//
//  GrammarCorrectedText.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 21/02/25.
//


import SwiftUI

extension View {
    func grammarCorrectedText(count: Int, baseString: String) -> Text {
        Text("^[\(count) \(baseString)](inflect: true)")
    }
}
