//
//  RecentDrillsSection.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

extension DrillLibraryView {
    /// A section view that displays a list of recently completed drills.
    /// Shows the drill icon, title, and completion date for each drill.
    struct RecentDrillsSection: View {
        /// Array of drills that have been completed at least once.
        let drills: [Drill]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recently Completed")
                    .font(.headline)
                    .padding(.horizontal)
                
                // List of completed drills with completion dates
                ForEach(drills) { drill in
                    HStack {
                        Text(drill.icon)
                        Text(drill.title)
                            .font(.subheadline)
                        Spacer()
                        if let date = drill.lastCompleted {
                            Text(date, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 32)
        }
    }
}
