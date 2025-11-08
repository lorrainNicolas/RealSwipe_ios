//
//  TabView.swift
//  RealSwipe
//
//  Created by Utilisateur on 24/02/2023.
//

import Foundation
import SwiftUI

struct TabView<TabItem: Tabbable, Content: View>: View {
  let content: Content
  private let viewModel: TabViewModel<TabItem>
  private var didChangeCallback: (() -> Void)?
  
  @State var items: [TabItem] = []
  
  init(selectedTabItem: Binding<TabItem>,
       @ViewBuilder content: () -> Content) {
    self.content = content()
    self.viewModel = TabViewModel<TabItem>(selectedTabItem: selectedTabItem)
  }
  
  var body: some View {
    
    ZStack() {
      Colors
        .background
        .ignoresSafeArea()
      
      ZStack(alignment: .bottom) {
          content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .environmentObject(viewModel.selectionViewModel)
        
  
        TabBarView(tabs: items)
          .environmentObject(viewModel.selectionViewModel)
          .frame(maxWidth: .infinity)
      }

    }.onPreferenceChange(TabItemPreferenceKey<TabItem>.self) {
      items = $0
    }
  }
  
  func didChange(callback: @escaping () -> Void) -> Self {
    var _self = self
    _self.didChangeCallback = callback
    return _self
  }
}
