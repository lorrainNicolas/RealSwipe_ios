//
//  TabSelectionViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/02/2023.
//

import Foundation
import SwiftUI

protocol TabSelectionViewModelGetting: ObservableObject {
  associatedtype TabItem: Tabbable
  func getSelectedTabItem() -> TabItem
}

class TabSelectionViewModel<TabItem: Tabbable>: TabSelectionViewModelGetting {
  @Binding private var selectedTabItem: TabItem
  
  init(selectedTabItem: Binding<TabItem>) {
    _selectedTabItem = selectedTabItem
  }
  
  func getSelectedTabItem() -> TabItem {
    return selectedTabItem
  }
  
  func updateSelectedTabItem(_ tabItem: TabItem) {
    selectedTabItem = tabItem
  }
}
