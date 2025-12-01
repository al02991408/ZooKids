//
//  ParentPortalView.swift
//  ZooKids
//
//  Created by ZooKids Team on 27/11/25.
//

import SwiftUI

struct ParentPortalView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var answer: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.isParentPortalUnlocked {
                authenticatedContent
            } else {
                authView
            }
        }
        .navigationTitle("Portal de Padres")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var authView: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            Text("Acceso Protegido")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Resuelve la operación para entrar:")
                .font(.body)
            
            Text("5 + 3 = ?")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Respuesta", text: $answer)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150)
                .padding()
            
            if showError {
                Text("Respuesta incorrecta. Intenta de nuevo.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                if viewModel.unlockParentPortal(answer: answer) {
                    showError = false
                } else {
                    showError = true
                    answer = ""
                }
            }) {
                Text("Entrar")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    var authenticatedContent: some View {
        List {
            Section(header: Text("Reportes de Progreso")) {
                NavigationLink(destination: Text("Gráficas de Progreso (Próximamente)")) {
                    Label("Ver Reportes", systemImage: "chart.bar.fill")
                }
            }
            
            Section(header: Text("Configuración de Sesión")) {
                VStack(alignment: .leading) {
                    Text("Límite de Sesión: \(Int(viewModel.sessionTimeLimit)) min")
                    Slider(value: $viewModel.sessionTimeLimit, in: 10...60, step: 5)
                }
            }
            
            Section(header: Text("Dificultad")) {
                Picker("Nivel de Dificultad", selection: $viewModel.difficultyLevel) {
                    ForEach(SettingsViewModel.DifficultyLevel.allCases) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                
                Button("Restablecer Dificultad") {
                    viewModel.resetDifficulty()
                }
                .foregroundColor(.red)
            }
            
            Section {
                Button("Cerrar Portal") {
                    viewModel.lockParentPortal()
                    answer = ""
                }
                .foregroundColor(.red)
            }
        }
    }
}

struct ParentPortalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ParentPortalView(viewModel: SettingsViewModel())
        }
    }
}
