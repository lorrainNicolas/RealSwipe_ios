//
//  CardContainerView.swift
//  RealSwipe
//
//  Created by Utilisateur on 05/02/2023.
//

import SwiftUI
import Combine

struct CardViewIsDraggingHorizontallyKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

extension EnvironmentValues {
  var cardViewIsDraggingHorizontally: Bool {
    get { self[CardViewIsDraggingHorizontallyKey.self] }
    set { self[CardViewIsDraggingHorizontallyKey.self] = newValue }
  }
}

struct CardViewPercentDraggingKey: EnvironmentKey {
  static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
  var cardViewPercentDragging: CGFloat {
    get { self[CardViewPercentDraggingKey.self] }
    set { self[CardViewPercentDraggingKey.self] = newValue }
  }
}


class CardViewActionHandler: ObservableObject {
  enum Action {
    case like
    case dislike
  }
  
  let action = PassthroughSubject<Action, Never>()
}

struct CardViewModifier: ViewModifier {
  private let cardRotLimit: CGFloat = 25.0
  private let minHorizontalTranslation: CGFloat = 100
  
  let parentGeometryProxy: GeometryProxy
  let didDrop: () -> Void
  
  enum DraggingAction {
    case draggingHorizontally
    case draggingVertically
  }
  
  private var onPercentXTranslationAction: ((CGFloat) -> ())?
  @State private var translation: CGPoint = .zero
  @State private var onFinishAnimation: Bool = false
  @State private var draggingAction: DraggingAction?
  @StateObject private var cardViewActionHandler = CardViewActionHandler()
  
  var percentXTranslation: CGFloat {
    let width = parentGeometryProxy.size.width
    guard width != 0 else { return 0 }
    return max(-1, min((translation.x / width), 1))
  }
  
  init(parentGeometryProxy: GeometryProxy, didDrop: @escaping () -> Void) {
    self.parentGeometryProxy = parentGeometryProxy
    self.didDrop = didDrop
  }
  
  func body(content: Content) -> some View  {
    
    DraggableCardView<Content>(content: { content }) {
      
      switch $0 {
      case .began:
        break
      case .changed(let value):
        guard onFinishAnimation == false, draggingAction != .draggingVertically else { return }
        
        if draggingAction == nil, abs(value.x) > abs(value.y) {
          draggingAction = .draggingHorizontally
        } else if draggingAction == nil {
          draggingAction = .draggingVertically
          return
        }
        
        translation = value
      case .ended(let value):
        guard onFinishAnimation == false else { return }
        let isHorizontal = (draggingAction == .draggingHorizontally)
        draggingAction = nil
        guard isHorizontal else { return }
        onFinishAnimation = true
        
        if value.x > -minHorizontalTranslation && value.x < minHorizontalTranslation {
          resetCard()
        } else if value.x >= minHorizontalTranslation {
          likeCard()
        } else if value.x <= minHorizontalTranslation {
          dislikeCard()
        }
      }
    }.environment(\.cardViewIsDraggingHorizontally, draggingAction == .draggingHorizontally)
     .environment(\.cardViewPercentDragging, percentXTranslation)
     .environmentObject(cardViewActionHandler)
     .offset(x: translation.x, y: translation.y)
     .rotationEffect(.degrees(Double(translation.x / parentGeometryProxy.size.width * cardRotLimit)), anchor: .bottom)
     .onReceive(cardViewActionHandler.action) {
       switch $0 {
       case .like: likeCard()
       case .dislike: dislikeCard()
       }
      
     }.onChange(of: translation) { _, value in
       onPercentXTranslationAction?(percentXTranslation)
     }
  }
  
  func onPercentXTranslationAction(_ action: @escaping (CGFloat) -> ()) -> Self {
    var _self = self
    _self.onPercentXTranslationAction = action
    return _self
  }
  
  private func resetCard() {
    withAnimation(.spring(duration: 0.3, bounce: 0.4), completionCriteria: .logicallyComplete) {
      translation = .zero
    } completion: {
      onFinishAnimation = false
    }
  }
  
