//
//  ProgressCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct ProgressCard: View {
    let title: String
    let icon: String
    let progress: Double
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
            }
            
            ProgressView(value: progress)
                .tint(.blue)
            
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
