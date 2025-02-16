//
//  RecentDrillsSection.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

extension DrillLibraryView {
    struct RecentDrillsSection: View {
        let drills: [Drill]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recently Completed")
                    .font(.headline)
                    .padding(.horizontal)
                
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
