//
//  LogginFlowScreen.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import SwiftUI

struct LogginFlowScreen: View {
  
  @StateObject var logginFlow: LogginFlow
  @State var color: Color = .red
  var body: some View {
    ZStack(alignment: .top) {
      NavigationStack(path: $logginFlow.navigationPath) {
        
        LogginScreen(viewModel: LogginViewModel())
          .environmentObject(logginFlow)
          .navigationDestination(for: LogginFlow.Screen.self) { screen in
            
            switch screen {
            case .passwordLogging(let vm):
              PasswordStepScreen(viewModel: vm)
                .environmentObject(logginFlow)
                .id(vm.id)
                .modifier(BackNavigationViewModifier())
              
            case .passwordRegister(let vm):
              PasswordStepScreen(viewModel: vm)
                .environmentObject(logginFlow)
                .id(vm.id)
                .modifier(BackNavigationViewModifier())
              
            case .name(let vm):
              NameStepScreen(viewModel: vm)
                .environmentObject(logginFlow)
                .id(vm.id)
                .modifier(BackNavigationViewModifier())
              
            case .gender(let vm):
              GenderStepScreen(viewModel: vm)
                .environmentObject(logginFlow)
                .id(vm.id)
                .modifier(BackNavigationViewModifier())
            }
          }
      }.navigationBarBackButtonHidden(true)
       .environmentObject(logginFlow)
      
      ZStack {
        if let progression = logginFlow.navigationPath.last?.percent {
          ProgressView(value: progression, total: 1)
            .animation(.linear, value: progression)
            .frame(width: 200)
            .padding(.top, 40)
            .transition(.opacity)
        }
      }.animation(.linear, value: logginFlow.navigationPath.last?.percent == nil)
    }.onChange(of: logginFlow.navigationPath) { oldValue, newValue in
  
    }.modifier(LoadingViewModifier(isLoading: logginFlow.isLoading, title: "Logging"))
  }
}


protocol LogginProgressionProtcol {
  var percent: CGFloat? { get }
}

struct BackNavigationViewModifier: ViewModifier {
  @Environment(\.dismiss) private var dismiss
  
  func body(content: Content) -> some View {
    content
      .navigationBarBackButtonHidden(true)
      .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "arrow.backward")
        }
      }
    }
  }
}
