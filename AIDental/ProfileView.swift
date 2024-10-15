//
//  ProfileView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 11/10/2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showPredictionDetails = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                profileHeader
                
                Form {
                    if let user = viewModel.user {
                        
                        Section(header: Text("User Information")) {
                            if let isAnonymous = user.isAnonymous {
                                Text("Is Anonymous: \(isAnonymous.description.capitalized)")
                            }
                            
                            Button {
                                viewModel.togglePremiumStatus()
                            } label: {
                                Text("Premium Status: \((user.isPremium ?? false).description.capitalized)")
                            }
                        }
                        
                    }
                }
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SettingsView(showSignInView: $showSignInView)
                        } label: {
                            Image(systemName: "gear")
                                .font(.headline)
                        }
                    }
                }
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .onChange(of: selectedItem) { newItem in
                if let newItem {
                    viewModel.saveProfileImage(item: newItem)
                }
            }
        }
    }
    
    private var profileHeader: some View {
        VStack {
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    if let urlString = viewModel.user?.profileImagePathUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                        }
                    } else {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.top, 16)
            
            if let user = viewModel.user {
                Text(user.email ?? user.userId)
                    .font(.headline)
                    .padding(.top, 8)
                
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showSignInView: .constant(false))
    }
}
