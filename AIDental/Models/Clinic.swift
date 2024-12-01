//
//  ClinicModel.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import MapKit

struct Clinic: Identifiable, Codable {
    var id = UUID()
    let mapItem: MapItemData
    
    init(mapItem: MKMapItem) {
        self.mapItem = MapItemData(from: mapItem)
        }
}


struct MapItemData: Codable {
    var name: String?
    var address: String?
    var street: String?
    var latitude: Double
    var longitude: Double
    var url: URL?
    var phoneNumber: String?

    init(from mapItem: MKMapItem) {
        self.name = mapItem.name
        self.address = mapItem.placemark.title
        self.street = mapItem.placemark.thoroughfare
        self.latitude = mapItem.placemark.coordinate.latitude
        self.longitude = mapItem.placemark.coordinate.longitude
        self.url = mapItem.url
        self.phoneNumber = mapItem.phoneNumber
    }

    func toMKMapItem() -> MKMapItem {
            let addressDict: [String: Any]? = street != nil ? ["Street": street!] : nil
            let placemark = MKPlacemark(
                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                addressDictionary: addressDict
            )
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = name
            mapItem.url = url
            mapItem.phoneNumber = phoneNumber
            return mapItem
        }

}


