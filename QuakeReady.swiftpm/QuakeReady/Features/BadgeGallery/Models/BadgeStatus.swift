//
//  BadgeStatus.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

/// Represents the current state of a badge - either earned or locked
/// 
/// Example:
/// ```
/// // An earned badge with completion date
/// let earnedStatus = BadgeStatus.earned(date: Date())
/// 
/// // A locked badge showing what's needed
/// let lockedStatus = BadgeStatus.locked(criteria: "Complete 3 drills")
/// ```
enum BadgeStatus: Equatable {
    case earned(date: Date)
    case locked(criteria: String)
    
    var isEarned: Bool {
        if case .earned = self { return true }
        return false
    }
}
