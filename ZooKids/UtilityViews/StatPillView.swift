//
//  StatPillView.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Vista auxiliar para mostrar las estadísticas
struct StatPillView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(color)
                    .font(.title2)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.zooTextPrimary) // #2B2F2F
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(.zooTextPrimary) // #2B2F2F

            // Barra de progreso
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Fondo de la barra
                    Capsule()
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                    
                    // Progreso
                    Capsule()
                        .fill(color)
                        .frame(width: max(8, CGFloat(progressValue) * geometry.size.width), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(Color.zooCard) // #FFFFFF
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.zooBorder.opacity(0.3), lineWidth: 1) // #B2ECF6
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
    
    private var iconName: String {
        switch title {
        case "Alegría": return "heart.circle.fill"
        case "Energía": return "bolt.circle.fill"
        case "Aprendizaje": return "graduationcap.circle.fill"
        default: return "star.circle.fill"
        }
    }
    
    private var progressValue: Double {
        let cleanValue = value.replacingOccurrences(of: "%", with: "")
        return (Double(cleanValue) ?? 0) / 100
    }
}
