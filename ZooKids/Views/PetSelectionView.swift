//
//  PetSelectionView.swift
//  ZooKids
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI

struct PetSelectionView: View {
    @EnvironmentObject var gameData: GameData
    var onPetSelected: () -> Void
    
    struct PetOption: Identifiable {
        let id = UUID()
        let name: String
        let animalType: String // Este es un String
        let imageName: String
    }
    
    private let petOptions: [PetOption] = [
        .init(name: "Panda", animalType: "Panda", imageName: "panda"),
        .init(name: "León", animalType: "León", imageName: "leon"),
        .init(name: "Loro", animalType: "Loro", imageName: "loro")
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Elige tu Mascota")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 50)
            
            Text("¡Selecciona quién será tu compañero de aventuras!")
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(spacing: 15) {
                ForEach(petOptions) { option in
                    PetCardView(option: option, action: {

                        let petType = AnimalType(rawValue: option.animalType) ?? .panda // Usa .panda como fallback seguro
                        
                        let newPet = Pet(
                            name: option.name,
                            animalType: petType,
                            happiness: 80,
                            energy: 80,
                            learningScore: 0,
                            imageName: option.imageName
                        )
                        gameData.selectPet(newPet)
                        onPetSelected()
                    })
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

// Previsualización
struct PetSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PetSelectionView(onPetSelected: {})
    }
}
