//
//  Instruction.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

struct Instruction: Hashable {
    let text: String
    let isWarning: Bool  // true for things to avoid, false for things to do
}
