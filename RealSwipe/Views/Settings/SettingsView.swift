//
//  SettingsView.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/02/2023.
//

import Foundation
import SwiftUI

struct SettingsView: View {
  
  @StateObject var viewModel: SettingsViewModel
  
  @Environment(\.disconnectAction) var disconnectAction
  @State var logoutConfirmation: Bool = false

  var body: some View {
    ScrollView {
      
      VStack(spacing: 22) {
        HeaderView(name: viewModel.name, viewModel: viewModel)
        
        DescriptionView(description: $viewModel.description)
        
        if !viewModel.infos.isEmpty {
          SettingsAboutMeView(information: viewModel.infos)
        }
        
        ButtonView(title: "Log Out") {
          logoutConfirmation = true
        }
      }.padding()
      
      Rectangle().fill(.clear).frame(height: 60)
      
    }.alert("Êtes-vous sûr de vouloir vous déconnecter ?",
            isPresented: $logoutConfirmation, actions: {
      Button {
        disconnectAction()
      } label: {
        Text("Log Out")
      }
      Button("Cancel", role: .cancel) {
      }
    })
    
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}

private struct HeaderView: View {
  let name: String
  @ObservedObject var viewModel: SettingsViewModel
  
  var body: some View {
    HStack {
      ZStack {
        PhotoPickerButton(
          selectedImage: $viewModel.selectedImage,
          onChangeImage: { oldImage, newImage in
            viewModel.uploadImage(oldImage: oldImage, newImage)
          }).disabled(viewModel.isUploadingImage)
        
        if viewModel.isUploadingImage {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        }
      }
      
      VStack {
        Text("Hello \(name) 🤙")
          .font(.custom("Poppins Bold", size: 24))
          .foregroundStyle(Colors.text)
          .frame(maxWidth: .infinity, alignment: .leading)
      }.frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

private struct DescriptionView: View {
  @Binding var description: String
  
  private let maxCharacters = 300
  
  var body: some View {
    SectionView(title: "Description") {
      
      VStack(spacing: 0) {
        TextEditor(text: $description)
            .font(.custom("Poppins Bold", size: 12))
            .foregroundColor(.black)
            .frame(minHeight: 40, maxHeight: 200)
            .padding(4)
            .background(
                Text(description.isEmpty ? "Une petite description de toi ?" : "")
                    .foregroundColor(Colors.textPlaceHolder)
                    .padding(8),
                alignment: .topLeading
            ) .scrollContentBackground(.hidden)
        
        Text("\(maxCharacters - description.count)")
          .foregroundColor(.gray)
          .padding(.trailing, 10)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }.onChange(of: description) {_,  newValue in
      description = String(newValue.prefix(maxCharacters))
    }
  }
}
