//
//  ZooKidsApp.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//
//  ZooKidsApp.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI

@main
struct ZooKidsApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var gameData = GameData()
    @StateObject var engagementMonitor = EngagementMonitor()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppFlowCoordinator()
                    .environmentObject(gameData)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                if !engagementMonitor.isEngaged {
                    ZStack {
                        Color.black.opacity(0.8).ignoresSafeArea()
                        VStack {
                            Image(systemName: "eye.slash.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                            Text("¿Sigues ahí?")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                            Text("¡Te estamos esperando!")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: engagementMonitor.isEngaged)
                }
            }
        }
    }
}
