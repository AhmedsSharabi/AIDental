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
                        NavigationLink {
                            HistoryView()
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
                            AboutView()
                        } label: {
                            Label("About", systemImage: "info.circle")
                        }
                        NavigationLink {
                            HelpView()
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
                                    
                                    if let urlString = viewModel.user?.photoUrl ?? viewModel.user?.profileImagePathUrl, let url = URL(string: urlString) {
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
                            .fontWeight(.semibold)
                            .padding(.bottom, 15)
                        
                        Text("Number of Scans")
                            .font(.system(size: 14))
                    Text("\(viewModel.user?.prediction?.count ?? 0)")
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                            .padding(.bottom, 15)
                        
                        Text("Number of Appointments")
                            .font(.system(size: 14))
                        Text("\(viewModel.user?.appointment?.count ?? 0)")
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                    
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

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                VStack(spacing: 10) {
                    Image("4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    
                    Text("About Dental AI")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.app)
                }
                
                // App Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Our Mission")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("""
Dental AI is dedicated to providing accurate and detailed insights about oral health using advanced AI technology. Our app helps users understand their dental conditions and offers personalized recommendations for better oral care.
""")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Team Information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Meet the Team")
                        .font(.headline)
                        .foregroundColor(.primary)
                    VStack(alignment: .leading, spacing: 5) {
                        Link("Najwa Said", destination: URL(string: "https://www.linkedin.com/in/najwasaid5102/")!)
                        Link("Ahmed Sharabi", destination: URL(string: "https://www.linkedin.com/in/ahmedalsharabi/")!)
                        Link("Fathin Najihah Atikah", destination: URL(string: "https://www.linkedin.com/in/fathnjh/")!)
                    }.hSpacing(.leading)
                        .font(.body)
                        .foregroundColor(.app)
                }.hSpacing(.leading)
                
                Divider()
                
                // Links Section
                VStack(alignment: .leading, spacing: 15) {
                    Link("Privacy Policy", destination: URL(string: "https://www.instagram.com/505.njwx/?hl=en")!)
                        .font(.body)
                        .foregroundColor(.blue)
                    
                    Link("Terms of Service", destination: URL(string: "https://www.instagram.com/505.njwx/?hl=en")!)
                        .font(.body)
                        .foregroundColor(.blue)
                    
                    Link("Contact Support", destination: URL(string: "https://www.instagram.com/505.njwx/?hl=en")!)
                        .font(.body)
                        .foregroundColor(.blue)
                }
                .hSpacing(.leading)
                Spacer()
            }
            .hSpacing(.leading)
            .padding(16)
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                VStack(spacing: 10) {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.app)
                    
                    Text("Help & Support")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.app)
                }
                
                // FAQ Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Frequently Asked Questions")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // FAQ Items
                    FAQItem(question: "How do I scan my teeth?", answer: "To scan your teeth, open the app and follow the guided instructions in the Scan tab.")
                    FAQItem(question: "What does the AI analysis mean?", answer: "The AI analysis provides insights about potential dental conditions and recommendations for oral health improvement.")
                    FAQItem(question: "Is my data secure?", answer: "Yes, all your data is encrypted and stored securely in compliance with privacy regulations.")
                }
                
                // Troubleshooting Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Troubleshooting")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("""
- If the app is not responding, try restarting it.
- Ensure your camera permissions are enabled for scanning.
- Check your internet connection for syncing data.
""")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                // Contact Support Section
                VStack(alignment: .leading,spacing: 15) {
                    Text("Need More Help?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Link("Email Support", destination: URL(string: "mailto:najwaoffice5102@gmail.com")!)
                        .font(.body)
                        .foregroundColor(.blue)
                    
                    Link("Visit Help Center", destination: URL(string: "https://www.instagram.com/505.njwx/?hl=en")!)
                        .font(.body)
                        .foregroundColor(.blue)
                }
                .hSpacing(.leading)

                Spacer()
            }
            .hSpacing(.leading)
            .padding(16)
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// FAQ Item View
struct FAQItem: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(question)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(answer)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
