//
//  Question.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

/// A model representing a single quiz question with multiple choice options.
struct Question: Hashable {
    /// The scenario or question text presented to the user.
    let scenario: String
    
    /// Array of possible answers for the question.
    let options: [String]
    
    /// The index of the correct answer in the options array (0-based).
    let correctIndex: Int
    
    /// Explanatory text shown after the user answers, explaining why the correct answer is right.
    let feedback: String
}
