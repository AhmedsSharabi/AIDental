//
//  ClinicSearchView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 04/11/2024.
//

import SwiftUI
import MapKit
import CoreLocation

import SwiftUI
import MapKit
import CoreLocation

struct ClinicSearchView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var clinics = [Clinic]()
    @State private var selectedClinicCoordinate: CLLocationCoordinate2D?
    @StateObject var viewModel = ClinicViewModel()
    
    var body: some View {
        ZStack {
            // Map View
            if let userLocation = locationManager.userLocation {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: selectedClinicCoordinate ?? userLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
                    annotationItems: clinics) { clinic in
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
                if !clinics.isEmpty {
                    TabView {
                        ForEach(clinics) { clinic in
                            VStack {
                                Text(clinic.mapItem.name ?? "Unknown Clinic")
                                    .font(.headline)
                                    .padding()
                                Text(clinic.mapItem.placemark.title ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                                HStack {
                                    Button(action: {
                                        viewModel.openInMaps(for: clinic.mapItem)
                                    }) {
                                        Text("Get Directions")
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.trailing)
                                    

                                    Button {
                                    
                                    } label: {
                                        Text("Select Clinic")
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
                                    selectedClinicCoordinate = clinic.mapItem.placemark.coordinate
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
