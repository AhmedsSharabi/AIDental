//
//  DBUser.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import Foundation

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let displayName: String?
    let dateCreated: Date?
    let photoUrl: String?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    let prediction: [Prediction]?

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.displayName = auth.displayName
        self.dateCreated = Date()
        self.photoUrl = auth.photoUrl
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
        self.prediction = nil
    }
    
    init(
        userId: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        displayName: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String? = nil,
        prediction: [Prediction]? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.displayName = displayName
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
        self.prediction = prediction
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case displayName = "display_name"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
        case prediction = "prediction"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
        self.prediction = try container.decodeIfPresent([Prediction].self, forKey: .prediction)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
        try container.encodeIfPresent(self.prediction, forKey: .prediction)
    }
    
}
