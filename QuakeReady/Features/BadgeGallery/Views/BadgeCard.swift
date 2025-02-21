//
//  BadgeCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A card view that displays a badge's icon, title, and status
///
/// Features:
/// - Glowing effect for earned badges
/// - Dimmed appearance for locked badges
/// - Status-specific text display
struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 12) {
            // Badge icon with glow effect when earned
            Image(systemName: badge.icon)
                .font(.system(size: 32))
                .foregroundColor(badge.status.isEarned ? .yellow : .gray)
                .overlay(
                    badge.status.isEarned ? 
                        Color.yellow
                            .opacity(0.3)
                            .blur(radius: 10)
                        : nil
                )
            
            // Badge title
            Text(badge.title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            // Badge status (earned date or unlock criteria)
            statusView
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(badge.status.isEarned ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 1)
        )
        .opacity(badge.status.isEarned ? 1 : 0.4)
    }
    
    /// Displays either the earned date or unlock criteria based on badge status
    @ViewBuilder
    private var statusView: some View {
        switch badge.status {
        case .earned(let date):
            Text("Earned: \(date.formatted(.dateTime.month().day()))")
                .font(.caption2)
                .foregroundColor(.gray)
        case .locked(let criteria):
            Text(criteria)
                .font(.caption2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}