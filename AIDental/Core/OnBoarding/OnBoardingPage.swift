//
//  OnBoardingPage.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import SwiftUI

struct OnboardingPage: View {
    var image: String
    var description: String
    
    var body: some View {
        ZStack {
            Image("4")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(x: 0, y: 350)
                .rotationEffect(.degrees(20))
                .ignoresSafeArea()
            
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                Text(description)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .padding(.horizontal, 36)
                    .padding(.top, 10)
                Spacer()
            }
            .padding()
        }
        
    }
}

#Preview {
    OnboardingPage(image: "1", description: "Instantly Check and Track Your Oral Health")
}
