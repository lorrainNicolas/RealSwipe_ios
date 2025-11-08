//
//  TabItemViewModifier.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/02/2023.
//

import Foundation
import SwiftUI

struct TabItemViewModifier<TabSelectionViewModelGetter: TabSelectionViewModelGetting,
                           TabItem: Tabbable>: ViewModifier where TabSelectionViewModelGetter.TabItem == TabItem {
  
  @EnvironmentObject var tabSelectionViewModel: TabSelectionViewModelGetter
  let tabItem: TabItem
  
  func body(content: Content) -> some View {
    ZStack {
      TabItemContainerView {
        content.frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea()
      }.isHidden(tabItem == tabSelectionViewModel.getSelectedTabItem() ? false : true)
        .preference(key: TabItemPreferenceKey.self, value:[tabItem])
    }
     .allowsHitTesting(tabItem == tabSelectionViewModel.getSelectedTabItem() ? true : false)
  }
}

