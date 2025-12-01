//
//  HomeView.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var gameData: GameData
    @State private var isMascotAnimating = false
    @State private var showMessage = false
    @State private var message = ""
    
    let motivationalPhrases = ["¡Eres genial!", "¡Sigue así!", "¡Muy bien!", "¡Fantástico!"]
    
    var body: some View {
        ZStack {
            // Fondo crema (#F9F1E9)
            Color.zooBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // Header con Nivel y Monedas
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Nivel \(gameData.level)")
                                .font(.headline)
                                .foregroundColor(.zooTextPrimary)
                            
                            // Barra de XP
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(width: geometry.size.width, height: 10)
                                        .opacity(0.3)
                                        .foregroundColor(.gray)
                                    
                                    Rectangle()
                                        .frame(width: min(CGFloat(gameData.xpProgress) * geometry.size.width, geometry.size.width), height: 10)
                                        .foregroundColor(.zooLearning)
                                }
                                .cornerRadius(5)
                            }
                            .frame(height: 10)
                            .frame(width: 100)
                        }
                        
                        Spacer()
                        
                        Text(gameData.currentPet.name)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.zooTextPrimary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Estadísticas con la nueva paleta
                    VStack(spacing: 15) {
                        StatPillView(title: "Alegría", value: "\(Int(gameData.currentPet.happiness))%", color: .zooHappiness)
                        StatPillView(title: "Energía", value: "\(Int(gameData.currentPet.energy))%", color: .zooEnergy)
                        StatPillView(title: "Aprendizaje", value: "\(Int(gameData.currentPet.learningScore))%", color: .zooLearning)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    .background(Color.zooCard) // #FFFFFF
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        Image(gameData.currentPet.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300) // Ajustado tamaño
                            .shadow(color: .zooPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                            .scaleEffect(isMascotAnimating ? 1.1 : 1.0)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
                                    isMascotAnimating = true
                                }
                                
                                gameData.playWithMascot()
                                message = motivationalPhrases.randomElement() ?? "¡Hola!"
                                showMessage = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        isMascotAnimating = false
                                    }
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        showMessage = false
                                    }
                                }
                            }
                            .accessibilityLabel("Mascota \(gameData.currentPet.name)")
                            .accessibilityHint("Toca para jugar con ella y ganar experiencia.")
                            .accessibilityAddTraits(.isButton)
                        
                        if showMessage {
                            Text(message)
                                .font(.headline)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .offset(y: -180)
                                .transition(.scale)
                        }
                    }
                    .padding(.bottom, 30)
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
