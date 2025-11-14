//
//  HomeView.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var gameData: GameData
    
    var body: some View {
        ZStack {
            // Fondo crema (#F9F1E9)
            Color.zooBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    Text(gameData.currentPet.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.zooTextPrimary) // #2B2F2F
                        .padding(.top, 20)
                    
                    // Estadísticas con la nueva paleta
                    VStack(spacing: 15) {
                        StatPillView(title: "Alegría", value: "\(gameData.currentPet.happiness)%", color: .zooHappiness)    // #FF2D55
                        StatPillView(title: "Energía", value: "\(gameData.currentPet.energy)%", color: .zooEnergy)          // #FFCC00
                        StatPillView(title: "Aprendizaje", value: "\(gameData.currentPet.learningScore)%", color: .zooLearning) // #0088FF
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    .background(Color.zooCard) // #FFFFFF
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal, 20)
                    
                    Image(gameData.currentPet.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 500)
                        .padding(.bottom, 30)
                        .shadow(color: .zooPrimary.opacity(0.3), radius: 10, x: 0, y: 5) // Sombra azul cielo (#56BDFC)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

// Previsualización
struct HomeView_Previews: PreviewProvider {
    static let mockGameData: GameData = {
        let data = GameData()
        data.currentPet = Pet(
            name: "Panda",
            animalType: .panda,
            happiness: 90,
            energy: 70,
            learningScore: 80,
            imageName: "panda"
        )
        data.hasSelectedPet = true
        return data
    }()
    
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
        .environmentObject(mockGameData)
    }
}
