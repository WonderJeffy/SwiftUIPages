//
//  ImageThumbView.swift
//  SwiftUIPages
//
//  (\(\
//  ( -.-)
//  o_(")(")
//  -----------------------
//  Created by jeffy on 9/17/25.
//

import PhotosUI
import SwiftUI
import CoreImage


struct ImageThumbView: View {
    @Environment(\.displayScale) var displayScale
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var uiImage: UIImage?
    @State private var thumbImage: UIImage?
    @State private var showThumb = false
    @State private var jpegQuality: Double = 1.0
    @State private var thumbStyle: String = "jpeg"
    
    // 选图时保存原始 Data
    @State private var originalImageData: Data?
    @State private var thumbBytesString: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "info.circle")
                    .font(.caption)
                    .foregroundColor(.white)
                Text("切换压缩算法, 长按查看缩略图")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            if uiImage != nil {
                VStack {
                    HStack {
                        Text(
                            showThumb
                                ? "缩略图" + thumbBytesString
                                : "原图" + originalBytesString
                        )
                        .font(.caption)
                        .padding(6)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                        .padding(8)
                        Spacer()
                        Button(action: {
                            self.uiImage = nil
                            self.thumbImage = nil
                            self.selectedItem = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5).clipShape(Circle()))
                        }
                        .padding(12)
                    }
                }
            }
            Spacer()
            ZStack {
                if let uiImage {
                    if showThumb == false {
                        Image(uiImage: uiImage)
                            .resizable()
                            .interpolation(.high)
                            //                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .shadow(radius: 4)
                    } else if let thumbImage {
                        Image(uiImage: thumbImage)
                            .resizable()
                            //                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .shadow(radius: 4)
                    } else {
                        Text("没有获取到缩略图")
                    }
                    
                } else {
                    // 打开相册选择图片按钮
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .overlay(Text("请选择图片").foregroundColor(.white))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(contentMode: .fit)
            .onLongPressGesture(
                minimumDuration: 0.3,
                pressing: { isPressing in
                    showThumb = isPressing
                }, perform: {})
            Spacer()
            ImageThumbFuncPicker(
                selectedSegment: $thumbStyle,
                jpegQuality: $jpegQuality
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 56)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .onChange(of: selectedItem) { _, newItem in
            if let newItem {
                Task {
                    // 选图时赋值
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                        let image = UIImage(data: data, scale: displayScale)
                    {
                        if let rawImage = rawDataToUIImageWithCIFilter(data) {
                            uiImage = rawImage
                        } else {
                            uiImage = image
                        }
                        originalImageData = data
                        updateThumbImage()
                    }
                }
            }
        }
        .onChange(of: thumbStyle) { _, newValue in
            updateThumbImage()
        }
    }
    
    func rawDataToUIImageWithCIFilter(_ data: Data) -> UIImage? {
        guard let rawFilter = CIFilter(imageData: data, options: [CIRAWFilterOption.allowDraftMode: false]) else {
            return nil
        }
        let context = CIContext()
        guard let outputImage = rawFilter.outputImage else { return nil }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage, scale: displayScale, orientation: .up)
        }
        return nil
    }
    
    private func updateThumbImage() {
        guard let uiImage else { return }
        var thumbData: Data?
        switch thumbStyle {
        case "heic(17+)":
            thumbData = uiImage.heicData()
        case "jpeg":
            thumbData = uiImage.jpegData(compressionQuality: CGFloat(jpegQuality))
        case "png":
            thumbData = uiImage.pngData()
        default:
            thumbData = nil
        }
        if let thumbData {
            thumbImage = UIImage(data: thumbData, scale: displayScale)
            let bytes = thumbData.count
            if bytes > 1024 * 1024 {
                thumbBytesString = String(format: "%.2fMb", Double(bytes) / (1024 * 1024))
            } else if bytes > 1024 {
                thumbBytesString = String(format: "%.2fKb", Double(bytes) / 1024)
            } else {
                thumbBytesString = "\(bytes)B"
            }
        } else {
            thumbImage = nil
            thumbBytesString = " 0B"
        }
    }
    
    // 计算原图体积
    var originalBytesString: String {
        guard let data = originalImageData else { return "0B" }
        let bytes = data.count
        if bytes > 1024 * 1024 {
            return String(format: "%.2fMb", Double(bytes) / (1024 * 1024))
        } else if bytes > 1024 {
            return String(format: "%.2fKb", Double(bytes) / 1024)
        } else {
            return "\(bytes)B"
        }
    }
    
    struct ImageThumbFuncPicker: View {
        @Binding var selectedSegment: String
        let options = ["heic(17+)", "jpeg", "png"]
        @Binding var jpegQuality: Double
        
        var body: some View {
            VStack {
                Picker("Select an option", selection: $selectedSegment) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedSegment) { newValue, _ in
                    print("Selected segment: \(newValue)")
                }
                if selectedSegment == "jpeg" {
                    HStack {
                        Text("压缩比: \(String(format: "%.2f", jpegQuality))")
                            .foregroundColor(.white)
                            .font(.caption)
                        Slider(value: $jpegQuality, in: 0.01...1.0, step: 0.01)
                            .accentColor(.blue)
                            .frame(maxWidth: 200)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .padding(.vertical, 8)
                }
            }
            .animation(.default, value: selectedSegment)
        }
    }
}

#Preview {
    ImageThumbView()
}
