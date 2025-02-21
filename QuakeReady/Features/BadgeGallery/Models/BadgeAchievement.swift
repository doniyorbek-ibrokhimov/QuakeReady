//
//  BadgeAchievement.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftData
import Foundation

/// Represents a badge that the user has earned, persisted using SwiftData
/// 
/// This model stores when a specific badge was earned, making it perfect for:
/// - Tracking user progress over time
/// - Displaying achievement dates in the badge gallery
/// - Persisting badge data between app launches
@Model
class BadgeAchievement {
    let type: String // We'll store BadgeType's rawValue
    let earnedDate: Date
    
    init(type: String, earnedDate: Date) {
        self.type = type
        self.earnedDate = earnedDate
    }
} 