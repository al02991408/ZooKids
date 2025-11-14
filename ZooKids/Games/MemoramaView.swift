//
//  MemoramaView.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

// VISTA PRINCIPAL DEL JUEGO
struct MemoramaView: View {
    let game: Game
    
    @StateObject private var viewModel = MemoramaViewModel()
    
    // 4 columnas para un mejor ajuste de 12 cartas (4x3 = 12 cartas)
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        Color.teal.opacity(0.1).ignoresSafeArea()
        
        VStack {
            
            // 1. Título
            Text(game.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.top, 20)
            
            // 2. Cabecera con Contadores
            HStack {
                Spacer()
                StatBubble(label: "Pares", value: "\(viewModel.matchesFound) / 6", color: .purple)
                Spacer()
                StatBubble(label: "Movimientos", value: "\(viewModel.movesCount)", color: .orange)
                Spacer()
            }
            .padding(.horizontal)
            
            // 3. Mensaje de Feedback
            Text(viewModel.feedbackMessage)
                .font(.headline)
                .fontWeight(.medium)
            // Usamos la lógica de detección de texto para el color
                .foregroundColor(viewModel.feedbackMessage.contains("Felicidades") ? .green.opacity(0.9) : (viewModel.feedbackMessage.contains("Incorrecto") ? .red : .primary))
                .frame(height: 30)
            
            // 4. Tablero de Tarjetas (4x3 Grid)
            VStack {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.cards) { card in
                        MemoramaCardView(card: card, gameColor: game.color)
                            .onTapGesture {
                                viewModel.choose(card: card)
                            }
                    }
                }
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 5)
            .padding(.horizontal)
            
            // 5. Botón para Reiniciar el Juego
            Button("Reiniciar Juego") {
                viewModel.setupGame(with: .animals)
            }
            .font(.title2)
            .fontWeight(.bold)
            .padding(12)
            .frame(maxWidth: 200)
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.top, 20)
            
            Spacer()
        }
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)    }
}

// Previsualización
struct MemoramaView_Previews: PreviewProvider {
    static var previews: some View {
        let memoramaGame = Game(
            title: "Memorama Salvaje", subtitle: "Agiliza tu mente", imageName: "square.stack.3d.up.fill", level: 1, score: 100, color: Color.green, type: .memorama
        )
        NavigationStack {
            MemoramaView(game: memoramaGame)
        }
    }
}
