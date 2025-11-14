//
//  AppFlowCoordinator.swift
//  ZooKids
//
//  Created by Alumno on 28/10/25.
//

import SwiftUI

struct AppFlowCoordinator: View {
    @EnvironmentObject var gameData: GameData
    @State private var appScreen: AppScreen = .welcome
    
    enum AppScreen {
        case welcome, petSelection
    }
    
    var body: some View {
        Group {
            if gameData.hasSelectedPet {
                // SIN NavigationStack adicional aquí
                MainTabView()
            } else {
                NavigationStack {
                    switch appScreen {
                    case .welcome:
                        WelcomeView(nextAction: {
                            appScreen = .petSelection
                        })
                    case .petSelection:
                        PetSelectionView(onPetSelected: {
                            // Selección completada
                        })
                    }
                }
            }
        }
    }
}
