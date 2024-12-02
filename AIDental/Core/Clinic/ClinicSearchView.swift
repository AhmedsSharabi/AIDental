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
                                    HStack {
                                        Text(clinic.mapItem.name ?? "Unknown Clinic")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding()
                                        Spacer()
                                        let distance = locationManager.userLocation?.distance(from: CLLocation(latitude: clinic.mapItem.latitude, longitude: clinic.mapItem.longitude)) ?? 0
                                        Text("\(Int(distance))m")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                            .padding(.trailing, 16)
                                    }
                                    HStack {
                                        Text("\(clinic.mapItem.address ?? "Unknown Address")")
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            Spacer()
                                        Button {
                                            if let phoneURL = URL(string: "tel:\(clinic.mapItem.phoneNumber ?? "")") {
                                                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                                            }
                                        } label: {
                                            Text("Call")
                                                .font(.system(size: 15))
                                                .fontWeight(.black)
                                                .foregroundColor(.white)
                                                .underline()
                                        }
                                    }.padding(.horizontal, 16)
                                    
                                    NavigationLink(destination: AppointmentView(clinic: clinic)) {
                                        Rectangle()
                                        .fill(.applight)
                                        .frame(width: 211, height: 41)
                                        .cornerRadius(14)
                                        .overlay {
                                            Text("Book Appointment")
                                                .font(.system(size: 15))
                                                .foregroundColor(.app)
                                                .fontWeight(.bold)
                                        }
                                        
                                    }.padding(.top, 16)
                                }
                                .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                                .background(.app)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(16)
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
                        .tabViewStyle(.page(indexDisplayMode: .never))
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
