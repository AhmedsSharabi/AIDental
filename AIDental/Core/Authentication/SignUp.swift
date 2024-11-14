//
//  SignUp.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 10/10/2024.
//

import SwiftUI

struct SignUp: View {
    @Binding var showSignup: Bool
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = SignInEmailViewModel()
  
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            /// Back Button
            Button(action: {
                showSignup = false
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            Spacer(minLength: 0)
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("Please sign up to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                CustomTF(sfIcon: "at", hint: "Email ID", value: $viewModel.email)
                
                CustomTF(sfIcon: "person", hint: "Full Name", value: $viewModel.displayName)
                    .padding(.top, 5)
                
                CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $viewModel.password)
                    .padding(.top, 5)
                
                Text("By signing up, you're agreeing to our **[Terms & Condition](https://apple.com)** and **[Privacy Policy](https://apple.com)**")
                    .font(.caption)
                    .tint(Color("appColor"))
                    .foregroundStyle(.gray)
                    .frame(height: 50)
                
                /// SignUp Button
                Button{
                    Task {
                        do {
                            try await viewModel.signUp()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.app, in: RoundedRectangle(cornerRadius: 5))
                        .foregroundStyle(.white)
                        .cornerRadius(5)
                }
                .hSpacing(.trailing)
                .disableWithOpacity(viewModel.emailOrPasswordIsEmpty())
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("Already have an account?")
                    .foregroundStyle(.gray)
                
                Button("Login") {
                    showSignup = false
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
        /// OTP Prompt
    }
}

#Preview {
    ContentView()
}

