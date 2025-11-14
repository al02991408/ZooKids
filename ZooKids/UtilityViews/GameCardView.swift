//
//  GameCardView.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Vista auxiliar para el diseño de la tarjeta de juego (Card View)
struct GameCardView: View {
    let game: Game
    
    var body: some View {
        HStack(spacing: 15) {
            // 1. Icono del Juego (Izquierda)
            Image(systemName: game.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .foregroundColor(.white)
                .padding(15)
                .background(game.color)
                .cornerRadius(12)
            
            // 2. Información del Juego (Centro)
            VStack(alignment: .leading, spacing: 4) {
                Text(game.title)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                
                Text(game.subtitle)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 3. Nivel y Puntuación (Derecha - Badges)
            VStack(alignment: .trailing, spacing: 4) {
                // Nivel (Badge)
                Text("LVL \(game.level)")
                    .font(.caption)
                    .fontWeight(.heavy)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(game.color.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)

                // Puntuación (Estrella)
                if let score = game.score {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text("\(score)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
