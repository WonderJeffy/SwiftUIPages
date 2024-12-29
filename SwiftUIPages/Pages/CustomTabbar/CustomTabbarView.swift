///
//  @filename   CustomTabbarView.swift
//  @package
//
//  @author     jeffy
//  @date       2024/1/24
//  @abstract
//
//  Copyright © 2024 and Confidential to jeffy All rights reserved.
//

import SwiftUI

struct CustomTabBar: View {
    var activeForeground: Color = .white
    var activeBackground: Color = .blue
    @Binding var activeTab: TabModel
    /// MatchedGeometry Effect
    @Namespace private var animation
    /// View Properties
    @State private var tabLocation: CGRect = .zero
    var body: some View {
        let status = activeTab == .home || activeTab == .search

        HStack(spacing: !status ? 0 : 22) {
            HStack(spacing: 0) {
                ForEach(TabModel.allCases, id: \.rawValue) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: tab.rawValue)
                                .font(.title3)
                                .frame(width: 30, height: 30)

                            if activeTab == tab {
                                Text(tab.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundStyle(
                            activeTab == tab ? activeForeground : .gray
                        )
                        .padding(.vertical, 2)
                        .padding(.leading, 10)
                        .padding(.trailing, 15)
                        .contentShape(.rect)
                        .background {
                            if activeTab == tab {
                                Capsule()
                                    //                                .fill(.clear)
                                    .fill(activeBackground.gradient)
                                    //                                .onGeometryChange(for: CGRect.self, of: {
                                    //                                    $0.frame(in: .named("TABBARVIEW"))
                                    //                                }, action: { newValue in
                                    //                                    tabLocation = newValue
                                    //                                })
                                    .matchedGeometryEffect(
                                        id: "ACTIVETAB",
                                        in: animation
                                    )
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(alignment: .leading) {
                Capsule()
                    .fill(activeBackground.gradient)
                    .frame(width: tabLocation.width, height: tabLocation.height)
                    .offset(x: tabLocation.minX)

            }
            .coordinateSpace(.named("TABBARVIEW"))
            .padding(.horizontal, 5)
            .frame(height: 45)
            .background(
                .background
                    .shadow(
                        .drop(
                            color: .black.opacity(0.08),
                            radius: 5,
                            x: 5,
                            y: 5
                        )
                    )
                    .shadow(
                        .drop(
                            color: .black.opacity(0.06),
                            radius: 5,
                            x: -5,
                            y: -5
                        )
                    ),
                in: .capsule
            )
            .zIndex(10)

            Button {
                if activeTab == .home {
                    print("Home")
                } else {
                    print("Search")
                }
            } label: {

                MorphingSymbolView(
                    symbol: activeTab == .home ? "plus" : "mic.fill",
                    config: .init(
                        font: .title3,
                        frame: .init(width: 42, height: 42),
                        radius: 2,
                        foregroudColor: activeForeground,
                        keyFrameDuration: 0.3,
                        symbolAnimation: .smooth(duration: 0.3, extraBounce: 0)
                    )
                )
                .background(activeBackground.gradient)
                .clipShape(.circle)
            }
            .allowsHitTesting(status)
            .offset(x: status ? 0 : -20)
            .padding(.leading, status ? 0 : -42)
        }
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
    }
}

struct CustomTabbarView: View {
    /// View Properties
    @State private var activeTab: TabModel = .home
    @State private var isTabBarHidden: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                TabView(selection: $activeTab) {
                    Tab.init(value: .home) {
                        HomeView()
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }

                    Tab.init(value: .search) {
                        Text("Search")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }

                    Tab.init(value: .notifications) {
                        Text("Notification")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }

                    Tab.init(value: .profile) {
                        Text("profile")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            }
            CustomTabBar(activeTab: $activeTab)
        }
        .enableInjection()
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    ForEach(1...50, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.background)
                            .frame(height: 50)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Floating TabBar")
            .background(.primary.opacity(0.07))
            .safeAreaPadding(.bottom, 60)
        }
    }
}

struct HideTabBar: UIViewRepresentable {
    var result: () -> Void
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear

        DispatchQueue.main.async {
            if let tabController = view.tabController {
                tabController.tabBar.isHidden = true
                result()
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}

extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence(
            first: self,
            next: {
                $0.next
            }
        ).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }

        return nil
    }
}
