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
    
    var body: some View {
        ZStack {
            if !showSignInView {
               
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
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
            .overlay {
                if #available(iOS 17, *) {
                    CircleView()
                        .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
                        .animation(.smooth(duration: 0.45, extraBounce: 0), value: isKeyboardShowing)
                } else {
                    CircleView()
                        .animation(.easeInOut(duration: 0.3), value: showSignup)
                        .animation(.easeInOut(duration: 0.3), value: isKeyboardShowing)
                }
            }
        }
    }
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.appPink, .red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            /// Moving When the Signup Pages Loads/Dismisses
            .offset(x: showSignup ? 90 : -90, y: -90 - (isKeyboardShowing ? 200 : 0))
            .blur(radius: 15)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
}

#Preview {
    ContentView()
}

