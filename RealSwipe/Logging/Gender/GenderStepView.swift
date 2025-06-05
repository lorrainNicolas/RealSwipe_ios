//
//  GenderStepView.swift
//  RealSwipe
//
//  Created by Utilisateur on 12/03/2023.
//

import Foundation
import SwiftUI

struct GenderStepView: View {
  
  @ObservedObject var viewModel: GenderStepViewModel
  
  var body: some View {
    StepView(title: "Quelle identité te décrit le mieux") {
      VStack(alignment: .leading, spacing: 20) {
        ButtonView(title: "Femme") {
          viewModel.didSelectWoman()
        }
          
        ButtonView(title: "Homme") {
          viewModel.didSelectMan()
        }
      }
    }
     .alert("Something wrong happened", isPresented: $viewModel.showFailureAlert) {
        Button("OK", role: .cancel) { }
    }
  }
}
