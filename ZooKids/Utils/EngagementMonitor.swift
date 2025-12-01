//
//  EngagementMonitor.swift
//  ZooKids
//
//  Created by ZooKids Team on 27/11/25.
//

import AVFoundation
import Vision
import Combine
import UIKit

class EngagementMonitor: NSObject, ObservableObject {
    @Published var isEngaged: Bool = true
    
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private var lastFaceDetectionDate = Date()
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        // Request permission
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                self?.configureSession()
            }
        }
    }
    
    private func configureSession() {
        captureSession.beginConfiguration()
        
        // Use front camera
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        }
        
        captureSession.commitConfiguration()
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        
        // Start monitoring timer
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkEngagement()
        }
    }
    
    private func checkEngagement() {
        let timeSinceLastFace = Date().timeIntervalSince(lastFaceDetectionDate)
        DispatchQueue.main.async {
            // If no face for 5 seconds, mark as not engaged
            self.isEngaged = timeSinceLastFace < 5.0
        }
    }
}

extension EngagementMonitor: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            if let results = request.results as? [VNFaceObservation], !results.isEmpty {
                self?.lastFaceDetectionDate = Date()
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored, options: [:]).perform([request])
    }
}
