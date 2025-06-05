//
//  TabItemContainerView.swift
//  RealSwipe
//
//  Created by Utilisateur on 27/05/2025.
//

import SwiftUI

struct TabItemContainerView<V: View>: UIViewControllerRepresentable {

  private var isHidden: Bool = false
  private let content: V

  init(@ViewBuilder content: () -> V ) {
    self.content = content()
  }

  func isHidden(_ value: Bool) -> Self {
    var _self = self
    _self.isHidden = value
    return _self
  }

  func makeUIViewController(context: Context) -> UIHostingController<V> {
    let vc = UIHostingController(rootView: content)
    vc.view.isHidden = isHidden
    vc.view.backgroundColor = .clear
    return vc
  }

  func updateUIViewController(_ viewController: UIHostingController<V>,
                              context: Context) {
    viewController.view.isHidden = isHidden
  }
}
