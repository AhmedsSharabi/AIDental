//
//  Appointment.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import Foundation

struct Appointment: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let clinicName: String
    var notes: String
}
