//
//  TabItemPreferenceKey.swift
//  RealSwipe
//
//  Created by Utilisateur on 25/02/2023.
//

import Foundation
import SwiftUI

struct TabItemPreferenceKey<TabItem: Tabbable>: PreferenceKey {
  static var defaultValue: [TabItem] { [] }
    
    static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]){
        value.append(contentsOf: nextValue())
    }
}

extension View {
    func tabItem<TabItem: Tabbable>(for tabItem: TabItem) -> some View {
      return self.modifier(TabItemViewModifier<TabSelectionViewModel<TabItem>, TabItem>(tabItem: tabItem))
    }
}
