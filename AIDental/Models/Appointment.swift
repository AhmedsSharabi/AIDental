//
//  Appointment.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 30/11/2024.
//

import Foundation

struct Appointment: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var clinic: Clinic
    var notes: String
    var prediction: Prediction?
    
}
