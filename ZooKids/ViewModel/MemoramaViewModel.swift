//
//  MemoramaViewModel.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI
import Combine

final class MemoramaViewModel: ObservableObject {
    @Published var cards: [MemoCard] = []
    @Published var feedbackMessage: String = "¡Encuentra los pares!"
    @Published var matchesFound: Int = 0
    @Published var movesCount: Int = 0 // NUEVO: Contador de movimientos
    
    // Almacena el índice de la única tarjeta volteada
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp && !cards[$0].isMatched }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
        }
        set {
            // Esto voltea todas las cartas hacia abajo, excepto la nueva.
            cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) }
        }
    }
    
    init(theme: MemoramaTheme = .animals) {
        setupGame(with: theme)
    }
    
    func setupGame(with theme: MemoramaTheme) {
        // Reiniciar contadores
        matchesFound = 0
        movesCount = 0
        feedbackMessage = "¡Encuentra los pares!"
        
        let originalContents = theme.cardContents
        // Aseguramos que la lista se duplique para 6 pares = 12 cartas
        let pairedContents = (originalContents + originalContents).shuffled()
        
        cards = pairedContents.map { content in
            MemoCard(content: content)
        }
    }
    
    // Lógica para manejar el toque de una tarjeta
    func choose(card: MemoCard) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFaceUp,
              !cards[chosenIndex].isMatched else {
            return // Ignorar si ya está volteada o emparejada
        }
        
        // Antes de cualquier acción, limpiar el estado de 'incorrecto' de todas las cartas
        cards.indices.forEach { cards[$0].isIncorrect = false }
        
        // Caso 1: Hay una tarjeta volteada
        if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
            
            movesCount += 1 // Contar el movimiento (segunda carta)
            cards[chosenIndex].isFaceUp = true
            
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                // ¡MATCH!
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
                matchesFound += 1
                feedbackMessage = "¡Par encontrado! ¡\(matchesFound) de 6! 🎉"
                
                if matchesFound == 6 { // La condición final para 12 cartas
                    feedbackMessage = "¡Felicidades! Ganaste en \(movesCount) movimientos! 🏆"
                }
                
                // Limpiar índice ya que ambas están emparejadas/volteadas
                indexOfOneAndOnlyFaceUpCard = nil
                
            } else {
                // NO MATCH
                cards[chosenIndex].isIncorrect = true
                cards[potentialMatchIndex].isIncorrect = true
                feedbackMessage = "Incorrecto. Intenta de nuevo. 😔"
                
                // Voltear ambas tarjetas hacia abajo después de un retraso
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.cards[chosenIndex].isFaceUp = false
                    self.cards[potentialMatchIndex].isFaceUp = false
                    self.cards[chosenIndex].isIncorrect = false
                    self.cards[potentialMatchIndex].isIncorrect = false
                    self.feedbackMessage = "¡Encuentra los pares!"
                }
            }
            
        } else {
            // Caso 2: No hay tarjetas volteadas o se acaba de reiniciar el error (volteamos la primera)
            cards.indices.forEach { cards[$0].isFaceUp = false } // Asegurar que solo una esté volteada
            cards[chosenIndex].isFaceUp = true
            indexOfOneAndOnlyFaceUpCard = chosenIndex
            // El contador no se incrementa hasta que se voltea la segunda carta.
        }
    }
}
