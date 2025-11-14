//
//  StatBubble.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

struct StatBubble: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 3)
    }
}
