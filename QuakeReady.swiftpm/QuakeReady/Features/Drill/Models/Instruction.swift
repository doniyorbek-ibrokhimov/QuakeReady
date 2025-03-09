//
//  Instruction.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

/// Represents a single instruction step within a drill, which can be either an action to take or a warning to heed.
struct Instruction: Hashable {
    /// The textual content of the instruction.
    let text: String
    
    /// Indicates whether this instruction is a warning.
    /// - `true`: Represents a warning or action to avoid
    /// - `false`: Represents a recommended action to take
    let isWarning: Bool
}
