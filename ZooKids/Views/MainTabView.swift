//
//  MainTabView.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var gameData: GameData
    
    var body: some View {
        TabView {
            // Pestaña 1: Home
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Inicio")
            }
            
            NavigationStack {
                GamesMenuView()
            }
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Juegos")
                }
            
            NavigationStack {
                ShopView()
            }
                .tabItem {
                    Image(systemName: "basket.fill")
                    Text("Tienda")
                }
            
            NavigationStack {
                SettingsView()
            }
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Ajustes")
                }
        }
        .accentColor(.zooPrimary) // Pestañas activas en azul cielo (#56BDFC)
        .environment(\.horizontalSizeClass, .compact)
        
    }
}

// Previsualización
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let testGameData = GameData()
        MainTabView()
            .environmentObject(testGameData)
    }
}
