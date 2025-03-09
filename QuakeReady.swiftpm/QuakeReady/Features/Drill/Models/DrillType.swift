//
//  DrillType.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import Foundation

/// Represents different types of earthquake safety drills available in the app.
enum DrillType: String, CaseIterable {
    /// Basic earthquake safety protocol teaching drop, cover, and hold on techniques.
    case basic = "Basic Drop-Cover-Hold"
    
    /// Safety procedures for when an earthquake occurs while in or near elevators.
    case elevator = "Elevator Safety Protocol"
    
    /// Safety procedures for managing earthquake situations in crowded spaces.
    case crowd = "Crowded Space Protocol"
}
