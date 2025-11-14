//
//  LetterRaceView.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//

// LetterRaceView.swift

import SwiftUI

struct LetterRaceView: View {
    let game: Game // Para el título del juego
    
    @StateObject private var viewModel = LetterRaceViewModel()
    
    // Estado para la posición de la flecha guía
    @State private var arrowPosition: CGPoint = .zero
    @State private var arrowRotation: Angle = .zero
    
    var body: some View {
        ZStack {
            // Fondo similar al de la imagen
            Color.teal.opacity(0.1).ignoresSafeArea()
            
            VStack {
                // 1. Cabecera (Bandera de carreras y título)
                HStack {
                    Image(systemName: "flag.checkered")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    Text(game.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 20)
                
                // 2. Instrucción
                Text("Traza la letra")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.top, 20)
                
                // 3. Área de Trazado de la Letra
                GeometryReader { geometry in
                    let rect = geometry.size.width > geometry.size.height ?
                                CGRect(x: 0, y: 0, width: geometry.size.height * 0.8, height: geometry.size.height * 0.8) :
                                CGRect(x: 0, y: 0, width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                    
                    // Centrar el área de trazado
                    let offsetX = (geometry.size.width - rect.width) / 2
                    let offsetY = (geometry.size.height - rect.height) / 2
                    
                    ZStack {
                        // 3a. La Letra Guiada (Puntos discontinuos o líneas)
                        Path { path in
                            let tracePoints = LetterTracePath.tracePoints(for: viewModel.currentLetter, in: rect)
                            if !tracePoints.isEmpty {
                                path.move(to: tracePoints[0])
                                for i in 1..<tracePoints.count {
                                    path.addLine(to: tracePoints[i])
                                }
                            }
                        }
                        .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 5, dash: [10, 10]))
                        
                        // 3b. La Flecha Guía
                        if viewModel.showGuidanceArrow {
                            // Calcula la posición y rotación de la flecha
                            // Para la 'A', la primera línea va de abajo izquierda a arriba centro
                            let startPoint = LetterTracePath.evaluationPoints(for: viewModel.currentLetter, in: rect).first ?? .zero
                            let nextPoint = LetterTracePath.evaluationPoints(for: viewModel.currentLetter, in: rect).dropFirst().first ?? .zero
                            
                            // Calcula el ángulo de la flecha
                            let deltaX = nextPoint.x - startPoint.x
                            let deltaY = nextPoint.y - startPoint.y
                            let angle = atan2(deltaY, deltaX) * (180 / .pi)
                            
                            Image(systemName: "arrow.up.left") // O una flecha más general
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                                .offset(x: startPoint.x + 20 - offsetX, y: startPoint.y + 20 - offsetY) // Ajustar para mostrar bien la flecha
                                .rotationEffect(Angle(degrees: angle - 90)) // Ajustar la rotación base de la flecha SFSymbol
                                .animation(.easeOut, value: viewModel.showGuidanceArrow) // Animación al aparecer/desaparecer
                        }
                        
                        // 3c. El Trazado del Usuario
                        Path { path in
                            if let firstPoint = viewModel.userPathPoints.first {
                                path.move(to: firstPoint)
                                for point in viewModel.userPathPoints.dropFirst() {
                                    path.addLine(to: point)
                                }
                            }
                        }
                        // CORRECCIÓN: Usar StrokeStyle para lineCap y lineJoin
                        .stroke(
                            viewModel.isTracingCorrect ? Color.blue : Color.red,
                            style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
                        )
                        .animation(.easeIn, value: viewModel.isTracingCorrect)
                        
                    }
                    .frame(width: rect.width, height: rect.height)
                    .offset(x: offsetX, y: offsetY) // Centrar el ZStack
                    .background(Color.white.opacity(0.3)) // Fondo para el área de trazado
                    .cornerRadius(15)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Asegurarse de que los puntos de evaluación se carguen
                                viewModel.updateEvaluationPoints(with: rect)
                                if viewModel.userPathPoints.isEmpty {
                                    viewModel.startTracing(at: value.location)
                                } else {
                                    viewModel.updateTracing(with: value.location)
                                }
                            }
                            .onEnded { value in
                                viewModel.endTracing()
                            }
                    )
                }
                .aspectRatio(1, contentMode: .fit) // Mantener aspecto cuadrado
                .padding(.horizontal)
                
                // 4. Mensaje de Feedback
                Text(viewModel.feedbackMessage)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.isTracingCorrect || viewModel.isLetterCompleted ? .green : .red)
                    .padding(.top, 20)
                
                // Fragmento de LetterRaceView.swift (Líneas 140-165)

                // 5. Botón para siguiente letra (si completó) o Reintentar
                if viewModel.isLetterCompleted && viewModel.isNotLastLetter {
                    Button("Siguiente Letra") {
                        viewModel.loadNewLetter()
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(12)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.top, 20)
                } else if viewModel.isLetterCompleted { // Si ya terminó todas las letras
                    Button("Volver a Empezar") {
                        // Llama a una nueva función que resetea la cuenta en el VM
                        viewModel.resetGame()
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(12)
                    .background(Color.yellow.opacity(0.8))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
        }
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Previsualización
struct LetterRaceView_Previews: PreviewProvider {
    static var previews: some View {
        let letterRaceGame = Game(title: "Carrera de Letras", subtitle: "Traza el alfabeto", imageName: "pencil.and.outline", level: 1, score: 125, color: Color.blue, type: .letterRace)
        NavigationStack {
            LetterRaceView(game: letterRaceGame)
        }
    }
}
