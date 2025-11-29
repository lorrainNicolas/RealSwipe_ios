//
//  LogginView.swift
//  RealSwipe
//
//  Created by Utilisateur on 27/02/2023.
//

import Foundation
import SwiftUI

@MainActor
protocol LogginViewModelProtocol: ObservableObject {
  var errorMessage: String? { get }
  var isLoading: Bool { get set }
  var showFailureAlert: Bool { get set }
  
  func canDismisskeyboard(_ email: String) -> Bool
  func didValid(_ email: String)
}

struct LogginView<ViewModel: LogginViewModelProtocol>: View {
  
  @ObservedObject var viewModel: ViewModel

  var body: some View {
  
      ZStack(alignment: .center) {
        Colors
          .background
          .ignoresSafeArea()

        VStack(spacing: 40) {
          
          ZStack {
            Text("BIENVENUE")
              .font(.custom("Poppins Bold", size: 60))
              .foregroundStyle(Colors.text)
            
            LinearGradient(colors: [Color.clear,
                                    Color.black.opacity(0.7)],
                           startPoint: UnitPoint(x: 0.5, y: 0.3),
                           endPoint: .bottom)
          }.fixedSize()
        
          
          Text("Inscris toi gratuitement ou connecte-toi")
            .multilineTextAlignment(.center)
            .font(.system(size: 20)).frame(width: 250)
            .foregroundStyle(Colors.text)
          
          CustomTextField("Enter Your Email...", isLoading: $viewModel.isLoading)
            .onTapButton {
              viewModel.didValid($0)
              return viewModel.canDismisskeyboard($0)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
          Text(viewModel.errorMessage ?? " ")
            .foregroundColor(.red)
        }
      }
      .alert("Something wrong happened", isPresented: $viewModel.showFailureAlert) {
          Button("OK", role: .cancel) { }
      }
  }
}

