//
//  Country.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

/// A model representing a country and its earthquake risk metrics.
struct Country: Identifiable {
    /// Unique identifier for the country.
    let id: UUID
    
    /// The name of the country.
    let name: String
    
    /// The country's flag emoji.
    let flag: String
    
    /// The frequency of earthquakes, expressed as a descriptive string (e.g., "High", "Medium", "Low").
    let frequency: String
    
    /// The average magnitude of earthquakes in this country.
    let magnitude: Double
    
    /// The total number of recorded earthquakes in this country.
    let numberOfEarthquakes: Int
} 
