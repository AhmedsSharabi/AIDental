//
//  ScannerView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 15/10/2024.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    @State private var session: AVCaptureSession = .init()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @Binding var showSignInView: Bool
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @Environment(\.openURL) private var openURL
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(Color("appColor"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Scan Your Teeth")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("appColor"))
                Spacer(minLength: 0)
                
                GeometryReader { geometry in
                    let size = geometry.size
                    let horizontalPadding: CGFloat = 10
                    let squareWidth = size.width - (horizontalPadding * 2)
                    
                    ZStack {
                        CameraView(frameSize: CGSize(width: squareWidth, height: squareWidth), session: $session, orientation: $orientation)
                            .cornerRadius(4)
                            .scaleEffect(0.97)
                            .onRotate {
                                if session.isRunning {
                                    orientation = $0
                                }
                            }
                        
                        ForEach(0...4, id: \.self) { index in
                            let rotation = Double(index) * 90
                            
                            RoundedRectangle(cornerRadius: 2, style: .circular)
                                .trim(from: 0.61, to: 0.64)
                                .stroke(Color("appColor"), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.degrees(rotation))
                        }

                        
                    }
                    .frame(width: squareWidth, height: squareWidth)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(Color("appColor"))
                            .frame(height: 2.5)
                            .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: viewModel.isScanning ? 15 : -15)
                            .offset(y: viewModel.isScanning ? squareWidth : 0)
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                
                Spacer(minLength: 15)
                
               
                
                Button(action: { viewModel.captureImage(session: session) }) {
                    Image(systemName: "camera.aperture")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.app)
                }
                .padding(.bottom, 25)
                
                Button {
                    showingImagePicker.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .appColor()
                        .frame(width: 250, height: 50)
                        .overlay {
                            HStack {
                                Image(systemName: "photo")
                                Text("Select Image")
                            }
                            .foregroundStyle(.white)
                        }
                       
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage) {
                        if let image = inputImage {
                            viewModel.sendImageForProcessing(image: image)
                            viewModel.scannerState = .loading
                            viewModel.showResult.toggle()
                        }
                    }
                }
                
                Spacer(minLength: 45)
            }

            .padding(15)
            .onAppear { viewModel.checkCameraPermission(session: session) }
            .onDisappear { session.stopRunning() }
            .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
                if viewModel.cameraPermission == .denied {
                    Button("Settings") {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            openURL(settingsURL)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
            .sheet(isPresented: $viewModel.showResult, onDismiss: {
                viewModel.reactivateCamera(session: session)
            }) {
                ResultView(scannerState: $viewModel.scannerState, result: $viewModel.result)
                    .presentationDetents(viewModel.scannerState == .loading ? [.fraction(0.25)] : [.medium])
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage) {
                    if let image = inputImage {
                        viewModel.sendImageForProcessing(image: image)
                        withAnimation { viewModel.scannerState = .loading }
                        viewModel.showResult.toggle()
                    }
                }
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .onChange(of: session.isRunning) {
                if session.isRunning {
                    orientation = UIDevice.current.orientation
                }
            }
        }
    }
}

