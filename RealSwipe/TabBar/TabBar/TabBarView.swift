//
//  TabBarView.swift
//  RealSwipe
//
//  Created by Utilisateur on 30/01/2023.
//

import Foundation
import SwiftUI

private enum Constants {
    static let imageSize: CGSize = CGSize(width: 16, height: 16)
    static let cellSize: CGSize = CGSize(width: 60, height: 40)
    static let imagePaddingWhenSelected: CGFloat = 12
    static let imageYOffsetWhenSelected: CGFloat = 30
    static let customShapeRadius: CGFloat = 40
    static let HStackVerticalPadding: CGFloat = 8
    static let HStackHorizontalPadding: CGFloat = 40
}

struct TabBarView<TabItem: Tabbable>: View {
  let tabs: [TabItem]
  
  @EnvironmentObject var tabSelectionViewModel: TabSelectionViewModel<TabItem>
  @State var xAxis: CGFloat = 0
  
  private enum CoordinateSpaceView: Hashable {
      case HStack
  }
    
  var body: some View {
    ZStack {
      HStack(spacing: 2) {
        ForEach(tabs) { tab in
          GeometryReader() { geometry in
            VStack(alignment: .center, spacing: 4) {
              Image(uiImage: tab.image ?? UIImage())
                  .resizable()
                  .renderingMode(.template)
                  .aspectRatio(contentMode: .fit)
                  .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
                  .foregroundColor(tabSelectionViewModel.getSelectedTabItem() == tab ? Color.white : Color.gray)
                  .padding(tabSelectionViewModel.getSelectedTabItem() == tab ? Constants.imagePaddingWhenSelected : 0)
                  .background(LinearGradients.selectedTool.opacity(tabSelectionViewModel.getSelectedTabItem() == tab ? 1 : 0).clipShape(Circle()))
                  .offset(x: 0, y: tabSelectionViewModel.getSelectedTabItem() == tab ? -Constants.imageYOffsetWhenSelected : 0)
                  .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5),
                             value: tabSelectionViewModel.getSelectedTabItem())
                                    
                  if tabSelectionViewModel.getSelectedTabItem() != tab { Text(tab.title).font(.system(size: 10)).foregroundColor(.gray) }
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
              .onTapGesture {
                 withAnimation(.spring()) {
                   xAxis = geometry.frame(in: .named(CoordinateSpaceView.HStack)).midX
                 }
                tabSelectionViewModel.updateSelectedTabItem(tab)
               }
             .onAppear {
                if tabSelectionViewModel.getSelectedTabItem() == tab {
                  xAxis = geometry.frame(in: .named(CoordinateSpaceView.HStack)).midX
                  
                }
              }
          }.frame(width: Constants.cellSize.width, height: Constants.cellSize.height)
        }
      }.padding(.vertical, Constants.HStackVerticalPadding)
       .padding(.horizontal, Constants.HStackHorizontalPadding)
       .coordinateSpace(name: CoordinateSpaceView.HStack)
       .background(Color.white.opacity(0.2).background(VisualEffectBlur(style: .dark))
       .clipShape(CustomShape(radius: Constants.customShapeRadius, center: xAxis)).cornerRadius(20))
    }.padding(.top, Constants.imageYOffsetWhenSelected)
     .padding(.horizontal)
  }
}

private struct CustomShape: Shape {
  
  let radius: CGFloat
  var center: CGFloat
  
  init(radius: CGFloat, center: CGFloat) {
    self.radius = radius
    self.center = center
  }
 
  var animatableData: CGFloat {
    get { center }
    set { center = newValue }
  }
    
  func path(in rect: CGRect) -> Path {
    return Path { path in
      path.move(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: 0, y: rect.height))
      path.addLine(to: CGPoint(x: rect.width, y: rect.height))
      path.addLine(to: CGPoint(x: rect.width, y: 0))
      path.addLine(to: CGPoint(x: center + radius, y: 0))
            
      let minY = rect.height * 0.5
      let to1 = CGPoint(x: center, y: minY)
      let control1 = CGPoint(x: center + radius / 2, y: 0)
      let control2 = CGPoint(x: center + radius / 2, y: minY)
      let to2 = CGPoint(x: center - radius, y: 0)

      let control3 = CGPoint(x: center - radius / 2, y: minY)
      let control4 = CGPoint(x: center - radius / 2, y: 0)
            
      path.addCurve(to: to1, control1: control1, control2: control2)
      path.addCurve(to: to2, control1: control3, control2: control4)
          
      path.addLine(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: 0, y: rect.height))
    }
  }
}

struct VisualEffectBlur: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
