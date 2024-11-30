//
//  OnBoardingView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                OnboardingPage(image: "1", description: "Instantly Check and Track Your Oral Health")
                    .tag(0)
                OnboardingPage(image: "2", description: "Hassle-Free Clinic Appointments")
                    .padding(.top, 30)
                    .tag(1)
                OnboardingPage(image: "3", description: "Personalized Dental Care at Your Fingertips")
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .ignoresSafeArea()

            if currentPage == 2 {
                VStack {
                    Spacer()
                    withAnimation(.easeIn(duration: 1)) {
                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        showOnboarding = false
                    }) {
                        Text("Get Started")
                            .frame(width: 250, height: 30)
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(.app)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
            }
            }
        }

    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
