//
//  Drill.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

/// A model representing an earthquake preparedness drill.
struct Drill: Identifiable, Hashable {
    /// Unique identifier for the drill.
    let id = UUID()
    
    /// The category or type of the drill.
    let type: DrillType
    
    /// The display title of the drill.
    let title: String
    
    /// SF Symbol name for the drill's icon.
    let icon: String
    
    /// Expected duration of the drill in minutes.
    let duration: Int
    
    /// The difficulty level of the drill.
    let difficulty: Difficulty
    
    /// A detailed description of the drill's purpose and benefits.
    let description: String
    
    /// An ordered list of high-level steps for completing the drill.
    let steps: [String]
    
    /// Detailed instructions grouped by sections for completing the drill.
    let instructions: [[Instruction]]
    
    /// Indicates if this is a newly added drill.
    let isNew: Bool
    
    /// The date when the drill was last completed by the user, if any.
    var lastCompleted: Date?
    
    /// Represents the difficulty level of a drill.
    enum Difficulty: String {
        /// Basic level suitable for beginners.
        case beginner = "Beginner"
        
        /// Moderate level requiring some experience.
        case intermediate = "Intermediate"
        
        /// Complex level for experienced users.
        case advanced = "Advanced"
        
        /// The color associated with the difficulty level.
        var color: Color {
            switch self {
            case .beginner: return .blue
            case .intermediate: return .orange
            case .advanced: return .red
            }
        }
    }
}
