//
//  GradientButton.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 10/10/2024.
//

import SwiftUI

struct GradientButton: View {
    var title: String
    var icon: String
    var onClick: () -> ()
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15) {
                Text(title)
                Image(systemName: icon)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(.linearGradient(colors: [.appPink, .orange, .red], startPoint: .top, endPoint: .bottom), in: .capsule)
        })
    }
}

#Preview {
    ContentView()
}
