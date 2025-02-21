//
//  Question.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import Foundation

struct Question: Hashable {
    let scenario: String
    let options: [String]
    let correctIndex: Int
    let feedback: String
}
