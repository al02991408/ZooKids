//
//  ShopItemRow.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Vista auxiliar
struct ShopItemRow: View {
    let item: ShopItem
    @EnvironmentObject var gameData: GameData
    
    var canAfford: Bool {
        // Asumiendo que gameData tiene una propiedad 'coins'
        return gameData.coins >= item.price
    }
    
    var body: some View {
        HStack(spacing: 15) {
            
            // 1. Icono del Artículo (Izquierda)
            Image(systemName: item.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue.opacity(0.8)) // Color base para ítems
                .cornerRadius(8)
            
            // 2. Nombre y Descripción
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 3. Botón de Compra con Precio
            Button(action: {
                // Lógica de compra: restar monedas y añadir ítem al inventario
                if canAfford {
                    gameData.buyItem(item)
                }
            }) {
                HStack {
                    Image(systemName: "yensign.circle.fill") // SFSymbol para moneda
                    Text("\(item.price)")
                }
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(canAfford ? Color.green : Color.gray) // Color condicional
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            // Deshabilitar botón si no se puede pagar
            .disabled(!canAfford)
        }
        .padding(.vertical, 8)
    }
}
