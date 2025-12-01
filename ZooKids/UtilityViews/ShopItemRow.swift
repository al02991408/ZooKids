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
    
    var isOwned: Bool {
        return gameData.unlockedItemIds.contains(item.id) && item.category != "Consumibles"
    }
    
    var canAfford: Bool {
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
                if !isOwned && canAfford {
                    gameData.buyItem(item)
                } else if item.category == "Consumibles" && canAfford {
                    gameData.buyItem(item)
                }
            }) {
                HStack {
                    if isOwned {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Comprado")
                    } else {
                        Image(systemName: "yensign.circle.fill")
                        Text("\(item.price)")
                    }
                }
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isOwned ? Color.gray : (canAfford ? Color.green : Color.gray))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isOwned || (!canAfford && !isOwned))
            .accessibilityLabel(isOwned ? "Comprado" : "Comprar por \(item.price) monedas")
            .accessibilityHint(isOwned ? "Ya tienes este artículo" : (canAfford ? "Toca para comprar" : "No tienes suficientes monedas"))
        }
        .padding(.vertical, 8)
    }
}
