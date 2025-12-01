//
//  SettingsView.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI

struct SettingsView: View {
    // Necesario para acceder a la mascota actual y a la lógica de cerrar sesión
    @EnvironmentObject var gameData: GameData
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        List {
            // Sección 1: Perfil de Mascota
            Section(header: Text("Mi Compañero de Aventuras").font(.headline)) {
                
                HStack {
                    // Muestra el ícono de la mascota
                    Image(systemName: "pawprint.circle.fill")
                        .foregroundColor(.green)
                    Text("Nombre")
                    Spacer()
                    Text(gameData.currentPet.name)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.blue)
                    Text("Especie")
                    Spacer()
                    // Asumiendo que animalType tiene un valor RawValue string
                    Text(gameData.currentPet.animalType.rawValue)
                        .foregroundColor(.secondary)
                }
            }
            
            // Sección 2: Accesibilidad
            Section(header: Text("Accesibilidad").font(.headline)) {
                Toggle(isOn: $viewModel.isVoiceOverEnabled) {
                    Label("VoiceOver", systemImage: "accessibility")
                }
                
                Toggle(isOn: $viewModel.isHighContrastEnabled) {
                    Label("Alto Contraste", systemImage: "circle.lefthalf.filled")
                }
                
                VStack(alignment: .leading) {
                    Text("Tamaño de Texto: \(String(format: "%.1f", viewModel.textSize))x")
                    Slider(value: $viewModel.textSize, in: 0.8...1.5, step: 0.1)
                }
            }
            
            // Sección 3: Sensorial
            Section(header: Text("Sensorial").font(.headline)) {
                Toggle(isOn: $viewModel.isHapticsEnabled) {
                    Label("Vibración (Haptics)", systemImage: "iphone.radiowaves.left.and.right")
                }
                
                VStack(alignment: .leading) {
                    Text("Volumen de Sonido")
                    Slider(value: $viewModel.soundVolume, in: 0...1)
                }
                
                VStack(alignment: .leading) {
                    Text("Volumen de Música")
                    Slider(value: $viewModel.musicVolume, in: 0...1)
                }
            }
            
            // Sección 4: Portal de Padres
            Section {
                NavigationLink(destination: ParentPortalView(viewModel: viewModel)) {
                    Label("Portal de Padres / Tutor", systemImage: "person.2.fill")
                }
            }
            
            // Sección 5: Acerca de
            Section(header: Text("Acerca de").font(.headline)) {
                NavigationLink(destination: AboutView()) {
                    Label("Información de la App", systemImage: "info.circle")
                }
            }
            
            // Sección 6: Acciones (Cerrar Sesión / Cambiar Mascota)
            Section {
                // El botón que ejecuta la acción para volver a la pantalla inicial
                Button {
                    // Lógica para resetear el estado y volver a WelcomeView
                    gameData.resetSelection()
                } label: {
                    Label("Cambiar Mascota / Cerrar Sesión", systemImage: "person.crop.circle.badge.xmark")
                }
                .foregroundColor(.red) // Botón de acción destacada en rojo
            }
        }
        .listStyle(.insetGrouped) // Estilo de lista agrupada para mejor jerarquía visual
        .navigationTitle("Ajustes")
    }
}

// Vista simple para "Acerca de"
struct AboutView: View {
    var body: some View {
        List {
            Section(header: Text("Versión")) {
                Text("ZooKids v1.0.0")
            }
            Section(header: Text("Equipo")) {
                Text("Desarrollado por el equipo de ZooKids")
            }
            Section(header: Text("Legal")) {
                Link("Política de Privacidad", destination: URL(string: "https://example.com/privacy")!)
            }
        }
        .navigationTitle("Acerca de")
    }

    }
}

// Previsualización
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let testGameData = GameData()
        
        NavigationStack {
            SettingsView()
                .environmentObject(testGameData)
        }
}
