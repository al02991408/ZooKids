//
//  ShopView.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var gameData: GameData // Para acceder a las monedas
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. Saldo de Monedas (Superior)
            HStack {
                Text("Mis Monedas:")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "yensign.circle.fill")
                        .foregroundColor(.yellow)
                    // Mostrar el saldo actual del usuario
                    Text("\(gameData.coins)")
                        .font(.title)
                        .fontWeight(.heavy)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(red: 0.95, green: 0.95, blue: 0.95)) // Fondo para el saldo
            
            // 2. Lista de Artículos de la Tienda
            List {
                // Agrupar por categorías (opcional, pero mejora la UI)
                ForEach(ShopItem.items, id: \.category) { item in
                    ShopItemRow(item: item)
                        .environmentObject(gameData) // Asegura que se pasa el EnvironmentObject
                }
                // Si quieres secciones por categoría:
                // ForEach(Array(Set(ShopItem.items.map { $0.category })), id: \.self) { category in
                //     Section(header: Text(category)) {
                //         ForEach(ShopItem.items.filter { $0.category == category }) { item in
                //             ShopItemRow(item: item)
                //         }
                //     }
                // }
            }
            .listStyle(.plain) // Estilo de lista moderna (sin bordes)
        }
        .navigationTitle("Tienda")
    }
}

// Preview con datos de ejemplo
struct ShopView_Previews: PreviewProvider {
    // Mock GameData con monedas de prueba
    static let mockGameData: GameData = {
        let data = GameData()
        data.coins = 200 // Saldo de prueba
        return data
    }()
    
    static var previews: some View {
        NavigationStack {
            ShopView()
        }
        .environmentObject(mockGameData)
    }
}
