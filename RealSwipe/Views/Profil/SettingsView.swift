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
  
  private var infos: [AboutMeView.Info] {
    var infos = [AboutMeView.Info.sexe("Homme")]
    if let age = viewModel.age { infos.append(.age(age)) }
    return infos
  }
  
  var body: some View {
    ScrollView {

      VStack(spacing: 12) {
        HeaderView(name: viewModel.name)
        
        DescriptionView(description: $viewModel.description)
   
        AboutMeView(information: infos)
        
        ControlView(showAge: $viewModel.showAge,
                    showDistance: $viewModel.showDistance)
        
        ButtonView(title: "Log Out") {
          disconnectAction()
        }
        
      }.padding()
      
      Rectangle().fill(.clear).frame(height: 60)
      
    }
     .onTapGesture {
       UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}

private struct HeaderView: View {
  let name: String
  
  var body: some View {
    HStack {
      Circle()
        .foregroundColor(.green)
        .frame(width: 100)
        .padding()
      
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
  
  private let maxCharacters = 100
  
  var body: some View {
    SectionView(title: "Description") {
      
      VStack(spacing: 0) {
        TextField(text: $description) {
          Text("Une petite description de toi ?")
            .font(.custom("Poppins Bold", size: 12))
            .foregroundStyle(Colors.textPlaceHolder)
        }.multilineTextAlignment(.leading)
          .foregroundStyle(Colors.textInBox)
          .lineLimit(nil)
          
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

private struct AboutMeView: View {
  enum Info: Hashable {
    case age(Int)
    case sexe(String)
    
    var key: String {
      switch self {
      case .age: return "Age"
      case .sexe: return "Sexe"
      }
    }
    
    var value: String {
      switch self {
      case .age(let value): return "\(value)"
      case .sexe(let value): return value
      }
    }
  }
  
  let information: [Info]
  
  var body: some View {
    SectionView(title: "About Me") {
      VStack(spacing: 12) {
        ForEach(information, id: \.self) { info in
          VStack {
            HStack {
              Text(info.key)
                .foregroundStyle(Colors.textInBox)
                .font(.custom("Poppins Bold", size: 12))
              Spacer()
              Text(info.value)
                .foregroundColor(.gray)
            }
            
            if info != information.last {
              Divider()
            }
          }
        }
      }
    }
  }
}

private struct ControlView: View {
  
  @Binding var showAge: Bool
  @Binding var showDistance: Bool
  
  var body: some View {
    SectionView(title: "Contrôle") {
      
      VStack(spacing: 12) {
        buildSection(title: "Masquer mon âge", isOn: $showAge)
        buildSection(title: "Masquer ma distance", isOn: $showDistance)
      }
    }
  }
  
  func buildSection(title: String, isOn: Binding<Bool>) -> some View {
    VStack(spacing: 12) {
      HStack {
        Text(title)
          .font(.custom("Poppins Bold", size: 12))
          .foregroundStyle(Colors.textInBox)
        Spacer()
        Toggle("", isOn: isOn)
      }
    }
  }
}
