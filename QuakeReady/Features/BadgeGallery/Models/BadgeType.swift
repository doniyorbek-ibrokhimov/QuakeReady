//
//  BadgeType.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

/// Different badges users can earn in QuakeReady
/// 
/// Each badge type comes with:
/// - A friendly title for display
/// - An SF Symbol icon name
/// - A description of the achievement
/// - Specific criteria for earning it
///
/// Example:
/// ```
/// let badge = BadgeType.quickLearner
/// print(badge.title) // "Quick Learner"
/// print(badge.icon)  // "bolt.fill"
/// ```
enum BadgeType: String, CaseIterable {
    case quickLearner
    case drillBeginner
    case drillMaster 
    case safetyScholar
    case globalGuardian
    
    var title: String {
        switch self {
        case .quickLearner: return "Quick Learner"
        case .drillBeginner: return "Drill Beginner"
        case .drillMaster: return "Drill Master"
        case .safetyScholar: return "Safety Scholar"
        case .globalGuardian: return "Global Guardian"
        }
    }
    
    var icon: String {
        switch self {
        case .quickLearner: return "bolt.fill"
        case .drillBeginner: return "figure.walk"
        case .drillMaster: return "figure.run"
        case .safetyScholar: return "book.closed.fill"
        case .globalGuardian: return "globe"
        }
    }
    
    var description: String {
        switch self {
        case .quickLearner: return "Awarded for completing your first quiz"
        case .drillBeginner: return "Completed your first earthquake drill"
        case .drillMaster: return "Completed 3 earthquake drills"
        case .safetyScholar: return "Become a safety expert"
        case .globalGuardian: return "Explore earthquake risks worldwide"
        }
    }
    
    var criteria: String {
        switch self {
        case .quickLearner: return "Score 100% on 5 Quizzes"
        case .drillBeginner: return "Complete your first drill"
        case .drillMaster: return "Complete 3 earthquake drills"
        case .safetyScholar: return "Score 100% on all quizzes"
        case .globalGuardian: return "View 10 Countries"
        }
    }
}

