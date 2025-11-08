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
  
  // When a @Sendable async closure is marked with the @_inheritActorContext attribute,
  // the closure will inherit the actor context (i.e. which actor it should run on) based on its declaration location.
  // Closures that do not have a specific requirement to run on a particular actor can run anywhere (i.e. on any thread).
  
  func sink(@_inheritActorContext _ closure: sending @escaping @isolated(any) (Base.Element) async -> (),
            @_inheritActorContext _ finishClosure: sending @escaping @isolated(any) (Error?) async -> () = {_ in } ) async -> AsyncStreamCancellable {
    let asyncIterator = await self.manager.makeAsyncData()

    Task {
      var iterator = asyncIterator.asyncStream.makeAsyncIterator()
      do {
        while let element = try await iterator.next() {
          await closure(element)
        }
        
        await finishClosure(nil)
      } catch {
        await finishClosure(error)
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
