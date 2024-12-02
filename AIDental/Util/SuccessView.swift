//
//  SuccessView.swift
//  AIDental
//
//  Created by Ahmed Sharabi on 03/12/2024.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        ZStack {
            Image("4")
                .frame(width: 200, height: 300)
                .scaledToFit()
                .offset(y: -400)
            
            VStack {
                Image("cal")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 335.0985107421875, height: 339.1308288574219)
                    .clipped()
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    .rotationEffect(Angle(degrees: 6.13))
                
                Text("Your appointment has been \nconfirmed!")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(width: 440, alignment: .top)
            }
        }
    }
}

#Preview {
    SuccessView()
}