  private func likeCard() {
    withAnimation(.linear(duration: 0.2), completionCriteria: .removed) {
      translation.x = parentGeometryProxy.size.width
    } completion: {
      onFinishAnimation = false
      didDrop()
    }
  }
  
  private func dislikeCard() {
    withAnimation(.linear(duration: 0.2), completionCriteria: .removed) {
      translation.x = -parentGeometryProxy.size.width
    } completion: {
      onFinishAnimation = false
      didDrop()
    }
  }
}

protocol CardViewModelProtocol: Identifiable { }

struct CardContainerView<CardView: View, ViewModel: CardViewModelProtocol>: View {
  
  @State var percentTranslationOnXFirstView: CGFloat = .zero
  @Binding var cards: [ViewModel]
  let builderCardView: (ViewModel) -> CardView
  let maxItem: Int = 2
  
  var body: some View {
    
    GeometryReader { geometryProxy in
      ZStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
        ForEach(Array(cards.prefix(maxItem)).enumerated().map { $0 }, id: \.element.id) { value in
          builderCardView(value.element)
            .modifier(cardViewModifier(geometryProxy: geometryProxy, value: value))
            .zIndex(Double(maxItem - value.offset))
            .disabled(value.offset != 0)
            .compositingGroup()
            .opacity(value.offset == 0 ? 1 : opacity())
            .scaleEffect(value.offset == 0 ? 1 : scaleEffect())
            .animation(.linear(duration: 0.15), value: percentTranslationOnXFirstView)
        }
      }
    }
  }
  
  func opacity() -> CGFloat {
    (0.7 + (0.3 * min(abs(percentTranslationOnXFirstView) * 2, 1)))
  }
  
  func scaleEffect() -> CGFloat {
    (0.95 + (0.05 * min(abs(percentTranslationOnXFirstView) * 2, 1)))
  }
  
  private func cardViewModifier(geometryProxy: GeometryProxy, value: (offset: Int, element: ViewModel)) -> CardViewModifier {
    CardViewModifier(parentGeometryProxy: geometryProxy,
                     didDrop: {
      cards.removeAll(where: { value.element.id == $0.id })
      percentTranslationOnXFirstView = .zero
    })
    .onPercentXTranslationAction {
      guard value.offset == 0 else { return }
      percentTranslationOnXFirstView = $0
    }
  }
}

struct DraggableCardView<Content: View>: UIViewControllerRepresentable {
  private let content: Content
  
  enum Status {
    case began
    case changed(CGPoint)
    case ended(CGPoint)
  }
  
  private let closure: (Status) -> Void
  
  init(@ViewBuilder content: () -> Content, closure: @escaping (Status) -> Void) {
    self.content = content()
    self.closure = closure
  }
  
  func makeUIViewController(context: Context) -> DraggableCardViewController<Content> {
    return DraggableCardViewController(content: content, closure: {
      switch $0 {
      case .began: closure(.began)
      case .changed(let value): closure(.changed(value))
      case .ended(let value): closure(.ended(value))
      }
    })
  }
  
  func updateUIViewController(_ uiView: DraggableCardViewController<Content> , context: Context) {}
}

// we need use because DragGesture don't work anymore when you have two finger
class DraggableCardViewController<Content: View>: UIHostingController<Content>, UIGestureRecognizerDelegate {
  
  enum Status {
    case began
    case changed(CGPoint)
    case ended(CGPoint)
  }
  
  private let closure: (Status) -> Void
  init(content: Content, closure:  @escaping (Status) -> Void) {
    self.closure = closure
    super.init(rootView: content)
    view.backgroundColor = .clear
    setupGesture()
  }
  
  @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    panGesture.delegate = self
    view.addGestureRecognizer(panGesture)
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      closure(.began)
    case .changed:
      let translation = gesture.translation(in: view.superview)
      closure(.changed(translation))
    case .ended, .cancelled:
      let translation = gesture.translation(in: view.superview)
      closure(.ended(translation))
    default:
      break
    }
  }
}
