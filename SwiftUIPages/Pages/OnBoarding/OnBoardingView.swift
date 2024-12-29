///
//  @filename   OnBoardingView.swift
//  @package
//
//  @author     jeffy
//  @date       2023/12/22
//  @abstract
//
//  Copyright © 2023 and Confidential to jeffy All rights reserved.
//

import SwiftUI
import ConcentricOnboarding

struct OnBoardingView: View {
    @State private var currentIndex: Int = 0
        
        var body: some View {
            ConcentricOnboardingView(pageContents: [(PageView(), .blue), (PageView(), .purple)])
                .duration(1.0)
                .nextIcon("chevron.forward")
                .animationDidEnd {
                    print("Animation Did End")
                }
        }
}

#Preview {
    OnBoardingView()
}

struct PageView: View {
    
    let imageWidth: CGFloat = 150
    let textWidth: CGFloat = 350
    
    var body: some View {

        return VStack(alignment: .center, spacing: 50) {
            Text("page.title")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .frame(width: textWidth)
                .multilineTextAlignment(.center)

            VStack(alignment: .center, spacing: 5) {
                Text("page.header")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .frame(width: 300, alignment: .center)
                    .multilineTextAlignment(.center)
                Text("page.content")
                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                    .frame(width: 300, alignment: .center)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
