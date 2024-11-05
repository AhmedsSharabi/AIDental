//
//  View+Extensions.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 10/10/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1)
    }
    @ViewBuilder
    func appColor() -> some View {
        self
            .foregroundColor(Color("appColor"))
    }
    
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

extension Color {
    func appColor() -> Color {
        Color("appColor")
    }
}

// Extension to compare CLLocationCoordinate2D values
extension CLLocationCoordinate2D {
    func isEqual(to coordinate: CLLocationCoordinate2D?) -> Bool {
        guard let coordinate = coordinate else { return false }
        return latitude == coordinate.latitude && longitude == coordinate.longitude
    }
}
