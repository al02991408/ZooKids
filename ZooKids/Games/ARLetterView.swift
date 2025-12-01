//
//  ARLetterView.swift
//  ZooKids
//
//  Created by ZooKids Team on 27/11/25.
//

import SwiftUI
import ARKit
import SceneKit

struct ARLetterView: UIViewRepresentable {
    let letter: String
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.autoenablesDefaultLighting = true
        
        let scene = SCNScene()
        arView.scene = scene
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config)
        
        addLetterToScene(arView: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Update logic if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func addLetterToScene(arView: ARSCNView) {
        let textGeometry = SCNText(string: letter, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.orange
        
        let textNode = SCNNode(geometry: textGeometry)
        // Center the text
        let (min, max) = textNode.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        // Scale down
        textNode.scale = SCNVector3(0.02, 0.02, 0.02)
        
        // Position 50cm in front of camera
        textNode.position = SCNVector3(0, 0, -0.5)
        
        arView.scene.rootNode.addChildNode(textNode)
        
        // Add a spinning animation
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(scnVector4: SCNVector4(0, 1, 0, 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Float.pi * 2))
        spin.duration = 10
        spin.repeatCount = .infinity
        textNode.addAnimation(spin, forKey: "spin around")
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARLetterView
        
        init(_ parent: ARLetterView) {
            self.parent = parent
        }
    }
}
