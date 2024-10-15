//
//  ResultView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 15/10/2024.
//

import SwiftUI

struct ResultView: View {
    @Binding var scannerState: CaseState
    @Binding var result: Prediction?
//    @StateObject var viewModel = MoreInfoViewModel()
    @State private var generateInfo: LocalizedStringKey = ""
    var body: some View {
            VStack {
                if scannerState == .loading  {
                    ProgressView()
                }
                if scannerState == .loaded {
                    if let prediction = result {
                        ScrollView {
                            Text("Your condition is:")
                            Text(prediction.prediction)
                                .bold()
                            Text("Confidence: \(Int(prediction.confidence*100))%")
                                .bold()
//                            if viewModel.infoSatate == .loading {
//                                ProgressView()
//                            }
//                            else if viewModel.infoSatate == .loaded {
//                                Text("More Information")
//                                    .fontWeight(.bold)
//                                    .padding(20)
//                                Text( generateInfo)
//                            }
//                        }
                        .padding()
//                        .task {
//                            if let result = result {
//                                generateInfo = await viewModel.generateInfo(prompt: "Give information about \(result.prediction)")
//                            }
                        }
                    }
                    else if scannerState == .error {
                        Text("No Condition Found")
                    }
                    
                    
                }
            }
    }
    
}

