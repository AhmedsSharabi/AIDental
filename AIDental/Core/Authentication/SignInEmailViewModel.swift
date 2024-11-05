//
//  SignInEmailViewModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 10/10/2024.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    func resetPassword() async throws {
        guard !email.isEmpty else {
            print("No email found.")
            return
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func emailOrPasswordIsEmpty() -> Bool {
        return email.isEmpty || password.isEmpty
    }
}
