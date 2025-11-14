//
//  LetterRaceViewModel.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//


// LetterRaceViewModel.swift

import SwiftUI
import Combine

final class LetterRaceViewModel: ObservableObject {
    @Published var currentLetter: String = "A" // La letra actual a trazar
    @Published var userPathPoints: [CGPoint] = [] // Puntos que el usuario ha trazado
    @Published var feedbackMessage: String = "¡Traza la letra!"
    @Published var isTracingCorrect: Bool = false // Indica si el usuario está trazando correctamente
    @Published var isLetterCompleted: Bool = false // Indica si la letra ha sido trazada correctamente
    @Published var showGuidanceArrow: Bool = true // Para la flecha de la primera dirección
    
    
    // Lista de letras para el juego
    private let alphabet: [String] = ["A", "B", "C", "D", "E"] // Puedes expandir esto
    private var currentLetterIndex: Int = 0
    
    // Propiedades para la evaluación del trazo
    private var evaluationPoints: [CGPoint] = []
    private let maxAllowedDistance: CGFloat = 60 // Distancia máxima permitida del trazo ideal
    private var tracedPointsCount: Int = 0 // Cuántos puntos del trazo ideal se han cubierto
    private let completionThreshold: Int = 80 // % de puntos de evaluación que deben ser tocados
    
    // Hacemos públicos los datos necesarios para el control de flujo de la vista
    var isNotLastLetter: Bool {
        return currentLetterIndex < alphabet.count
    }
    // También puedes hacer esta
    var nextLetterAvailable: Bool {
        return currentLetterIndex < alphabet.count - 1
    }
    
    init() {
        loadNewLetter()
    }
    
    func loadNewLetter() {
        if currentLetterIndex < alphabet.count {
            currentLetter = alphabet[currentLetterIndex]
            userPathPoints = []
            feedbackMessage = "¡Traza la letra!"
            isTracingCorrect = false
            isLetterCompleted = false
            showGuidanceArrow = true
            tracedPointsCount = 0
            
            // Los puntos de evaluación dependen del tamaño del área de trazado,
            // así que los recalculamos en la vista (en GeometryReader)
            // o aquí si se puede pasar el tamaño. Por ahora, asumiremos que se ajusta.
            
            // Resetear para que la vista los recalcule al obtener el tamaño real
            evaluationPoints = []
            print("Nueva letra: \(currentLetter)")
        } else {
            feedbackMessage = "¡Juego Terminado!"
            isLetterCompleted = true
        }
    }
    
    // Función llamada por la vista para actualizar los puntos de evaluación
    func updateEvaluationPoints(with rect: CGRect) {
        if evaluationPoints.isEmpty || evaluationPoints.first?.x != rect.origin.x {
            evaluationPoints = LetterTracePath.evaluationPoints(for: currentLetter, in: rect)
            print("Puntos de evaluación actualizados para \(currentLetter). Total: \(evaluationPoints.count)")
        }
    }
    
    // Maneja el inicio de un nuevo trazo
    func startTracing(at point: CGPoint) {
        userPathPoints = [point]
        isTracingCorrect = true
        showGuidanceArrow = false // La flecha se esconde al empezar a trazar
        feedbackMessage = "¡Sigue el camino!"
    }
    
    // Maneja los puntos durante el trazo
    func updateTracing(with point: CGPoint) {
        userPathPoints.append(point)
        
        // Si la letra ya está completada, ignorar trazos adicionales
        if isLetterCompleted { return }
        
        // Evaluar el punto actual del trazo del usuario contra los puntos de evaluación
        // (Lógica para contar puntos cubiertos - se mantiene igual)
        var newTracedPointsCount = tracedPointsCount
        for i in 0..<evaluationPoints.count {
            if evaluationPoints[i].distance(to: point) < maxAllowedDistance {
                newTracedPointsCount += 1
            }
        }
        tracedPointsCount = min(newTracedPointsCount, evaluationPoints.count)
        
        // *** CAMBIO CLAVE PARA RELAJAR LA DIFICULTAD ***
        // Solo se verifica si el último punto está cerca de la ruta ideal.
        let isCloseToPath = evaluationPoints.contains { evalPoint in
            point.distance(to: evalPoint) < maxAllowedDistance
        }
        
        // NOTA: ELIMINAMOS la línea 'isTracingCorrect = false' aquí.
        // En su lugar, usamos el estado `isCloseToPath` para mostrar el color del trazo.
        if !isCloseToPath {
            // En lugar de fallar, solo mostramos un mensaje de advertencia.
            // El trazo seguirá siendo rojo, pero el juego no se reinicia hasta que suelten el dedo.
            feedbackMessage = "¡Cuidado! Vuelve al camino."
            // Marcamos temporalmente para que el trazo se ponga rojo, pero el juego continúa
            isTracingCorrect = false
        } else {
            // Si está en el camino, se muestra azul/correcto
            isTracingCorrect = true
            let progress = Double(tracedPointsCount) / Double(evaluationPoints.count) * 100
            if progress < 90 {
                 feedbackMessage = "¡Vas bien! (\(Int(progress))%)"
            }
        }
    }
    // Maneja el final de un trazo
    func endTracing() {
        if isTracingCorrect {
            // Evaluar si se ha cubierto suficiente de la letra
            let completionPercentage = Double(tracedPointsCount) / Double(evaluationPoints.count) * 100
            print("Porcentaje de completado: \(completionPercentage)%")
            
            if completionPercentage >= Double(completionThreshold) {
                isLetterCompleted = true
                feedbackMessage = "¡Letra \(currentLetter) completada!"
                currentLetterIndex += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.loadNewLetter()
                }
            } else {
                feedbackMessage = "Casi lo logras. Intenta de nuevo."
                isTracingCorrect = false // Para mostrar la retroalimentación
                // Reiniciar el trazo si no se completó
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.userPathPoints = []
                    self.feedbackMessage = "¡Traza la letra!"
                    self.isTracingCorrect = false // Para mostrar la retroalimentación
                    self.showGuidanceArrow = true
                    self.tracedPointsCount = 0
                }
            }
        } else {
            // Si el trazo fue incorrecto, limpiar y reiniciar
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.userPathPoints = []
                self.feedbackMessage = "¡Intenta de nuevo!"
                self.isTracingCorrect = false
                self.showGuidanceArrow = true
                self.tracedPointsCount = 0
            }
        }
    }
    
    // FUNCIÓN DE RESETEO
    func resetGame() {
        currentLetterIndex = 0
        loadNewLetter()
    }
}
