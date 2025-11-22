//
//  ProfileView.swift
//  RealSwipe
//
//  Created by Utilisateur on 20/11/2025.
//


import SwiftUI

struct ProfileView<BottomView: View>: View {
  
  @ObservedObject var viewModel: ProfileViewModel
  @ViewBuilder var bottomView: BottomView
  
  var body: some View {
    GeometryReader { geo in
      ScrollView {
        VStack() {
          ProfileImageView(size: .init(width: geo.size.width, height: geo.size.height * 3 / 4),
                        image: viewModel.image,
                        text: viewModel.name)
          .addBorder(.clear, width: 0, cornerRadius: 14)
          
          ZStack {
            VStack(alignment: .leading, spacing:  15) {
              
              ProfileSectionView(title: "Ma Localisation:") {
                HStack {
                  Image(systemName: "location")
                  Text("Paris")
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
              }
              
              ProfileSectionView(title: "À propose de moi:") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 16) {
                  ProfileLabelView(image: Image(systemName: "music.microphone.circle"), text: "Stand-up")
                  ProfileLabelView(image: Image(systemName: "bicycle"), text: "Velo")
                  ProfileLabelView(image: Image(systemName: "carrot"), text: "Nutrition")
                }
              }

              ProfileSectionView(title: "Description:") {
                Text("Hello, voici une description fun")
                  .frame(maxWidth: .infinity, alignment: .leading)
              }
              
              bottomView
            }.padding(.top, 10)
          }.padding()
        }.addBorder(.clear, width: 0, cornerRadius: 24)
      }.scrollIndicators(.hidden)
    }.background(.regularMaterial)
      .task {
        await viewModel.task()
      }
  }
}
