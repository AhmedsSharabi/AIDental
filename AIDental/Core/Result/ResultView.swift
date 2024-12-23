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
    @Binding var sheetSize: Double
    @State var viewModel = ResultViewModel()
    @State private var generateInfo: LocalizedStringKey = """
    """
    @State private var showMoreInfo = false
    var body: some View {
        ScrollView {
            VStack {
                if scannerState == .loading  {
                    VStack(spacing: 12) {
                        Text("Analyzing...")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color("appColor"))
                        ProgressView()
                    }
                        .padding(24)
                }
                if scannerState == .loaded {
                    if let prediction = result {
                        VStack {
                            Text("Scaner Result:")
                                .font(.system(size: 18))
                                .fontWeight(.black)
                                .foregroundColor(Color("appColor"))
                                
                            VStack {
                               
                                HStack(spacing: 4) {
                                    Text("We are")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                    Text("\(Int(prediction.confidence*100))%")
                                        .font(.system(size: 16))
                                        .fontWeight(.black)
                                        .foregroundColor(Color("appColor"))
                                        .underline()
                                    Text("Confident")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                    Text("That You Have:")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                    
                                }
                                
                                   
                                    Text(prediction.prediction.capitalized)
                                        .fontWeight(.black)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color("appColor"))
                                        .underline()

                            }.padding()
                            
                            if showMoreInfo {
                                if viewModel.infoSatate == .loading {
                                    VStack(spacing: 12) {
                                        Text("Analyzing...")
                                            .font(.system(size: 18))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("appColor"))
                                        ProgressView()
                                    }
                                        .padding(24)
                                }
                                else if viewModel.infoSatate == .loaded {
                                    Text("More Information about \(prediction.prediction.capitalized)")
                                        .fontWeight(.black)
                                        .font(.system(size: 18))
                                        .foregroundColor(Color("appColor"))
                                        .padding(.vertical, 24)
                                    Text(generateInfo)
                                        .font(.system(size: 16))
                                }
                            } else {
                                Button {
                                    withAnimation {
                                        showMoreInfo.toggle()
                                        sheetSize = 0.8
                                    }
                                } label: {
                                    Text("More Information")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color("appColor"))
                                        .cornerRadius(10)
                                }
                            }
                            
                        }
                        .task {
                            if let result = result {
                            
                                generateInfo = await viewModel.generateInfo(prompt: "Provide a detailed explanation about \(result.prediction) for human teeth with the symptoms, causes, prevention tips, and possible treatments, without title")
                            }
                        }
                        .padding(24)
                    }
                    else if scannerState == .error {
                        Text("No Condition Found")
                    }
                    
                    
                }
                   
            }
        }
    }
    
}

