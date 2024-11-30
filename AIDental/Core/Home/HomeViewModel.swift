//
//  HomeViewModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}
