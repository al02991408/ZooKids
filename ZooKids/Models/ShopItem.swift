//
//  ShopItem.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Estructura para definir un artículo de la tienda
struct ShopItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String // Nombre de SFSymbol
    let price: Int // Costo en monedas
    let category: String
    
    static let items: [ShopItem] = [
        ShopItem(name: "Pelota Gigante", description: "Aumenta la diversión.", iconName: "basketball.fill", price: 100, category: "Juguetes"),
        ShopItem(name: "Gorro de Sol", description: "Estilo playero.", iconName: "hat.widebrim.fill", price: 250, category: "Accesorios"),
        ShopItem(name: "Poción de Energía", description: "Recarga tu energía al 100%.", iconName: "bolt.fill", price: 50, category: "Consumibles"),
        ShopItem(name: "Libro de Cuentos", description: "Mejora el aprendizaje.", iconName: "book.fill", price: 150, category: "Aprendizaje"),
        ShopItem(name: "Zanahoria", description: "Un snack para tu mascota.", iconName: "carrot.fill", price: 50, category: "Comida")
    ]
}
