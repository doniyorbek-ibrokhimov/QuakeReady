//
//  DrillCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

extension DrillLibraryView {
    struct DrillCard: View {
        let drill: Drill
        
        var body: some View {
            HStack(spacing: 16) {
                Text(drill.icon)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(drill.title)
                            .font(.headline)
                        if drill.isNew {
                            Text("NEW")
                                .font(.caption2.bold())
                                .foregroundColor(.green)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    
                    HStack {
                        Text("Duration: \(drill.duration)s")
                        Text("•")
                        Text(drill.difficulty.rawValue)
                            .foregroundColor(drill.difficulty.color)
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
}
