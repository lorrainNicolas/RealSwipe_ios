//
//  ProfilView.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/02/2023.
//

import Foundation
import SwiftUI

struct ProfilView: View {
  @StateObject var viewModel: ProfilViewModel
  @Environment(\.disconnectAction) var disconnectAction
  
  var body: some View {
    ScrollView {

      VStack(spacing: 6) {
        HeaderView(name: viewModel.name)
        DescriptionView()
        AboutMeView(information: [.age(30),
                                  .sexe("Homme"),
                                  .sexualOrientation("Hétéro")])
        ControlView()
        ButtonView(title: "Log Out") {
          disconnectAction()
        }
      }
    }.padding()
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
        Text("HEY \(name) 🤙")
          .foregroundStyle(Colors.text)
          .font(.custom("Poppins Bold", size: 24))
          .frame(maxWidth: .infinity, alignment: .leading)
      }.frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

private struct DescriptionView: View {
  @State private var description: String = ""
  
  private let maxCharacters = 100
  
  var body: some View {
    SectionView(title: "Description") {
      VStack(spacing: 0) {
        TextField("Enter your name", text: $description, axis: .vertical)
          .multilineTextAlignment(.leading)
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
    case sexualOrientation(String)
    
    var key: String {
      switch self {
      case .age: return "Age"
      case .sexe: return "Sexe"
      case .sexualOrientation: return "Orientation Sexuelle"
      }
    }
    
    var value: String {
      switch self {
      case .age(let value): return "\(value)"
      case .sexe(let value): return value
      case .sexualOrientation(let value): return value
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
  @State var showAge: Bool = false
  @State var showDistance: Bool = false
  
  var body: some View {
    SectionView(title: "Contrôle"){
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
        Spacer()
        Toggle("", isOn: isOn)
      }
    }
  }
}

private struct SectionView<Content: View>: View {
 
  private let title: String
  private let content: Content
  
  init(title: String,
       @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }
  
  var body: some View {
    VStack {
      Text(title)
        .font(.custom("Poppins Bold", size: 18))
        .frame(maxWidth: .infinity, alignment: .leading)
      content
        .padding()
        .background(.white)
        .cornerRadius(12)
    }
  }
}
