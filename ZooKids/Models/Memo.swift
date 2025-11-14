//
//  Memo.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

import Foundation
import SwiftUI // Necesario para el Color

// 1. Estructura para una Tarjeta del Memorama
struct MemoCard: Identifiable, Equatable {
    let id = UUID()
    let content: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var isIncorrect: Bool = false
}

// 2. Enum para el Tipo de Memorama (por si en el futuro quieres diferentes temas)
enum MemoramaTheme {
    case animals
    case fruits
    case letters
}

// 3. Extensión para obtener contenido según el tema
extension MemoramaTheme {
    var cardContents: [String] {
        switch self {
        case .animals:
            // 6 pares = 12 cartas.
            return ["🐸", "🐶", "🐻", "🐵", "🐘", "🦁"]
        case .fruits:
            return ["🍎", "🍌", "🍊", "🍇", "🍓", "🍍", "🥭", "🥝"]
        case .letters:
            return ["A", "B", "C", "D", "E", "F", "G", "H"]
        }
    }
}
