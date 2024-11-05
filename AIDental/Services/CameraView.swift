//
//  CameraView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 15/10/2024.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    var frameSize: CGSize
    @Binding var session: AVCaptureSession
    @Binding var orientation: UIDeviceOrientation
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first(where: { layer in
            layer is AVCaptureVideoPreviewLayer
        }) as? AVCaptureVideoPreviewLayer {
            switch orientation {
            case .portrait: layer.setAffineTransform(.init(rotationAngle: 0))
            case .landscapeLeft: layer.setAffineTransform(.init(rotationAngle: -.pi / 2))
            case .landscapeRight: layer.setAffineTransform(.init(rotationAngle: .pi / 2))
            case .portraitUpsideDown: layer.setAffineTransform(.init(rotationAngle: .pi))
            default: break
            }
        }
    }
}

