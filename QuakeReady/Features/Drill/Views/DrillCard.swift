//
//  DrillCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

extension DrillLibraryView {
    /// A card-style view that displays information about a single drill.
    /// The card can be expanded to show additional details about the drill.
    struct DrillCard: View {
        /// The drill to display in the card.
        let drill: Drill
        
        /// Controls whether the card is expanded to show the drill description.
        @State private var isExpanded = false
        
        var body: some View {
            VStack(spacing: 16) {
                // Header section with drill info
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
                    
                    Button {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .foregroundColor(.gray)
                    }
                }
                
                // Expandable description section
                if isExpanded {
                    Text(drill.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
}
