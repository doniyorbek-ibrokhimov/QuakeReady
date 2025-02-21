//
//  Drill.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

struct Drill: Identifiable, Hashable {
    let id = UUID()
    let type: DrillType
    //FIXME: make it a computed property and get title from `type`
    let title: String
    let icon: String
    let duration: Int
    let difficulty: Difficulty
    let description: String
    let steps: [String]
    let isNew: Bool
    var lastCompleted: Date?
    
    enum Difficulty: String {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var color: Color {
            switch self {
            case .beginner: return .blue
            case .intermediate: return .orange
            case .advanced: return .red
            }
        }
    }
}
