//
//  ClinicView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import SwiftUI
import MapKit

struct ClinicView: View {
    @State var clinic: Clinic
    @State var viewModel = ClinicViewModel()
    @State private var appointmentDate: Date = Date()
    @State private var showAppointmentSheet = false
    @State private var notes: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Clinic Name
                Text(clinic.mapItem.name ?? "Unknown Clinic")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.top)
                
                // Address
                if let address = clinic.mapItem.address {
                    Text("📍 \(address)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                // Contact Info
                if let phoneNumber = clinic.mapItem.phoneNumber {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(phoneNumber)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if let phoneURL = URL(string: "tel:\(phoneNumber)") {
                                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                                }
                            }
                    }
                    .padding(.top)
                }
                
                // Get Directions Button
                Button(action: {
                    viewModel.openInMaps(for: clinic.mapItem)
                }) {
                    HStack {
                        Image(systemName: "map")
                        Text("Get Directions")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                
                // Appointment Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Schedule an Appointment")
                        .font(.headline)
                    
                    DatePicker("Select Date & Time", selection: $appointmentDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                        .padding(.bottom)
                    
                    TextField("Notes (e.g., Reason for visit)", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        saveAppointment()
                    }) {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Save Appointment")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.top)
            }
            .padding()
        }
    }
    
    func saveAppointment() {
        // Logic to save the appointment
        print("Appointment saved for \(appointmentDate) with notes: \(notes)")
    }
}
