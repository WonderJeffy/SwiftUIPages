///
//  @filename   BaloonAnimationView.swift
//  @package
//
//  @author     jeffy
//  @date       2024/1/30
//  @abstract
//
//  Copyright © 2024 and Confidential to jeffy All rights reserved.
//

import SwiftUI

struct BaloonAnimationView: View {

    @State private var index = 0

    var body: some View {
        ZStack {
            BaloonView(index: index)
            BaloonView(index: index + 1)
            BaloonView(index: index + 2)
            BaloonView(index: index + 3)
            BaloonView(index: index + 4)
            BaloonView(index: index + 5)
        }
    }
    
    struct BaloonView: View {
        
        @State var index: Int
        @State private var yOffset: CGFloat = UIScreen.main.bounds.height
        @State private var scale: CGFloat = 1.0
        @State private var opacity: Double = 1.0
        private var balloonColors: [Color] = [.blue, .red, .yellow, .green, .orange, .pink]
    
        init(index: Int) {
            self.index = index%balloonColors.count
        }
        
        var body: some View {
            Rectangle()
                .frame(width: 200 * scale, height: 100 * scale)
                .foregroundColor(balloonColors[index])
                .offset(x: (CGFloat(index%3)-1.0)/6.0 * UIScreen.main.bounds.width, y: yOffset)
                .opacity(opacity)
                .onAppear {
                    doAnimation(Double(index)*1.0)
                }
                .onChange(of: index) { _, _ in
                    doAnimation()
                }
        }
        
        fileprivate func doAnimation(_ delay: TimeInterval = 0.0) {
            withAnimation(Animation.linear(duration: 6).delay(delay)) {
                yOffset = 50
                scale = 0.5
                opacity = 0.1
            } completion: {
                yOffset = UIScreen.main.bounds.height
                scale = 1.0
                opacity = 1.0
                index = (index+1)%balloonColors.count
            }
        }
    }

}

#Preview {
    BaloonAnimationView()
}
