//
//  GameDetailView.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Vista de destino (Router)
struct GameDetailView: View {
    let game: Game
    
    var body: some View {
        // Eligen qué vista renderizar basándose en el tipo de juego
        switch game.type {
        case .wordJungle:
            WordJungleView(game: game)
        case .letterRace:
            LetterRaceView(game: game)
        case .memorama:
            MemoramaView(game: game)
        }
    }
}
