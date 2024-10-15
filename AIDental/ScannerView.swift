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
            ZStack {
                GeometryReader { geometry in
                    let size = geometry.size
                    let squareWidth = size.width
                    let squareHeight = size.height
                    
                    ZStack {
                        CameraView(frameSize: CGSize(width: squareWidth, height: squareHeight), session: $session, orientation: $orientation)
                            .cornerRadius(4)
                            .onRotate { newOrientation in
                                if session.isRunning {
                                    orientation = newOrientation
                                }
                            }
                    }
                    .frame(width: squareWidth, height: squareHeight)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(Color("Blue1"))
                            .frame(height: viewModel.scannerState == .loading ? 0 : 2.5)
                            .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: viewModel.isScanning ? 15 : -15)
                            .offset(y: viewModel.isScanning ? squareHeight : 0)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .foregroundStyle(.black)
                            .opacity(0.5)
                        
                        HStack {
                            Spacer()
                            Button(action: { viewModel.captureImage(session: session) }) {
                                Image(systemName: "button.programmable")
                                    .font(.system(size: 50))
                                    .foregroundColor(.appPink)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 20)
                        
                        HStack {
                            Button {
                                showingImagePicker.toggle()
                            } label: {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: ProfileView(showSignInView: $showSignInView)) {
                                Image(systemName: "person.crop.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .ignoresSafeArea()
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
            .onChange(of: session.isRunning) { newValue in
                if newValue {
                    orientation = UIDevice.current.orientation
                }
            }
        }
    }
}

