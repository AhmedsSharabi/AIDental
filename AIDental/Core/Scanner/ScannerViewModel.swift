//
//  ScannerViewModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 15/10/2024.
//

import Foundation
import AVKit
import SwiftUI


@MainActor final class ScannerViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var scannerState: CaseState = .idle
    @Published var result: Prediction? = nil
    @Published var isScanning: Bool = false
    @Published var cameraPermission: Permission = .idle
    @Published var showResult: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    private let videoOutputDelegate: VideoOutputDelegate
    
    init(videoOutputDelegate: VideoOutputDelegate = .shared) {
        self.videoOutputDelegate = videoOutputDelegate
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }

    func addPrediction(prediction: Prediction) {
        guard let user else { return }
        let prediction = prediction
        Task {
            try await UserManager.shared.addPrediction(userId: user.userId, prediction: prediction)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }

    func reactivateCamera(session: AVCaptureSession) {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }

    func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }

    func deActivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }

    func checkCameraPermission(session: AVCaptureSession) {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera(session: session)
                } else {
                    reactivateCamera(session: session)
                }
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera(session: session)
                } else {
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera for scanning codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to Camera for scanning codes")
            default: break
            }
        }
    }

    func setupCamera(session: AVCaptureSession) {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN DEVICE ERROR")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(videoOutputDelegate.output) else {
                presentError("UNKNOWN INPUT/OUTPUT ERROR")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(videoOutputDelegate.output)
            
            let videoOutput = AVCaptureVideoDataOutput()
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
                videoOutput.setSampleBufferDelegate((videoOutputDelegate), queue: DispatchQueue(label: "imageCaptureQueue"))
            }
            
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }

    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }

    func captureImage(session: AVCaptureSession) {
        if session.isRunning && cameraPermission == .approved {
            scannerState = .loading
            showResult.toggle()
            session.stopRunning()
            if let capturedImage = videoOutputDelegate.capturedImage {
                sendImageForProcessing(image: capturedImage)
            }
        }
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }

    // Resize image before converting to base64
    func sendImageForProcessing(image: UIImage) {
        // Compress image to reduce its size
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Error: Could not convert image to data")
            return
        }
        
        // Base64 encode the compressed image data
        let fileContent = imageData.base64EncodedString()
        guard let postData = fileContent.data(using: .utf8) else {
            print("Error: Could not convert base64 string to Data")
            return
        }
        
        // Ensure the URL is valid
        guard let url = URL(string: "https://classify.roboflow.com/dai-4bmc3/1?api_key=BdwFsgGy46JSLH7hv0e6&name=YOUR_IMAGE.jpg") else {
            print("Error: Invalid URL")
            return
        }
        
        // Set up the request
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        // Perform the network request
        // Perform the network request
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // Check for network error
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Ensure data was received
            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            // Debug: Print raw response
            print("Raw Response: \(String(data: data, encoding: .utf8) ?? "No Data")")
            
            // Try parsing the response as JSON
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let predictions = json["predictions"] as? [String: [String: Any]] {
                    
                    // Process predictions
                    var predictionResults: [Prediction] = []
                    
                    for (condition, details) in predictions {
                        if let confidenceValue = details["confidence"] as? Double {
                            let newPrediction = Prediction(id: UUID(), prediction: condition, confidence: confidenceValue)
                            predictionResults.append(newPrediction)
                        }
                    }
                    
                    // Sort predictions by confidence descending
                    predictionResults.sort { $0.confidence > $1.confidence }
                    
                    if predictionResults.isEmpty {
                        DispatchQueue.main.async {
                            self?.scannerState = .idle
                            self?.presentError("No Condition Found")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.scannerState = .loaded
                            self?.result = predictionResults.first
                            predictionResults.forEach { self?.addPrediction(prediction: $0) }
                        }
                    }
                } else {
                    print("Error: Could not parse JSON or predictions not found")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}


enum CaseState {
    case idle
    case loading
    case loaded
    case error
}


import SwiftUI

/// Camera Permission Enum
enum Permission: String {
    case idle = "Not Determined"
    case approved = "Access Granted"
    case denied = "Access Denied"
}
