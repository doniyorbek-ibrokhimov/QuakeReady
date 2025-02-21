//
//  ProgressCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A card view that displays progress information for a specific activity.
/// Shows an icon, title, progress bar, and detailed progress information.
struct ProgressCard: View {
    /// The title of the activity being tracked.
    let title: String
    
    /// SF Symbol name for the activity's icon.
    let icon: String
    
    /// Progress value between 0.0 and 1.0.
    let progress: Double
    
    /// Detailed text describing the progress (e.g., "3/5 Complete").
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with icon and title
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
            }
            
            // Progress indicator
            ProgressView(value: progress)
                .tint(.blue)
            
            // Progress details
            Text(detail)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 160)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}
