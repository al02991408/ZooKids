//
//  GamesMenuView.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//


import SwiftUI

struct GamesMenuView: View {
    
    private let gridItemLayout = [GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.95, blue: 0.95)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("¡Elige un juego para aprender!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 15) {
                        ForEach(Game.minigames) { game in
                            NavigationLink(destination: GameDetailView(game: game)) {
                                GameCardView(game: game)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Minijuegos")
        .navigationBarTitleDisplayMode(.large)
    }
}

// PREVISUALIZACIÓN
struct GamesMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GamesMenuView()
        }
    }
}
