//
//  TabbarView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        TabView {
            ClinicSearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Clinics")
                }
            
            ScannerView(showSignInView: $showSignInView)
                .tabItem {
                    Image(systemName: "camera")
                    Text("Scanner")
                }
            
            ProfileView(showSignInView: $showSignInView)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .tint(.app)
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
