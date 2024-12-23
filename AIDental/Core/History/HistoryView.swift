//
//  HistoryView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 23/12/2024.
//

import SwiftUI

struct HistoryView: View {
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredPredictions, id: \.id) { prediction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(prediction.prediction.capitalized)")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("appColor"))
                                Text("Confidence: \(Int(prediction.confidence*100))%")
                                    .font(.system(size: 16))
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                            Text(formattedRelativeDate(from: prediction.date))
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 8)
                     
                    }
                }
                
            }
            
            .navigationTitle("Prediction History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
    
    private var filteredPredictions: [Prediction] {
           let predictions = viewModel.user?.prediction ?? []
        return predictions.sorted(by: { $0.date > $1.date }) // Sort by newest
    }
    
    private func formattedRelativeDate(from date: Date) -> String {
           let formatter = RelativeDateTimeFormatter()
           formatter.unitsStyle = .abbreviated // Options: .full, .short, .abbreviated
           formatter.dateTimeStyle = .named    // Removes seconds granularity
           return formatter.localizedString(for: date, relativeTo: Date())
    }
}
