//
//  WelcomeView.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//
import SwiftUI

struct WelcomeView: View {
    var nextAction: () -> Void
    
    var body: some View {
        ZStack {
            // 1. Foto bienvenida
             Image("zookids-bg")
                 .resizable()
                 .scaledToFill()
                 .ignoresSafeArea()
            
            VStack {
                Spacer() 
                
                // 2. Botón "JUGAR"
                Button(action: nextAction) {
                    Text("JUGAR")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 95)
                        .padding(.vertical, 20)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)                 .padding(.bottom, 80)
            }
        }
    }
}

// Previsualización
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(nextAction: {})

    }
}
