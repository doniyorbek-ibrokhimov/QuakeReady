//
//  Country.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

struct Country: Identifiable {
    let id: UUID
    let name: String
    let flag: String
    let frequency: String
    let magnitude: Double
    let numberOfEarthquakes: Int
} 
