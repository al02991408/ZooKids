//
//  Pet.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI
import Foundation

// Pet Model
struct Pet: Identifiable {
    let id = UUID()
    var name: String
    var animalType: AnimalType
    var happiness: Int // 0-100
    var energy: Int    // 0-100
    var learningScore: Int // 0-100
    var imageName: String
}

enum AnimalType: String, CaseIterable {
    case panda = "Panda"
    case lion = "León"
    case parrot = "Loro"
}
