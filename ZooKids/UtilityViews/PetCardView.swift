//
//  PetCardView.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Vista auxiliar para el diseño de la tarjeta de la mascota
struct PetCardView: View {

    let option: PetSelectionView.PetOption
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                
                // 1. IMAGEN/ICONO de la Mascota
                Image(option.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                // 2. TEXTO (Nombre y Subtítulo)
                VStack(alignment: .leading) {
                    Text(option.name)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Text("¡Elige a \(option.name)!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 250)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
