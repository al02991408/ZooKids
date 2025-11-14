//
//  LetterOptionButton.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Vista auxiliar para el botón de opción de letra
struct LetterOptionButton: View {
    let letter: String
    let targetLetter: String
    let isAnswered: Bool
    var action: (String) -> Void
    
    var backgroundColor: Color {
        guard isAnswered else { return .white }
        
        // Si ya se respondió, muestra el color de feedback
        if letter == targetLetter {
            return .green
        } else if letter != targetLetter {
            return .red
        }
        return .white
    }
    
    var body: some View {
        Button {
            action(letter)
        } label: {
            Text(letter)
                .font(.system(size: 60, weight: .heavy, design: .rounded))
                .frame(width: 80, height: 80)
                .background(backgroundColor)
                .foregroundColor(isAnswered ? .white : .primary)
                .cornerRadius(15)
                .shadow(radius: 3)
        }
        .disabled(isAnswered) // Deshabilitar después de la respuesta
        .animation(.default, value: isAnswered)
    }
}


// Preview 2 (botones de letras)
struct LetterOptionButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            // Caso: Sin responder
            LetterOptionButton(letter: "M", targetLetter: "P", isAnswered: false, action: {_ in})
            
            // Caso: Respuesta correcta
            LetterOptionButton(letter: "P", targetLetter: "P", isAnswered: true, action: {_ in})
            
            // Caso: Respuesta incorrecta
            LetterOptionButton(letter: "S", targetLetter: "P", isAnswered: true, action: {_ in})
        }
        .padding()
        .previewLayout(.sizeThatFits) // Para mostrar solo el contenido
    }
}
