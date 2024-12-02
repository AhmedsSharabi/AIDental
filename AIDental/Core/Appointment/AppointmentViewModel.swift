//
//  AppointmentViewModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 02/12/2024.
//

import Foundation
import SwiftUI
import MapKit

@Observable @MainActor
class AppointmentViewModel {
    var user: DBUser? = nil
    var appointmentDate: Date = Date()
    var notes: String = ""
    var sharePrediction: Bool = false
    var confirmationAlert: Bool = false
    var successSheet: Bool = false
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func addAppointment(appointment: Appointment) async throws {
        guard let user = self.user else { return }
        
        Task {
            try await UserManager.shared.addAppointment(userId: user.userId, appointment: appointment)
            try await loadCurrentUser()
        }
    }
    
    func removeAppointment(appointment: Appointment) async throws {
        guard let user = self.user else { return }
        
        Task {
            try await UserManager.shared.removeAppointment(userId: user.userId, appointment: appointment)
        }
    }
    
    func openInMaps(for mapItemData: MapItemData) {
        let mapItem = mapItemData.toMKMapItem()
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    func createAppointment(clinic: Clinic) async throws {
        guard let user = self.user else { return }
        
        let appointment = Appointment(
            date: appointmentDate,
            clinic: clinic,
            notes: notes,
            prediction: sharePrediction ? user.prediction?.last : nil
        )
        try await addAppointment(appointment: appointment)
    }
    
}
