//
//  MemoramaCardView.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Vista auxiliar para la tarjeta
struct MemoramaCardView: View {
    let card: MemoCard
    let gameColor: Color
    
    @State private var matchEffectOpacity: Double = 0.0
    @State private var incorrectEffectOpacity: Double = 0.0
    
    var backGradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [gameColor.opacity(0.9), gameColor.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 10)
            
            // LÓGICA PRINCIPAL: ¿La carta está volteada hacia arriba o emparejada?
            if card.isFaceUp || card.isMatched {
                
                // 1. Fondo de la Cara
                shape
                    .fill(Color.white)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        shape
                            .stroke(card.isMatched ? Color.green.opacity(0.8) : (card.isIncorrect ? Color.red.opacity(0.8) : Color.gray.opacity(0.3)), lineWidth: card.isMatched ? 3 : 1)
                    )
                    .shadow(radius: 1)
                
                // 2. Contenido (Emoji)
                Text(card.content)
                    .font(.system(size: 40))

                // 3. ICONO DE CHECKMARK (Match)
                if card.isMatched {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                        .scaleEffect(matchEffectOpacity > 0.0 ? 1.2 : 1.0)
                        .opacity(matchEffectOpacity)
                        .offset(x: -50, y: -50)
                }
                
                // 4. ICONO DE ERROR (Xmark)
                if card.isIncorrect {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                        .scaleEffect(incorrectEffectOpacity > 0.0 ? 1.2 : 1.0)
                        .opacity(incorrectEffectOpacity)
                        .offset(x: -50, y: -50)
                }
                
            } else {
                // LÓGICA ELSE: La carta está volteada hacia abajo (Parte Trasera)
                shape
                    .fill(backGradient)
                    .aspectRatio(1, contentMode: .fit)
                    .shadow(radius: 1)
            }
        }
        // Animación de volteo (DURACIÓN AUMENTADA A 1.0s)
        .rotation3DEffect(.degrees(card.isFaceUp || card.isMatched ? 0 : 180), axis: (0, 1, 0))
        .animation(.spring(response: 1.0, dampingFraction: 0.6), value: card.isFaceUp) // <-- MÁS LENTA
        .animation(.spring(response: 1.0, dampingFraction: 0.6), value: card.isMatched) // <-- MÁS LENTA
        
        // OBSERVER para el Checkmark (Se mantiene igual)
        .onChange(of: card.isMatched) { isMatched in
            if isMatched {
                matchEffectOpacity = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        matchEffectOpacity = 0.0
                    }
                }
            } else {
                matchEffectOpacity = 0.0
            }
        }
        
        // OBSERVER para la 'X' de Error (Ahora el fade funciona correctamente)
        .onChange(of: card.isIncorrect) { isIncorrect in
            if isIncorrect {
                incorrectEffectOpacity = 1.0
                
                // Programar el fade out (el retraso del fade debe ser más corto que el retraso del ViewModel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Nota: El ViewModel espera 1.0s para voltear la carta
                    withAnimation(.easeOut(duration: 0.5)) {
                        incorrectEffectOpacity = 0.0 // Desaparece
                    }
                }
            } else {
                incorrectEffectOpacity = 0.0
            }
        }
    }
}
