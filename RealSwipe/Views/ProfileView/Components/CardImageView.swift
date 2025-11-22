//
//  ProfileImageView.swift
//  RealSwipe
//
//  Created by Utilisateur on 03/11/2025.
//

import SwiftUI

struct ProfileImageView: View {
  let size: CGSize
  let image: Image?
  let text: String
  
  var body: some View {
    ZStack(alignment: .bottom) {
      ZStack {
        if let image {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } else {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        }
      }.frame(width: size.width, height:size.height)
        .onTapGesture { print("click") }
      
      ZStack {
        LinearGradient(colors: [Color.clear,
                                Color.black.opacity(0.8)],
                       startPoint: .top,
                       endPoint: .bottom)
        
        Text(text)
          .font(.custom("Poppins Bold", size: 24))
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading)
      }.frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
    }
  }
}

