//
//  Badge.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A badge that users can earn by completing various earthquake safety challenges
/// 
/// Example:
/// ```
/// let quickLearnerBadge = Badge(
///     type: .quickLearner,
///     status: .locked(criteria: "Score 100% on 5 Quizzes")
/// )
/// ```
struct Badge: Identifiable {
    let id = UUID()
    let type: BadgeType
    var status: BadgeStatus
    
    // Computed properties for easy access to badge details
    var title: String { type.title }
    var icon: String { type.icon }
    var description: String { type.description }
} 
