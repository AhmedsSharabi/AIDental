//
//  Login.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 10/10/2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct Login: View {
    /// View Properties
    @StateObject private var viewModel = SignInEmailViewModel()
    @StateObject private var viewModel2 = AuthenticationViewModel()
    @State private var showForgotPasswordView: Bool = false
    /// Reset Password View (with New Password and Confimration Password View)
    @State private var showResetView: Bool = false
    @Binding var showSignup: Bool
    @Binding var showSignInView: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
//            Spacer(minLength: 0)
//            Image("skin")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 100)
//                .clipShape(Circle())
//                .offset(y: -50)
//                .hSpacing()
//            Text("SKINALYSIS")
//                .font(.subheadline)
//                .fontWeight(.heavy)
//                .foregroundStyle(.appPink)
//                .offset(y: -60)
//                .hSpacing()
            Spacer(minLength: 0)
            Text("Log In")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please sign in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                CustomTF(sfIcon: "at", hint: "Email ID", value: $viewModel.email)
                
                CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $viewModel.password)
                    .padding(.top, 5)
                
                Button {
                    Task {
                        
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Log In")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.app), in: RoundedRectangle(cornerRadius: 5))
                        .foregroundStyle(.white)
                        .cornerRadius(5)
                }
                .hSpacing(.trailing)
                /// Disabling Until the Data is Entered
                .disableWithOpacity(viewModel.emailOrPasswordIsEmpty())
            }
            .padding(.top, 20)
            .padding()
            Text("Or log in with")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .hSpacing()
            HStack(spacing: 8){
                Button(action: {
                    Task {
                        do {
                            try await viewModel2.signInApple()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    SignInWithAppleButtonViewRepresentable(type: .default, style: .whiteOutline)
                        .allowsHitTesting(false)

                })
                .frame(height: 40)
                
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .icon, state: .pressed)) {
                    Task {
                        do {
                            try await viewModel2.signInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
                
                .cornerRadius(10)
                .hSpacing()
                
                
            }
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("Don't have an account?")
                    .foregroundStyle(.gray)
                
                Button("SignUp") {
                    showSignup.toggle()
                }
                .fontWeight(.bold)
                .tint(.app)
            }
            .font(.callout)
            .hSpacing()

            
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
        /// Asking Email ID For Sending Reset Link
        .sheet(isPresented: $showForgotPasswordView, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted a Custom Sheet Corner Radius
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        /// Resetting New Password
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted a Custom Sheet Corner Radius
                PasswordResetView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                PasswordResetView()
                    .presentationDetents([.height(350)])
            }
        })
    }
  
}

#Preview {
    ContentView()
}
