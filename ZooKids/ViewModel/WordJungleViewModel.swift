//
// WordJungleViewModel.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//


import SwiftUI
import Combine
import AVFoundation

// Estructura de datos para un mayor realismo y contexto
struct PhonicsRoundData {
    let letter: String  // La letra correcta
    let word: String    // La palabra que empieza con esa letra
    let hint: String    // Emoji o SFSymbol para la pista visual
}

final class WordJungleViewModel: ObservableObject {
    // Conjunto de datos didácticos: Letra, Palabra de ejemplo, Pista visual (Emoji)
    private let dataSet: [PhonicsRoundData] = [
        .init(letter: "A", word: "ABEJA", hint: "🐝"),
        .init(letter: "E", word: "ESTRELLA", hint: "⭐️"),
        .init(letter: "I", word: "ISLA", hint: "🏝️"),
        .init(letter: "O", word: "OJO", hint: "👁️"),
        .init(letter: "U", word: "UÑAS", hint: "💅"),
        .init(letter: "M", word: "MANO", hint: "✋"),
        .init(letter: "P", word: "PEZ", hint: "🐟"),
        .init(letter: "S", word: "SOL", hint: "☀️"),
        .init(letter: "L", word: "LEÓN", hint: "🦁"),
        .init(letter: "T", word: "TELÉFONO", hint: "📞")
    ]
    
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var targetLetter: String = ""
    @Published var sampleWord: String = ""    // NUEVO: La palabra de ejemplo
    @Published var wordHint: String = ""      // NUEVO: El hint visual
    @Published var options: [String] = []
    @Published var feedbackMessage: String = ""
    @Published var isAnswered: Bool = false
    @Published var isCorrect: Bool? = nil

    init() {
        loadNewRound()
    }
    
    func loadNewRound() {
        feedbackMessage = ""
        isAnswered = false
        isCorrect = nil
        
        // 1. Elegir datos didácticos aleatorios
        guard let newRoundData = dataSet.randomElement() else { return }
        
        targetLetter = newRoundData.letter
        sampleWord = newRoundData.word       // Guardamos la palabra
        wordHint = newRoundData.hint         // Guardamos la pista
        
        // 2. Lógica para las opciones incorrectas (se mantiene igual)
        var incorrectOptions = Set<String>()
        while incorrectOptions.count < 2 {
            if let randomLetter = dataSet.randomElement()?.letter, randomLetter != targetLetter {
                incorrectOptions.insert(randomLetter)
            }
        }
        
        var allOptions = Array(incorrectOptions)
        allOptions.append(targetLetter)
        options = allOptions.shuffled()
    }
    
    // Verifica si la letra seleccionada es la correcta
    func checkAnswer(selectedLetter: String) {
        if isAnswered { return } // Evita múltiples clics
        
        isAnswered = true
        
        if selectedLetter == targetLetter {
            feedbackMessage = "¡Excelente! Has identificado el sonido de la '\(targetLetter)' 🎉"
            isCorrect = true
            // Lógica de recompensa: gameData.addCoins(10)
            
            // Cargar la siguiente ronda después de un breve retraso
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.loadNewRound()
            }
        } else {
            feedbackMessage = "Incorrecto. ¡Inténtalo de nuevo! El sonido era la '\(targetLetter)' 🤔"
            isCorrect = false
        }
    }
    
    // Función auxiliar para forzar el sonido fonético (en minúsculas)
    private func getPhoneticSound(for letter: String) -> String {
        switch letter {
        case "A", "E", "I", "O", "U":
            return letter.lowercased()
        case "M":
            return "ma"
        case "P":
            return "pe"
        case "S":
            return "so"
        case "L":
            return "le"
        case "T":
            return "te"
        default:
            return letter.lowercased()
        }
    }
    
    // Función de sonido
    func playSound() {
        synthesizer.stopSpeaking(at: .immediate)
        let phoneticString = getPhoneticSound(for: targetLetter)
        
        let utterance = AVSpeechUtterance(string: phoneticString)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.25 // Velocidad muy lenta para aislar el fonema
        
        synthesizer.speak(utterance)
    }
}
