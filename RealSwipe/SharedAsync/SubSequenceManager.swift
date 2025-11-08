//
//  SubSequenceManager.swift
//  RealSwipe
//
//  Created by Utilisateur on 01/06/2025.
//

import Foundation

actor SubSequenceManager<Base: AsyncSequence & Sendable> where Base.Element: Sendable {
  
  private var base: Base
  private var continuations: [UUID : AsyncThrowingStream<Base.Element, Error>.Continuation] = [:]
  private var subscriptionTask: Task<Void, Never>?
  
  init(_ base: Base) {
    self.base = base
    
    
    Task { [weak self, base] in
      guard let self = self else { return }
      
      do {
        for try await value in base {
          await self.continuations.values.forEach { $0.yield(value) }
        }
        
        await self.continuations.values.forEach { $0.finish() }
      } catch {
        await self.continuations.values.forEach { $0.finish(throwing: error) }
      }
    }
  }
  
  deinit {
    self.continuations.values.forEach { $0.finish() }
  }
  
  struct Data<Value: Sendable>: Sendable {
    let asyncStream: AsyncThrowingStream<Value, Error>
    let cancellable: AsyncStreamCancellable
  }
  
  func makeAsyncData() -> Data<Base.Element> {
    let id = UUID()
    
    let sequence = AsyncThrowingStream<Base.Element, Error>.init { continutation in
      self.add(id: id, continuation: continutation)
      continutation.onTermination = { @Sendable _ in self.remove(id) }
    }
    
    let cancellable = Cancellable { @Sendable in self.remove(id) }
    return Data(asyncStream: sequence, cancellable: cancellable)
  }
  
  nonisolated private func remove(_ id: UUID) {
    Task {
      await self._remove(id)
    }
  }
  
  private func _remove(_ id: UUID) {
    self.continuations.removeValue(forKey: id)
  }
  
  private func add(id: UUID, continuation: AsyncThrowingStream<Base.Element, Error>.Continuation) {
    self.continuations[id] = continuation
  }
}

extension SubSequenceManager {
  
  final class Cancellable: AsyncStreamCancellable {
    
    private let onCancel: (@Sendable () -> Void)
    
    init(onCancel: @escaping @Sendable() -> Void) {
      self.onCancel = onCancel
    }
    
    func cancel() {
      onCancel()
    }
    
    deinit {
      onCancel()
    }
  }
}
