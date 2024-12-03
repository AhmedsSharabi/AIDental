//
//  HomeView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    @State var clinicViewModel = ClinicViewModel()
    @State var locationManager = LocationManager()
    @Binding var selectedTab: Int
    var body: some View {
        ZStack {
            
            GeometryReader { geometry in
                Image("4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500)
                    .offset(x: 130, y: 50)
                    .rotationEffect(.degrees(-20))
                    .ignoresSafeArea()
            }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hello,")
                        .font(.system(size: 27))
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    Text(viewModel.user?.displayName ?? "User")
                        .font(.system(size: 27))
                        .fontWeight(.bold)
                        .foregroundStyle(.app)
                }
                .hSpacing(.leading)
                .padding(.top, 60)
                .padding(.bottom, 10)
                
                
                Text("Dental Clinic Near Me")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                TabView {
                    ForEach(clinicViewModel.clinics) { clinic in
                        HStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(clinic.mapItem.name ?? "Unknown Clinic")
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                        .padding(.bottom, 10)
                                    HStack {
                                        let distance = locationManager.userLocation?.distance(from: CLLocation(latitude: clinic.mapItem.latitude, longitude: clinic.mapItem.longitude)) ?? 0
                                        Text("\(Int(distance))m")
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                        let address = clinic.mapItem.street ?? "Unknown Address"
                                        Text(address)
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                        
                                    }
                                    Text("Open now")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.green)
                                    
                                }
                                Spacer()
                                Button {
                                    clinicViewModel.openInMaps(for: clinic.mapItem)
                                } label: {
                                    Image(systemName: "paperplane.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.app)
                                }
                            }
                            .padding(.horizontal, 22)
                            .frame(width: 350, height: 136)
                            .background(Color.white)
                            .cornerRadius(14)
                            .shadow(radius: 2)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: 150)
                
                .padding(.bottom, 5)
                
                Text("Upcoming Appointment")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                VStack(alignment: .center) {
                    
                    
                    Rectangle()
                        .fill(.app)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 121)
                        .cornerRadius(14)
                        .overlay(
                            VStack {
                                HStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 45, height: 45)
                                        .cornerRadius(40)
                                        .overlay(
                                            Image(systemName: "calendar")
                                                .foregroundColor(.app)
                                        )
                                    VStack(alignment: .leading) {
                                        let appointment = viewModel.user?.appointment?.last?.clinic.mapItem.name ?? "Unknown Clinic"
                                        Text(appointment)
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                        
                                        let location = viewModel.user?.appointment?.last?.clinic.mapItem.street ?? "Unknown Address"
                                        Text(location)
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                            .foregroundStyle(.white)
                                        
                                    }
                                    Spacer()
                                    
                                }
                                .padding(.horizontal, 16)
                                HStack {
                                    Rectangle()
                                        .fill(.applight)
                                        .frame(width: 140, height: 40, alignment: .center)
                                        .cornerRadius(14)
                                        .overlay(
                                            Text("Consultation")
                                                .font(.system(size: 14))
                                                .fontWeight(.medium)
                                                .foregroundColor(.app)
                                        )
                                    
                                    Rectangle()
                                        .fill(.applight)
                                        .frame(width: 185, height: 40, alignment: .center)
                                        .cornerRadius(14)
                                        .overlay {
                                            let date = viewModel.user?.appointment?.last?.date ?? Date()
                                            HStack {
                                                Image(systemName: "calendar")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.app)
                                                Text(date, style: .date)
                                                    .font(.system(size: 14))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.app)
                                            }
                                        }
                                }
                            }
                        )
                    
                    Rectangle()
                        .fill(.applight)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 47)
                        .cornerRadius(14)
                        .overlay(
                            Label("Add Appointment", systemImage: "plus.circle.fill")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                        )
                        .onTapGesture {
                            withAnimation {
                                selectedTab = 1
                            }
                        }
                    
                }
                Text("My Teeth Condition")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .padding(.top, 20)
                
                HStack {
                    Rectangle()
                        .fill(.applight)
                        .frame(width: UIScreen.main.bounds.width * 0.7 , height: 78)
                        .cornerRadius(14)
                        .overlay(
                            HStack {
                                Image("denture")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 75)
                                    .padding(.leading, 15)
                                    .padding(.trailing, 12)
                                
                                VStack(alignment: .leading) {
                                    let prediction = viewModel.user?.prediction?.last?.prediction ?? "Excellent"
                                    Text(prediction)
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.app)
                                    if let date = viewModel.user?.prediction?.last?.date {
                                        Text("Last checked: \(date.formatted(date: .abbreviated, time: .omitted))")
                                            .font(.system(size: 14))
                                            .fontWeight(.medium)
                                            .foregroundStyle(.secondary)
                                    } else {
                                        Text("No data available")
                                            .font(.system(size: 14))
                                            .fontWeight(.medium)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                                .frame(maxWidth: UIScreen.main.bounds.width - 32, alignment: .leading)
                            
                        )
                    
                    Rectangle()
                        .fill(.applight)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 78)
                        .cornerRadius(14)
                        .overlay(
                            Image("scanner")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                        )
                        .onTapGesture {
                            withAnimation {
                                selectedTab = 2
                            }
                        }
                }
                
                Rectangle()
                    .fill(Color(red: 0.93, green: 0.93, blue: 0.93))
                    .frame(width: UIScreen.main.bounds.width - 32, height: 47)
                    .cornerRadius(14)
                    .overlay(
                        HStack {
                            Text("View history")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0.48, green: 0.48, blue: 0.48))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0.48, green: 0.48, blue: 0.48))
                        }
                    )
                
                Spacer()
                
            }
            .padding(16)
        }
        .ignoresSafeArea()
        .task {
            try? await viewModel.loadCurrentUser()
            locationManager.requestLocation()
            if let userLocation = locationManager.userLocation {
                clinicViewModel.searchDentalClinics(near: userLocation)
            }
        }
        
    }
    
}

#Preview {
    HomeView(selectedTab: .constant(0))
}
