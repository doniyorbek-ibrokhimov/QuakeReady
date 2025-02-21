//
//  BadgeStatus.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

enum BadgeStatus: Equatable {
    case earned(date: Date)
    case locked(criteria: String)
    
    var isEarned: Bool {
        if case .earned = self { return true }
        return false
    }
}
