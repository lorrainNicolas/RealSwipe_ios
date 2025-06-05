//
//  ContentView.swift
//  fdede
//
//  Created by Utilisateur on 28/05/2025.
//

import SwiftUI
import Combine

struct SharedAsyncSequence<Base: AsyncSequence & Sendable>: Sendable where Base.Element: Sendable {
  
  private let base: Base
  private let manager: SubSequenceManager<Base>
  
  init(_ base: Base) {
    self.base = base
    self.manager = SubSequenceManager(base)
  }
  
  
  func sink(_ closure: @escaping @Sendable @isolated(any) (Base.Element) -> ()) async -> AsyncStreamCancellable {
    let asyncIterator = await self.manager.makeAsyncData()
    
    Task {
      var iterator = asyncIterator.asyncStream.makeAsyncIterator()
      while let element = try? await iterator.next() {
        await closure(element)
      }
    }
    return asyncIterator.cancellable
  }
}


extension AsyncSequence {
  func shared() -> SharedAsyncSequence<Self> where Self: Sendable {
    .init(self)
  }
}
