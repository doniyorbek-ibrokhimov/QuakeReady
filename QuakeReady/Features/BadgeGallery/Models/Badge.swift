//
//  Badge.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct Badge: Identifiable {
    let id = UUID()
    let type: BadgeType
    var status: BadgeStatus
    
    var title: String { type.title }
    var icon: String { type.icon }
    var description: String { type.description }
} 
