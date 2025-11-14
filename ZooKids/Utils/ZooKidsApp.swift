//
//  ZooKidsApp.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI

@main
struct ZooKidsApp: App {
    @StateObject var gameData = GameData()
    
    var body: some Scene {
        WindowGroup {
            AppFlowCoordinator()
                .environmentObject(gameData)
        }
    }
}
