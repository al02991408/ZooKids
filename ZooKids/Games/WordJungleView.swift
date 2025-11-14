//
//  WordJungleView.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

struct WordJungleView: View {
    let game: Game
    
    @StateObject private var viewModel = WordJungleViewModel()
    
    var body: some View {
        ZStack {
            game.color.opacity(0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // 1. Indicación y Contexto (DIDÁCTICO)
                VStack(spacing: 15) {
                    Text("Encuentra la letra inicial de:")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                    
                    // Pista visual (REALISTA)
                    Text(viewModel.wordHint)
                        .font(.system(size: 80))
                        .frame(height: 80)

                    // La palabra completa
                    Text(viewModel.sampleWord)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                // 2. Botón de Reproducir Sonido (Centrado en el fonema)
                Button(action: viewModel.playSound) {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 60))
                        .frame(width: 120, height: 120) // Botón más pequeño
                        .background(game.color.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.bottom, 10)
                
                // 3. Opciones de Botón (HStack)
                HStack(spacing: 20) {
                    ForEach(viewModel.options, id: \.self) { letter in
                        LetterOptionButton(
                            letter: letter,
                            targetLetter: viewModel.targetLetter,
                            isAnswered: viewModel.isAnswered
                        ) { selectedLetter in
                            viewModel.checkAnswer(selectedLetter: selectedLetter)
                        }
                    }
                }
                
                // 4. Mensaje de Feedback
                Text(viewModel.feedbackMessage)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.isCorrect == true ? .green.opacity(0.9) : .red)
                    .frame(height: 50)
                
                Spacer()
            }
        }
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Previsualización
struct WordJungleView_Previews: PreviewProvider {
    static var previews: some View {
        let game = Game(title: "Jungla de Letras", subtitle: "Conecta letras y sonidos", imageName: "a.square.fill", level: 1, score: 100, color: Color.orange, type: .wordJungle)
        
        WordJungleView(game: game)
    }
}
