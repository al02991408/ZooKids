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
            
            // Sección 2: Opciones de la Aplicación
            Section(header: Text("Preferencias de la App").font(.headline)) {
                
                // Opción para controlar sonidos (usando un @State simple por ahora)
                Toggle(isOn: .constant(true)) {
                    Label("Efectos de Sonido", systemImage: "speaker.wave.3.fill")
                }
                .tint(.green)
                
                // Opción para controlar música
                Toggle(isOn: .constant(false)) {
                    Label("Música de Fondo", systemImage: "music.note")
                }
                .tint(.green)
            }
            
            // Sección 3: Acciones (Cerrar Sesión / Cambiar Mascota)
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

// Previsualización
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let testGameData = GameData()
        
        NavigationStack {
            SettingsView()
                .environmentObject(testGameData)
        }
    }
}
