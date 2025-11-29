//
//  MatchDetailView.swift
//  RealSwipe
//
//  Created by Utilisateur on 20/11/2025.
//


import SwiftUI

struct MatchDetailView: View {
  
  @Environment(\.dismiss) private var dismiss
  @StateObject var viewModel: MatchDetailViewModel = MatchDetailViewModel()
  
  var body: some View {
    VStack {
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark")
      }.buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()

      ProfileView(viewModel: viewModel.profileViewModel) {
        EmptyView()
      }.background(.black)
    }
  }
}
