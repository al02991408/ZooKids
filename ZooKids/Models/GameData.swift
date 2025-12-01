//
//  GameData.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving progress: \(error)")
        }
    }
    
    func selectPet(_ pet: Pet) {
        self.currentPet = pet
        self.hasSelectedPet = true // Desbloquea la MainTabView
        saveProgress()
    }
    
    // MARK: - Game Mechanics
    
    func addXP(_ amount: Int) {
        xp += amount
        xpProgress += Double(amount)
        
        // Verificar si sube de nivel
        if xpProgress >= 100 {
            level += 1
            xpProgress -= 100
            // Bonus de monedas al subir de nivel
            coins += 20
            HapticManager.shared.playSuccess() // Haptic Feedback
        }
        
        // Guardar progreso
        saveProgress()
    }
    
    func feedMascot() {
        if coins >= 10 {
            coins -= 10
            currentPet.happiness = min(100, currentPet.happiness + 10)
            currentPet.energy = min(100, currentPet.energy + 5)
            addXP(5)
            HapticManager.shared.playTick() // Haptic Feedback
            saveProgress()
        }
    }
    
    func playWithMascot() {
        currentPet.happiness = min(100, currentPet.happiness + 15)
        currentPet.energy = max(0, currentPet.energy - 10)
        addXP(15)
        HapticManager.shared.playSuccess() // Haptic Feedback
        saveProgress()
    }
    
    // Método para comprar
    func buyItem(_ item: ShopItem) {
        if unlockedItemIds.contains(item.id) && item.category != "Consumibles" {
            print("Ya tienes este artículo.")
            return
        }
        
        if coins >= item.price {
            coins -= item.price
            
            if item.category == "Consumibles" {
                // Aplicar efecto inmediato
                if item.id == "potion_energy" {
                    currentPet.energy = 100
                } else if item.id == "food_carrot" {
                    feedMascot()
                }
            } else {
                unlockedItemIds.insert(item.id)
            }
            
            HapticManager.shared.playSuccess() // Haptic Feedback
            print("Comprado: \(item.name) por \(item.price) monedas. Monedas restantes: \(coins)")
            saveProgress()
        } else {
            HapticManager.shared.playError() // Haptic Feedback
            print("Fondos insuficientes.")
        }
    }
    
    // Método para cambiar la bandera y forzar el regreso a WelcomeView/PetSelectionView
    func resetSelection() {
        // Al poner la bandera en false, AppFlowCoordinator volverá a la primera vista
        self.hasSelectedPet = false
        // Nota: Aquí también podrías resetear currentPet a un valor nulo.
    }
}
