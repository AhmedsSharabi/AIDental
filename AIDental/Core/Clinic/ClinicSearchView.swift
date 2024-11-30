//
//  ClinicSearchView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 04/11/2024.
//

import SwiftUI
import MapKit
import CoreLocation


struct ClinicSearchView: View {
    @StateObject private var locationManager = LocationManager()
    @State var viewModel = ClinicViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Map View
                if let userLocation = locationManager.userLocation {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: viewModel.selectedClinicCoordinate ?? userLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
                        annotationItems: viewModel.clinics) { clinic in
                        MapMarker(coordinate: clinic.mapItem.placemark.coordinate, tint: .blue)
                    }
                        .edgesIgnoringSafeArea(.top)
                        .onAppear {
                            viewModel.searchDentalClinics(near: userLocation)
                        }
                } else {
                    Text("Locating...")
                }
                VStack {
                    Spacer()
                    // Swiping Cards
                    if !viewModel.clinics.isEmpty {
                        TabView {
                            ForEach(viewModel.clinics) { clinic in
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
                                .onAppear() {
                                    withAnimation {
                                        viewModel.selectedClinicCoordinate = clinic.mapItem.placemark.coordinate
                                    }
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 250)
                        .padding(.bottom, 5) // Adjust as needed for layout
                    }
                }
            }
            .onAppear {
                locationManager.requestLocation()
            }
        }
    }
}
