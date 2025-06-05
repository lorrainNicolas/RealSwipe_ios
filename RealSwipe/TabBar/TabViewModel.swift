//
//  TabViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/02/2023.
//

import Foundation
import SwiftUI

class TabViewModel<TabItem: Tabbable> {
  var selectionViewModel: TabSelectionViewModel<TabItem>
  
  init(selectedTabItem: Binding<TabItem>) {
    selectionViewModel = TabSelectionViewModel<TabItem>(selectedTabItem: selectedTabItem)
  }
}
