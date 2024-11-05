//
//  ClinicView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import SwiftUI

struct ClinicView: View {
    @State var clinic: Clinic
    @StateObject var viewModel = ClinicViewModel()
    var body: some View {
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
                if let phoneNumber = clinic.mapItem.phoneNumber,
                   let phoneURL = URL(string: "tel:\(phoneNumber)") {
                    Button(action: {
                        UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                    }) {
                        Text("Call Clinic")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

