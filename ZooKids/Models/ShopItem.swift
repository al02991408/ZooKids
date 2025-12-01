//
//  ShopItem.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

// Estructura para definir un artículo de la tienda
struct ShopItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let iconName: String // Nombre de SFSymbol
    let price: Int // Costo en monedas
    let category: String
    
    static let items: [ShopItem] = [
        ShopItem(id: "toy_ball", name: "Pelota Gigante", description: "Aumenta la diversión.", iconName: "basketball.fill", price: 100, category: "Juguetes"),
        ShopItem(id: "acc_hat", name: "Gorro de Sol", description: "Estilo playero.", iconName: "hat.widebrim.fill", price: 250, category: "Accesorios"),
        ShopItem(id: "potion_energy", name: "Poción de Energía", description: "Recarga tu energía al 100%.", iconName: "bolt.fill", price: 50, category: "Consumibles"),
        ShopItem(id: "book_stories", name: "Libro de Cuentos", description: "Mejora el aprendizaje.", iconName: "book.fill", price: 150, category: "Aprendizaje"),
        ShopItem(id: "food_carrot", name: "Zanahoria", description: "Un snack para tu mascota.", iconName: "carrot.fill", price: 50, category: "Comida")
    ]
}
