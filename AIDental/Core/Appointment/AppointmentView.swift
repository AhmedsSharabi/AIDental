//
//  AppointmentView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import SwiftUI
import CoreLocation

struct AppointmentView: View {
    @State var clinic: Clinic
    @State var viewModel = AppointmentViewModel()
    @State var locationManager = LocationManager()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        VStack {
                            Text(clinic.mapItem.name ?? "Unknown Clinic")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(clinic.mapItem.address ?? "Unknown Address")")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }.padding()
                        Spacer()
                        VStack {
                            Button {
                                viewModel.openInMaps(for: clinic.mapItem)
                            } label: {
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                            Button {
                                if let phoneURL = URL(string: "tel:\(clinic.mapItem.phoneNumber ?? "")") {
                                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                                }
                            } label: {
                                Image(systemName: "phone.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                            
                        }.padding()
                        
                    }.hSpacing(.center)
                    
                    
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .background(.app)
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text("Schedule an Appointment")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        
                        DatePicker("Select Date & Time", selection: $viewModel.appointmentDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.graphical)
                            .padding(.bottom)
                        Text("Description")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                        TextEditor(text: $viewModel.notes)
                            .scrollContentBackground(.hidden)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(14)
                        
                        Toggle(isOn: $viewModel.sharePrediction){
                            Text("Share My Latest Prediction")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                                            
                        }
                            .toggleStyle(SwitchToggleStyle(tint: .app))
                            .hSpacing(.leading)
                            .padding(.bottom, 24)

                        
                        Button(action: {
                            viewModel.confirmationAlert.toggle()
                        }) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                Text("Save Appointment")
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.app)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.top)
                }
                
            }
            .navigationTitle("Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.confirmationAlert) {
                Alert(title: Text("Save Appointment"), message: Text("Are you sure you want to save this appointment?\nClinic \(clinic.mapItem.name ?? "Unknown Clinic") \nDate: \(viewModel.appointmentDate, style: .date)\nDescription: \(viewModel.notes)"), primaryButton: .default(Text("Save")) {
                    Task {
                        do {
                            try await viewModel.createAppointment(clinic: clinic)
                            viewModel.confirmationAlert = false
                            viewModel.successSheet = true
                            
                        } catch {
                            viewModel.confirmationAlert = false

                        }
                    }
                }, secondaryButton: .destructive(Text("Cancel")))
            }
            .sheet(isPresented: $viewModel.successSheet, onDismiss: { dismiss() }) {
                SuccessView()
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
        }
    }
}
