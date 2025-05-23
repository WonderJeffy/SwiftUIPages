
//
//  NeumorphicSegmentedControl.swift
//  EasyViews
//
//   (\(\\
//  ( -.-)
//  o_(\")(\")
//  -----------------------
//  Created by GitHub Copilot on 2025/5/22.
//

import SwiftUI

// MARK: - Data Model for Segment Item
struct SegmentItem: Identifiable, Equatable {
    let id = UUID()
    let iconName: String
    // Add a title if needed: let title: String
}

// MARK: - Neumorphic Segmented Control View
struct NeumorphicSegmentedControl: View {
    let items: [SegmentItem]
    @Binding var selectedIndex: Int

    // MARK: - Neumorphic Colors (Light Mode)
    let mainBgColor = Color(hex: "E0E5EC")
    let darkShadowColor = Color(hex: "A3B1C6")
    let lightShadowColor = Color.white
    let iconFgColor = Color(hex: "7E92A6") // Icon color for unselected/default state
    let selectedIconFgColor = Color.orange // Slightly darker/prominent for selected

    // Shadow and item configuration
    let cornerRadius: CGFloat = 12
    let segmentPadding: CGFloat = 6
    let iconSize: CGFloat = 20

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                SegmentView(
                    iconName: items[index].iconName,
                    isSelected: self.selectedIndex == index,
                    mainBgColor: mainBgColor,
                    darkShadowColor: darkShadowColor,
                    lightShadowColor: lightShadowColor,
                    iconFgColor: self.selectedIndex == index ? selectedIconFgColor : iconFgColor,
                    iconSize: iconSize,
                    cornerRadius: cornerRadius,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.selectedIndex = index
                        }
                    }
                )
                .padding(.horizontal, segmentPadding / 2) // Spacing between segments
            }
        }
        .padding(segmentPadding) // Padding for the outer container
        .background(mainBgColor) // Background of the control itself
        .cornerRadius(cornerRadius + segmentPadding / 2) // Overall corner radius for the control
        // Optional: Add a subtle shadow to the whole control if needed
         .shadow(color: darkShadowColor.opacity(0.3), radius: 3, x: -2, y: -2)
         .shadow(color: lightShadowColor.opacity(0.7), radius: 3, x: 2, y: 2)
    }
}

// MARK: - Individual Segment View (Helper)
fileprivate struct SegmentView: View {
    let iconName: String
    let isSelected: Bool

    let mainBgColor: Color
    let darkShadowColor: Color
    let lightShadowColor: Color
    let iconFgColor: Color
    let iconSize: CGFloat
    let cornerRadius: CGFloat
    let action: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(mainBgColor)
                .frame(height: 44) // Fixed height for segments
                .shadow(
                    color: lightShadowColor.opacity(0.9),
                    radius: 3,
                    x: -2,
                    y: -2
                )
                .shadow(
                    color: darkShadowColor.opacity(0.5),
                    radius: 3,
                    x: 2,
                    y: 2
                )

            Image(systemName: iconName)
                .font(.system(size: iconSize, weight: isSelected ? .semibold : .regular))
                .foregroundColor(iconFgColor)
        }
        .onTapGesture(perform: action)
    }
}

// MARK: - Color Hex Initializer Extension (Copied from SwiftUIView.swift for standalone use)
// Consider placing this in a shared location if used across multiple files in the module.
extension Color {
    init(hex: String, allowTransparent: Bool = false) { // Added allowTransparent for flexibility
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit) e.g., "FFF"
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit) e.g., "FFFFFF"
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit) e.g., "FFFFFFFF"
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            if allowTransparent {
                 (a, r, g, b) = (0, 0, 0, 0) // Default to transparent black if format is wrong and allowed
            } else {
                 (a, r, g, b) = (255, 0, 0, 0) // Default to opaque black
            }
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


// MARK: - Preview for NeumorphicSegmentedControl
struct NeumorphicSegmentedControl_Previews: PreviewProvider {
    // Sample items for the preview
    static let sampleItems = [
        SegmentItem(iconName: "square.grid.2x2.fill"),
        SegmentItem(iconName: "list.bullet"),
        SegmentItem(iconName: "bookmark.fill")
    ]

    // State for the preview
    @State static var selectedIndex: Int = 1

    static var previews: some View {
        ZStack {
            // Background for the preview canvas
            Color(hex: "E0E5EC").edgesIgnoringSafeArea(.all)

            NeumorphicSegmentedControl(
                items: sampleItems,
                selectedIndex: $selectedIndex
            )
            .padding() // Add some padding around the control in the preview
        }
    }
}

