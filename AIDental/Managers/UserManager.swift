//
//  UserManager.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 10/10/2024.
//

import Foundation
import FirebaseFirestore

struct Prediction: Codable, Identifiable {
    let id: UUID
    let prediction: String
    let confidence: Double

}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let prediction: [Prediction]?
    let profileImagePath: String?
    let profileImagePathUrl: String?

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.prediction = nil
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
    }
    
    init(
        userId: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        prediction: [Prediction]? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.prediction = prediction
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case prediction = "prediction"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.prediction = try container.decodeIfPresent([Prediction].self, forKey: .prediction)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.prediction, forKey: .prediction)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
    
    private func userFavoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium,
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path!,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url!,
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addPrediction(userId: String, prediction: Prediction) async throws {
        print("sucsess")
        guard let encodedPrediction = try? Firestore.Encoder().encode(prediction) else {
            throw URLError(.badURL)
        }
        guard let dict = encodedPrediction as? [String: Any] else {
            throw URLError(.badURL)
        }
        let userDocRef = Firestore.firestore().collection("users").document(userId)
        try await userDocRef.updateData([
            DBUser.CodingKeys.prediction.rawValue: FieldValue.arrayUnion([dict])
        ])
    }
    
    func removeFavoriteMovie(userId: String) async throws {
        let data: [String:Any?] = [
            DBUser.CodingKeys.prediction.rawValue : nil
        ]
        
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
    
}
