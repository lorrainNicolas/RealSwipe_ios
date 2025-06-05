//
//  CustomTextField.swift
//  RealSwipe
//
//  Created by Utilisateur on 27/02/2023.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
  
  enum Constants {
    static let height: CGFloat = 50
    static var CircleRadius: CGFloat { height }
    static let textFieldLeading: CGFloat = 20
    static let textFieldTrailing: CGFloat = 80
  }
  
  private var onTapButtonCallback: ((String) -> Bool)?
  
  @Binding private var isLoading: Bool
  @State private var text: String = ""
  private let titleKey: String
  private let isSecured: Bool
  
  init(_ titleKey: String, isSecured: Bool = false, isLoading: Binding<Bool>? = nil) {
    self._isLoading = isLoading ?? Binding.constant(false)
    self.titleKey = titleKey
    self.isSecured = isSecured
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.white)
        .addBorder(Color.black, width: 0.1, cornerRadius: Constants.CircleRadius)
      ZStack {
        Circle()
          .foregroundColor(Color(Colors.selectedTool))
          .frame(width: Constants.CircleRadius, height: Constants.CircleRadius)
          .onTapGesture {
            if onTapButtonCallback?(text) ?? true {
              UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
          }
        
        if isLoading {
          ProgressView()
        } else {
          Text(">")
            .font(.custom("Poppins Bold", size: 30))
            .foregroundColor(.white)
        }
      }.padding()
        .frame(maxWidth: .infinity,alignment: .trailing)
      Group {
        if isSecured {
          SecureField("", text: $text, prompt: Text(titleKey).foregroundColor(.gray))
            .foregroundStyle(.black)
          
        } else {
          TextField("", text: $text, prompt: Text(titleKey).foregroundColor(.gray))
            .foregroundStyle(.black)
            
        }
      }.padding(.leading, Constants.textFieldLeading)
       .padding(.trailing, Constants.textFieldTrailing)
       .disabled(isLoading)
    }.frame(height: Constants.height)
  }
  
   func onTapButton(_ callback: @escaping (String) -> Bool) -> Self {
     var _self = self
     _self.onTapButtonCallback = callback
     return _self
  }
}
 
