//
//  ProfileView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 11/10/2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @State var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State var isFaceIDEnabled: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showPredictionDetails = false
    
    var body: some View {
        NavigationStack {
            VStack {
                profileHeader
                Form {
                    Section("More Settings") {
                        Toggle(isOn: $isFaceIDEnabled) {
                            Label("Face ID", systemImage: "faceid")
                        }
                        NavigationLink {
                            
                        } label: {
                            Label("Past Predictions", systemImage: "list.bullet.rectangle")
                        }
                        NavigationLink {
                            SettingsView(showSignInView: $showSignInView)
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                    Section("More Info") {
                        
                        NavigationLink {
                            
                        } label: {
                            Label("About", systemImage: "info.circle")
                        }
                        NavigationLink {
                            
                        } label: {
                            Label("Help", systemImage: "questionmark.circle")
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
            }
            .background(Color(.systemGroupedBackground))
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .onChange(of: selectedItem) {
                if let selectedItem {
                    viewModel.saveProfileImage(item: selectedItem)
                }
            }
        }
    }
    
    private var profileHeader: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(.applight)
                    .frame(width: 210, height: 350)
                    .ignoresSafeArea()
                    .overlay {
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
                                                .frame(width: 124, height: 124)
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
                            Text(viewModel.user?.displayName ?? "App User")
                                .font(.system(size: 24))
                                .fontWeight(.semibold)
                                .padding(.top, 8)
                        }
                    }
                VStack(alignment: .leading) {
                        Text("Profile")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 60)
                            .hSpacing(.trailing)
                        Text("Email")
                            .font(.system(size: 14))
                        Text(viewModel.user?.email ?? "ahmeds.alsharabi@gmaail.com")
                            .font(.system(size: 10))
                            .padding(.bottom, 15)
                        
                        Text("Contact")
                            .font(.system(size: 14))
                        Text("01128534629")
                            .font(.system(size: 10))
                            .padding(.bottom, 15)
                        
                        Text("Password")
                            .font(.system(size: 14))
                        Text("ahmeds.alsharab")
                            .font(.system(size: 10))
                    
                    Spacer()
                    
                }
                .frame(maxHeight: .infinity)
                    
            }
            .frame(height: 280)
            .hSpacing(.leading)
            

        }.background(Color(.systemGroupedBackground))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showSignInView: .constant(false))
    }
}
