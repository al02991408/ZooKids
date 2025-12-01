//
//  MotivationalFeedbackView.swift
//  ZooKids
//
//  Created by ZooKids Team on 27/11/25.
//

import SwiftUI

struct MotivationalFeedbackView: View {
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                VStack(spacing: 20) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.yellow)
                        .rotationEffect(.degrees(isPresented ? 360 : 0))
                        .animation(Animation.spring().repeatForever(autoreverses: false), value: isPresented)
                    
                    Text(message)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 5)
                    
                    Button(action: {
                        withAnimation {
                            isPresented = false
                        }
                    }) {
                        Text("¡Continuar!")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                .padding(40)
                .background(Color.orange)
                .cornerRadius(25)
                .shadow(radius: 10)
                .transition(.scale)
            }
        }
    }
}

struct MotivationalFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        MotivationalFeedbackView(message: "¡Excelente Trabajo!", isPresented: .constant(true))
    }
}
