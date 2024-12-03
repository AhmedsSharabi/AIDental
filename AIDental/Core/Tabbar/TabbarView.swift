//
//  TabbarView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 05/11/2024.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showSignInView: Bool
    @State private var selectedTab: Int = 0 // Default to Home tab
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0) // Tag for the Home tab
            
            ClinicSearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Clinics")
                }
                .tag(1) // Tag for the Clinics tab
            
            ScannerView(showSignInView: $showSignInView)
                .tabItem {
                    Image(systemName: "camera")
                    Text("Scanner")
                }
                .tag(2) // Tag for the Scanner tab
            
            ProfileView(showSignInView: $showSignInView)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(3) // Tag for the Profile tab
        }
        .tint(.app)
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
