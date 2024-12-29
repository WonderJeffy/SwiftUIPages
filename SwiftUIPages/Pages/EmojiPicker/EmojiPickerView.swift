///
//  @filename   EmojiPickerView.swift
//  @package
//
//  @author     jeffy
//  @date       2024/1/31
//  @abstract
//
//  Copyright © 2024 and Confidential to jeffy All rights reserved.
//

import SwiftUI
import MCEmojiPicker

struct EmojiPickerView: View {
    
    @State private var isPresented = false
    @State private var selectedEmoji = "🐶"
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button(selectedEmoji) {
                isPresented.toggle()
            }.emojiPicker(
                isPresented: $isPresented,
                selectedEmoji: $selectedEmoji
            )
        }
    }
}

#Preview {
    EmojiPickerView()
}
