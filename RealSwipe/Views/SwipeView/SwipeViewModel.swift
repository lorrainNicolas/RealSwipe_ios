//
//  SwipeViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/08/2023.
//

import Foundation

@MainActor
final class SwipeViewModel: ObservableObject {
  @Published var cards: [CardViewModel] = [ CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
                                            CardViewModel(),
  ]
  
}
