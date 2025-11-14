//
//  LetterTracePath.swift
//  ZooKids
//
//  Created by Alumno on 23/10/25.
//


// LetterTracePath.swift

import SwiftUI

struct LetterTracePath {
    // Función que devuelve una Path de SwiftUI para la letra A
    static func path(for letter: String, in rect: CGRect) -> Path {
        switch letter.uppercased() {
        case "A":
            return pathForA(in: rect)
        // Puedes añadir más letras aquí
        default:
            return Path()
        }
    }
    
    // Función que devuelve los puntos clave para la guía visual (líneas discontinuas)
    static func tracePoints(for letter: String, in rect: CGRect) -> [CGPoint] {
        switch letter.uppercased() {
        case "A":
            return tracePointsForA(in: rect)
        // Añade puntos para más letras
        default:
            return []
        }
    }
    
    // Función que devuelve los puntos del trazo "ideal" para la evaluación
    static func evaluationPoints(for letter: String, in rect: CGRect) -> [CGPoint] {
        switch letter.uppercased() {
        case "A":
            return evaluationPointsForA(in: rect)
        default:
            return []
        }
    }

    // Rutas detalladas para la letra A
    private static func pathForA(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        
        return Path { p in
            // Lado izquierdo
            p.move(to: CGPoint(x: width * 0.2, y: height * 0.9))
            p.addLine(to: CGPoint(x: width * 0.5, y: height * 0.1))
            // Lado derecho
            p.addLine(to: CGPoint(x: width * 0.8, y: height * 0.9))
            // Travesaño
            p.move(to: CGPoint(x: width * 0.35, y: height * 0.6))
            p.addLine(to: CGPoint(x: width * 0.65, y: height * 0.6))
        }
    }
    
    // Puntos para las líneas discontinuas y la flecha guía de la A
    private static func tracePointsForA(in rect: CGRect) -> [CGPoint] {
        let width = rect.size.width
        let height = rect.size.height
        
        var points: [CGPoint] = []
        
        // 1. Segmento Izquierdo: Abajo a Arriba
        let startY1 = height * 0.9
        let endY1 = height * 0.1
        let deltaY1 = startY1 - endY1
        
        for y in stride(from: startY1, to: endY1 - 0.01, by: -height * 0.1) {
            let fraction = (startY1 - y) / deltaY1
            let x = width * 0.2 + (width * 0.3 * fraction)
            points.append(CGPoint(x: x, y: y))
        }
        points.append(CGPoint(x: width * 0.5, y: height * 0.1)) // Vértice superior
        
        // 2. Segmento Derecho: Arriba a Abajo
        let startY2 = height * 0.1
        let endY2 = height * 0.9
        let deltaY2 = endY2 - startY2
        
        for y in stride(from: startY2, to: endY2 + 0.01, by: height * 0.1) {
            let fraction = (y - startY2) / deltaY2
            let x = width * 0.5 + (width * 0.3 * fraction)
            points.append(CGPoint(x: x, y: y))
        }
        points.append(CGPoint(x: width * 0.8, y: height * 0.9)) // Vértice inferior derecho

        // 3. Segmento Travesaño: Izquierda a Derecha
        let startX3 = width * 0.35
        let endX3 = width * 0.65
        
        for x in stride(from: startX3, to: endX3 + 0.01, by: width * 0.05) {
            points.append(CGPoint(x: x, y: height * 0.6))
        }
        
        return points
    }
    // Puntos de evaluación para la letra A (una versión simplificada para comparar el trazo del usuario)
    private static func evaluationPointsForA(in rect: CGRect) -> [CGPoint] {
        let width = rect.size.width
        let height = rect.size.height
        
        // Segmento 1
        let p1_start = CGPoint(x: width * 0.2, y: height * 0.9)
        let p1_end = CGPoint(x: width * 0.5, y: height * 0.1)
        
        // Segmento 2
        let p2_start = CGPoint(x: width * 0.5, y: height * 0.1)
        let p2_end = CGPoint(x: width * 0.8, y: height * 0.9)
        
        // Segmento 3
        let p3_start = CGPoint(x: width * 0.35, y: height * 0.6)
        let p3_end = CGPoint(x: width * 0.65, y: height * 0.6)
        
        // Generar puntos a lo largo de cada segmento para una buena cobertura
        var evalPoints: [CGPoint] = []
        
        // Generar puntos a lo largo del segmento 1 (lado izquierdo)
        for i in 0...10 {
            let t = CGFloat(i) / 10.0
            let x = p1_start.x + (p1_end.x - p1_start.x) * t
            let y = p1_start.y + (p1_end.y - p1_start.y) * t
            evalPoints.append(CGPoint(x: x, y: y))
        }
        
        // Generar puntos a lo largo del segmento 2 (lado derecho)
        for i in 0...10 {
            let t = CGFloat(i) / 10.0
            let x = p2_start.x + (p2_end.x - p2_start.x) * t
            let y = p2_start.y + (p2_end.y - p2_start.y) * t
            evalPoints.append(CGPoint(x: x, y: y))
        }
        
        // Generar puntos a lo largo del segmento 3 (travesaño)
        for i in 0...10 {
            let t = CGFloat(i) / 10.0
            let x = p3_start.x + (p3_end.x - p3_start.x) * t
            let y = p3_start.y + (p3_end.y - p3_start.y) * t
            evalPoints.append(CGPoint(x: x, y: y))
        }
        
        return evalPoints
    }
}

// Extensión para calcular la distancia entre dos puntos
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
