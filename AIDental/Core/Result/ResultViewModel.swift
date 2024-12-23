//
//  ResultViewModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 23/12/2024.
//

import Foundation
import GoogleGenerativeAI
import SwiftUI

@Observable
@MainActor class ResultViewModel {
    // Use a model that supports function calling, like a Gemini 1.5 model
    let generativeModel = GenerativeModel(
      name: "gemini-1.5-flash",
      apiKey: APIKey.default
    )
    var infoSatate: CaseState = .idle
    
    func generateInfo(prompt: String) async -> LocalizedStringKey {
        DispatchQueue.main.async {
            self.infoSatate = .loading
        }
        do {
            let generatedText = try await generativeModel.generateContent(prompt)
            let result = LocalizedStringKey(generatedText.text ?? "no result")
            infoSatate = .loaded
            print(result)
            return result
        } catch {
            print("can't generate info")
        }
        return "call failed"
    }
}
