//
//  HomeView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State var clinicViewModel = ClinicViewModel()
    var body: some View {
        ZStack {
            Image("4")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350)
                .offset(x: 0, y: 0)
                .rotationEffect(.degrees(20))
                .ignoresSafeArea()
            VStack {
                Text("Hello,")
                Text(viewModel.user?.displayName ?? "User")
                
                
                Text("Dental Clinic Near Me")
                if !clinicViewModel.clinics.isEmpty {
                    TabView {
                        ForEach(clinicViewModel.clinics) { clinic in
                            VStack {
                                Text(clinic.mapItem.name ?? "Unknown Clinic")
                                    .font(.headline)
                                    .padding()
                                Text(clinic.mapItem.placemark.title ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom)

                                HStack {
                                    
                                    
                                    NavigationLink(destination: ClinicView(clinic: clinic)) {
                                        Text("View Clinic")
                                            .foregroundColor(.app)
                                        
                                    }
                                }
                                .padding()
                            }
                            .frame(width: 300, height: 200)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 250)
                    .padding(.bottom, 5)
                }
                
                Text("Upcoming Appointment")
                
                
                Text("My Teeth Condition")
                HStack {
                    
                }

            }
        }
        .ignoresSafeArea()
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
       
}

#Preview {
    HomeView()
}
