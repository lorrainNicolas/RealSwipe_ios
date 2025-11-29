//
//  SettingsAboutMeView.swift
//  RealSwipe
//
//  Created by Utilisateur on 29/11/2025.
//

import SwiftUI

struct SettingsAboutMeView: View {
  
  let information: [SettingsAboutMeViewModel]
  
  var body: some View {
    SectionView(title: "About Me") {
      VStack(spacing: 12) {
        ForEach(information) { value in
          VStack {
            HStack {
              Text(value.info.key)
                .foregroundStyle(Colors.textInBox)
                .font(.custom("Poppins Bold", size: 12))
              Spacer()
              Text(value.info.value)
                .foregroundColor(.gray)
            }
            
//            if value.info != information.last {
//              Divider()
//            }
          }
        }
      }
    }
  }
}

