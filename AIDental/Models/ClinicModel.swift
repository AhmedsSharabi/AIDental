//
//  ClinicModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import Foundation
import MapKit

struct Clinic: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}
