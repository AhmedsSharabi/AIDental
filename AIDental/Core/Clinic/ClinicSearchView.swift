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
    @State var locationManager = LocationManager()
    @State var viewModel = ClinicViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Map View
                if let userLocation = locationManager.userLocation {
                    Map(
                        coordinateRegion: .constant(
                            MKCoordinateRegion(
                                center: viewModel.selectedClinicCoordinate ?? userLocation.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                        ),
                        annotationItems: viewModel.clinics
                    ) { clinic in
                        MapMarker(
                            coordinate: CLLocationCoordinate2D(
                                latitude: clinic.mapItem.latitude,
                                longitude: clinic.mapItem.longitude
                            ),
                            tint: .blue
                        )
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
                                    Text("\(clinic.mapItem.latitude), \(clinic.mapItem.longitude)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding(.bottom)
                                    
                                    NavigationLink(destination: ClinicView(clinic: clinic)) {
                                        Text("View Clinic")
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                }
                                .frame(width: 300, height: 200)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
                                .onAppear {
                                    withAnimation {
                                        viewModel.selectedClinicCoordinate = CLLocationCoordinate2D(
                                            latitude: clinic.mapItem.latitude,
                                            longitude: clinic.mapItem.longitude
                                        )
                                    }
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 250)
                        .padding(.bottom, 5)
                    }
                }
            }
            .task {
                locationManager.requestLocation()
            }
        }
    }
}
