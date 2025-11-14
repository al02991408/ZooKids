//
//  Game.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//


import Foundation
import SwiftUI

enum GameType: String {
    case wordJungle = "Jungla de Palabras"
    case letterRace = "Carrera de Letras"
    case memorama = "Memorama Salvaje"
}

// Game.swift
struct Game: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let level: Int
    let score: Int?
    let color: Color
    let type: GameType
}

// Data de ejemplo (simulando los juegos de tu diseño)
extension Game {
    static let minigames = [
        Game(title: "Jungla de Letras", subtitle: "Conecta letras y sonidos", imageName: "a.square.fill", level: 1, score: 100, color: Color.orange, type: .wordJungle),
        Game(title: "Carrera de Letras", subtitle: "Traza el alfabeto", imageName: "pencil.and.outline", level: 1, score: 125, color: Color.blue, type: .letterRace),
        Game(title: "Memorama Salvaje", subtitle: "Agiliza tu mente", imageName: "square.stack.3d.up.fill", level: 1, score: 100, color: Color.green, type: .memorama)
    ]
}
