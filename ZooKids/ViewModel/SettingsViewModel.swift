//
//  SettingsViewModel.swift
//  ZooKids
//
//  Created by ZooKids Team on 27/11/25.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    // MARK: - Accessibility Settings
    @Published var isVoiceOverEnabled: Bool = false
    @Published var textSize: Double = 1.0 // Scale factor
    @Published var isHighContrastEnabled: Bool = false
    
    // MARK: - Sensory Settings
    @Published var isHapticsEnabled: Bool = true
    @Published var soundVolume: Double = 0.8
    @Published var musicVolume: Double = 0.5
    
    // MARK: - Parent Portal
    @Published var isParentPortalUnlocked: Bool = false
    @Published var sessionTimeLimit: Double = 30.0 // Minutes
    @Published var difficultyLevel: DifficultyLevel = .normal
    
    enum DifficultyLevel: String, CaseIterable, Identifiable {
        case easy = "Fácil"
        case normal = "Normal"
        case hard = "Difícil"
        
        var id: String { self.rawValue }
    }
    
    // MARK: - Logic
    
    func unlockParentPortal(answer: String) -> Bool {
        // Simple math question: 5 + 3 = 8
        if answer.trimmingCharacters(in: .whitespacesAndNewlines) == "8" {
            isParentPortalUnlocked = true
            return true
        }
        return false
    }
    
    func lockParentPortal() {
        isParentPortalUnlocked = false
    }
    
    func resetDifficulty() {
        difficultyLevel = .normal
    }
}
