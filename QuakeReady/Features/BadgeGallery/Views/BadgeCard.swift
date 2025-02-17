import SwiftUI

struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
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
            
            // Title
            Text(badge.title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            // Status
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

struct BadgeDetailView: View {
    let badge: Badge
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            Image(systemName: badge.icon)
                .font(.system(size: 64))
                .foregroundColor(badge.status.isEarned ? .yellow : .gray)
            
            Text(badge.title)
                .font(.title2.bold())
            
            Text(badge.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            statusDetail
            
            Spacer()
            
            Button("Close") {
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.blue)
        }
        .padding()
        .foregroundColor(.white)
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium])
    }
    
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
