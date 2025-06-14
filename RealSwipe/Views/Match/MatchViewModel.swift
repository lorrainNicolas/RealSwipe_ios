//
//  MatchViewModel.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/08/2023.
//

import Foundation

@MainActor
final class MatchViewModel: ObservableObject {
  @Published var cards: [CardViewModel] = [ .init(background: .blue),
                                            .init(background: .yellow),
                                            .init(background: .red),
                                            .init(background: .green),
                                            .init(background: .pink),
                                            .init(background: .blue),
                                            .init(background: .yellow),
                                            .init(background: .red),
                                            .init(background: .green),
                                            .init(background: .pink),
                                            .init(background: .blue),
                                            .init(background: .yellow),
                                            .init(background: .red),
                                            .init(background: .green),
                                            .init(background: .pink),
                                            .init(background: .blue),
                                            .init(background: .yellow),
                                            .init(background: .red),
                                            .init(background: .green),
                                            .init(background: .pink),
                                            .init(background: .blue),
                                            .init(background: .yellow),
                                            .init(background: .red),
                                            .init(background: .green),
                                            .init(background: .pink),
                                            .init(background: .green),
                                            .init(background: .pink),
                                            .init(background: .blue),
                                            .init(background: .yellow),
                                            .init(background: .red),
                                            .init(background: .green),
                                            .init(background: .pink),
                                            .init(background: .blue),
                                            .init(background: .yellow),
                                            .init(background: .red),
                                            .init(background: .green),
                                            .init(background: .pink),
                                            .init(background: .mint)]
  
}
