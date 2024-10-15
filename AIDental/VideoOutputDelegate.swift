//
//  VideoOutputDelegate.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 15/10/2024.
//

import Foundation
import SwiftUI
import AVKit

class VideoOutputDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    static let shared = VideoOutputDelegate()
    @Published var capturedImage: UIImage? = nil
    
    let output = AVCaptureMetadataOutput()
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Error: Could not get image buffer")
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            print("Error: Could not create CGImage")
            return
        }
        
        let image = UIImage(cgImage: cgImage)
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}

