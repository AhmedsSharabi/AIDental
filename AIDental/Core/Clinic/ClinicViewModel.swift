//
//  ClinicViewModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import CoreLocation
import SwiftUI
import MapKit

class ClinicViewModel: ObservableObject {
    @Published var clinics = [Clinic]()
    
    func searchDentalClinics(near location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "dental clinic"
        request.region = MKCoordinateRegion(center: location.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                self.clinics = response.mapItems.map { Clinic(mapItem: $0) }
            }
        }
    }
    
    func openInMaps(for mapItem: MKMapItem) {
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

}
