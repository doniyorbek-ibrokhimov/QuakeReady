//
//  BadgeDetailView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A detailed view showing more information about a badge
struct BadgeDetailView: View {
    let badge: Badge
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Large badge icon
            Image(systemName: badge.icon)
                .font(.system(size: 64))
                .foregroundColor(badge.status.isEarned ? .yellow : .gray)
            
            // Badge title
            Text(badge.title)
                .font(.title2.bold())
            
            // Badge description (shown only if earned)
            if badge.status.isEarned {
                Text(badge.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            
            // Detailed status
            statusDetail
        }
        .padding()
        .padding(.top, 32)
        .foregroundColor(.white)
        .presentationDragIndicator(.visible)
        .presentationDetents([.fraction(0.35)])
        .presentationBackground(.thinMaterial)
    }
    
    /// Displays detailed status information
    @ViewBuilder
    private var statusDetail: some View {
        switch badge.status {
        case .earned(let date):
            Text("Earned on \(date.formatted(.dateTime.month().day().year()))")
                .font(.subheadline)
                .foregroundColor(.green)
        case .locked(let criteria):
            Text("Locked: \(criteria)")
                .font(.subheadline)
                .foregroundColor(.orange)
        }
    }
} 
