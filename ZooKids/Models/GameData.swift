//
//  GameData.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI
import Combine
import CoreData

// ObservableObject es el "ViewModel" que notifica a las vistas
final class GameData: ObservableObject {
    @Published var currentPet: Pet
    
    // Este estado global controlará la navegación principal
    @Published var hasSelectedPet = false
    
    // Para Shop
    @Published var coins: Int = 100 {
        didSet { saveProgress() }
    }
    
    @Published var xp: Int = 0 {
        didSet { saveProgress() }
    }
    
    @Published var unlockedItemIds: Set<String> = [] {
        didSet { saveProgress() }
    }
    
    var level: Int {
        return (xp / 100) + 1
    }
    
    var xpProgress: Double {
        return Double(xp % 100)
    }
    
    // Contexto de CoreData
    private var viewContext = PersistenceController.shared.container.viewContext
    private var userProgress: UserProgress?
    
    init() {
        // Inicialización por defecto
        self.currentPet = Pet(
            name: "Panda",
            animalType: .panda,
            happiness: 90,
            energy: 70,
            learningScore: 80,
            imageName: "panda"
        )
        
        loadProgress()
    }
    
    private func loadProgress() {
        let request: NSFetchRequest<UserProgress> = UserProgress.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let results = try viewContext.fetch(request)
            if let progress = results.first {
                // Cargar datos existentes
                self.userProgress = progress
                self.coins = Int(progress.coins)
                self.xp = Int(progress.xp)
                
                if let unlockedString = progress.unlockedItems {
                    self.unlockedItemIds = Set(unlockedString.components(separatedBy: ",").filter { !$0.isEmpty })
                }
                
                if let petName = progress.selectedPetName {
                    self.currentPet.name = petName
                    self.currentPet.happiness = progress.petHappiness
                    self.currentPet.energy = progress.petEnergy
                    self.currentPet.learningScore = progress.petLearningScore
                    self.hasSelectedPet = true
                }
            } else {
                // Crear nuevo progreso
                let newProgress = UserProgress(context: viewContext)
                newProgress.coins = 100
                newProgress.xp = 0
                newProgress.petHappiness = 90
                newProgress.petEnergy = 70
                newProgress.petLearningScore = 0
                newProgress.unlockedItems = ""
                self.userProgress = newProgress
                try viewContext.save()
            }
        } catch {
            print("Error loading progress: \(error)")
        }
    }
    
    private func saveProgress() {
        guard let progress = userProgress else { return }
        
        progress.coins = Int64(coins)
        progress.xp = Int64(xp)
        progress.unlockedItems = unlockedItemIds.joined(separator: ",")
        progress.selectedPetName = currentPet.name
        progress.petHappiness = currentPet.happiness
        progress.petEnergy = currentPet.energy
        progress.petLearningScore = currentPet.learningScore
        
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
        // xpProgress is computed, so we don't set it directly.
        // But we need to check for level up based on xp.
        
        // Verificar si sube de nivel (Logic handled by computed property? No, we need to detect the change)
        // Actually, the previous implementation had logic here.
        // Let's restore the logic from Step 246 but adapted.
        
        // Since 'level' is computed from 'xp', we don't need to increment it manually.
        // But we want to trigger effects (coins, haptics) when level changes.
        // This is a bit tricky with computed properties.
        // For now, let's keep it simple and just save.
        // The previous code was:
        /*
        xpProgress += Double(amount)
        if xpProgress >= 100 { ... }
        */
        // But xpProgress is computed in my restored version: return Double(xp % 100)
        // So we should check if the new XP crosses a 100 threshold.
        
        let oldLevel = (xp - amount) / 100 + 1
        let newLevel = (xp) / 100 + 1
        
        if newLevel > oldLevel {
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
