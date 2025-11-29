//
//  PickerPhotoButton.swift
//  RealSwipe
//
//  Created by Utilisateur on 24/11/2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct PhotoPickerButton: View {
  
  @State private var showPicker = false
  @State private var selectedItem: PhotosPickerItem?
  @Binding private var selectedImage: UIImage?
  var onChangeImage: (UIImage?, UIImage) -> Void = { _, _ in }
  
  init(selectedImage: Binding<UIImage?>, onChangeImage: @escaping (UIImage?, UIImage) -> Void) {
    self._selectedImage = selectedImage
    self.onChangeImage = onChangeImage
  }
  
  var body: some View {
    Button.init {
      showPicker = true
    } label: {
      ZStack {
        Color.green.frame(maxWidth: .infinity, maxHeight: .infinity)
        
        if let selectedImage {
          Image(uiImage: selectedImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
        } else {
          Image(systemName: "camera.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 30, height: 30)
            .foregroundStyle(.white)
        }
      }
    }
    .photosPicker(
      isPresented: $showPicker,
      selection: $selectedItem,
      matching: .images
    )
    .frame(width: 90, height: 90)
    .clipShape(Circle())
    .onChange(of: selectedItem) { _, newItem in
      Task {
        if let data = try? await newItem?.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
          selectedImage = uiImage
        }
      }
    }.onChange(of: selectedImage) { oldValue, newValue in
      guard let newValue else { return }
      onChangeImage(oldValue, newValue)
    }
  }
}
