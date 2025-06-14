//
//  BirthdayStepView.swift
//  RealSwipe
//
//  Created by Utilisateur on 12/03/2023.
//

import Foundation
import SwiftUI

struct BirthdayStepView: View {
  @State var date: Date
  
  private var maxDate: Date {
      Calendar.current.date(byAdding: .year, value: -18, to: Date())!
  }
  
  private var minDate: Date {
      Calendar.current.date(byAdding: .year, value: -99, to: Date())!
  }
  
  var buttonIsEnable: Bool {
    Calendar.current.dateComponents([.year], from: date, to: Date()).year.map { $0 >= 18 } ?? false
  }
  
  init(viewModel: BirthdayStepViewModel) {
    self.date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    self.viewModel = viewModel
  }
  
  @ObservedObject var viewModel: BirthdayStepViewModel
  
  var body: some View {
    
    StepView(title: viewModel.title) {
      VStack(alignment: .leading, spacing: 20) {
        DatePicker("", selection: $date,in: minDate ... maxDate, displayedComponents: [.date])
          .datePickerStyle(.wheel)
        
        ButtonView(title: "Next") {
          viewModel.onTapButton(date)
        }.disabled(!buttonIsEnable)
      }
    }
  }
}
