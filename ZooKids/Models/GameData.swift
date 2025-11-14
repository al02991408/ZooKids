//
//  GameData.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI
import Combine

// ObservableObject es el "ViewModel" que notifica a las vistas
final class GameData: ObservableObject {
    @Published var currentPet: Pet
    
    // Este estado global controlará la navegación principal
    @Published var hasSelectedPet = false
    
    // Para Shop
    @Published var coins: Int = 100
    
    func selectPet(_ pet: Pet) {
        self.currentPet = pet
        self.hasSelectedPet = true // Desbloquea la MainTabView
    }
    
    // Método para comprar
    func buyItem(_ item: ShopItem) {
        if coins >= item.price {
            coins -= item.price
            // Añadir item al inventario (Lógica futura)
            print("Comprado: \(item.name) por \(item.price) monedas. Monedas restantes: \(coins)")
        } else {
            print("Fondos insuficientes.")
        }
    }
    
    // Método para cambiar la bandera y forzar el regreso a WelcomeView/PetSelectionView
    func resetSelection() {
        // Al poner la bandera en false, AppFlowCoordinator volverá a la primera vista
        self.hasSelectedPet = false
        // Nota: Aquí también podrías resetear currentPet a un valor nulo.
    }
    
    init() {
        // Mock data initialization for the preview
        self.currentPet = Pet(
            name: "Panda",
            animalType: .panda, // Debe usar el enum AnimalType
            happiness: 90,
            energy: 70,
            learningScore: 80,
            imageName: "panda" // Placeholder name for an asset image
        )
    }
}
