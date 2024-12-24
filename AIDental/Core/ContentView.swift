//
//  ContentView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showSignInView: Bool = false
    @State private var showSignup: Bool = false
    @State private var isKeyboardShowing: Bool = false
    @State private var showOnboarding: Bool = true
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding, showSignInView: $showSignInView)
            } else if !showSignInView {
                TabbarView(showSignInView: $showSignInView)
                    .onAppear {
                        if !UserDefaults.standard.bool(forKey: "hasShownDisclaimer") {
                            showAlert = true
                            UserDefaults.standard.set(true, forKey: "hasShownDisclaimer")
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Attention"), message: Text("This app is for demonstration purposes only. It is not intended for use in a clinical setting. You should not use this app to make any medical decisions. Please consult a healthcare professional for medical advice."), dismissButton: .default(Text("I understand")))
                    }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
            
            if UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
                showOnboarding = false
            }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                Login(showSignup: $showSignup, showSignInView: $showSignInView)
                    .navigationDestination(isPresented: $showSignup) {
                        SignUp(showSignup: $showSignup, showSignInView: $showSignInView)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                        if !showSignup {
                            isKeyboardShowing = true
                        }
                    })
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                        isKeyboardShowing = false
                    })
            }
        }
    }
}

#Preview {
    ContentView()
}

