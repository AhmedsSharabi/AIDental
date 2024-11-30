//
//  Prediction.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import Foundation

struct Prediction: Codable, Identifiable {
    let id: UUID
    let prediction: String
    let confidence: Double
    var date = Date()

}
