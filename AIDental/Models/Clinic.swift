//
//  ClinicModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import MapKit

struct Clinic: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem

    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
}


