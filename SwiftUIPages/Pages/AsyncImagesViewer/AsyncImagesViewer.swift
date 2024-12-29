////
////  AsyncImagesViewer.swift
////  DemoPages
////
////  Created by Jeffy on 2024/12/28.
////
//
//import SwiftUI
//
//struct AsyncImagesViewerExampleView: View {
//
//    struct ImageModel: Identifiable {
//        var id: String = UUID().uuidString
//        var altText: String
//        // going to use Live URL via AsyncImage foe this effect
//        var link: String
//    }
//
//    let sampleImages: [ImageModel] = [
//        .init(
//            altText: "Mo Eid",
//            link:
//                "https://w0.peakpx.com/wallpaper/944/975/HD-wallpaper-building-city-new-york-skyscraper-sunset-usa-travel.jpg"
//        ),
//        .init(
//            altText: "Codioful",
//            link:
//                "https://p4.wallpaperbetter.com/wallpaper/710/382/540/new-york-city-cityscape-united-states-skyline-wallpaper-preview.jpg"
//        ),
//        .init(
//            altText: "Fanny Hagan",
//            link:
//                "https://i.pinimg.com/736x/01/b3/8d/01b38d4f2730bc20d3744057d9f30f51.jpg"
//        ),
//        .init(
//            altText: "Mo Eid",
//            link:
//                "https://avatars.mds.yandex.net/i?id=97a3e2c73f8f71646917f5f2f51ff644_l-7045468-images-thumbs&n=13"
//        ),
//        .init(
//            altText: "Codioful",
//            link:
//                "https://i.pinimg.com/736x/19/e9/03/19e90312a1b6cb8103ac8a1f47b75056.jpg"
//        ),
//        .init(altText: "Fanny Hagan", link: "https://www.google.com"),
//        .init(
//            altText: "Mo Eid",
//            link:
//                "https://i.pinimg.com/550x/8e/f3/b3/8ef3b3df1c2df6588a0eb73d352fea13.jpg"
//        ),
//        .init(
//            altText: "Codioful",
//            link:
//                "https://ae01.alicdn.com/kf/HTB15ZShKpXXXXcdXVXXq6xXFXXXm/2-5-W-x4-5-H-m-Crowded-Busy-City-Street-Background-Hot-Selling-Freedom-Photography.jpg"
//        ),
//    ]
//    var body: some View {
//        NavigationStack {
//            VStack {
//                AsyncImagesViewerExampleView {
//                    ForEach(sampleImages) { image in
//                        AsyncImage(url: URL(string: image.link)) { image in
//                            image
//                                .resizable()
//                        } placeholder: {
//                            Rectangle()
//                                .fill(.gray.opacity(0.25))
//                                .overlay {
//                                    ProgressView()
//                                        .tint(.primary.opacity(0.6))
//                                        .scaleEffect(0.7)
//                                        .frame(
//                                            maxWidth: .infinity,
//                                            maxHeight: .infinity
//                                        )
//                                }
//                        }
//                        .containerValue(\.activeViewID, image.id)
//                    }
//                } overlay: {
//                    OverlayView()
//                }
//            }
//            .padding(15)
//            .navigationTitle("Image Viewer")
//        }
//    }
//}
//
//struct OverlayView: View {
//    @Environment(\.dismiss) private var dismiss
//    var body: some View {
//        VStack {
//            Button {
//                dismiss()
//            } label: {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.title)
//                    .foregroundStyle(.ultraThinMaterial)
//                    .padding(10)
//                    .contentShape(.rect)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//
//            Spacer(minLength: 0)
//        }
//        .padding(15)
//    }
//}
//
//struct AsyncImagesViewer<Content: View, Overlay: View>: View {
//    var config = Config()
//    @ViewBuilder var content: Content
//    @ViewBuilder var overlay: Overlay
//    /// Giving updates to the main view
//    var updates: (Bool, AnyHashable?) -> Void = { _, _ in }
//    /// View Properties
//    @State private var isPresented: Bool = false
//    @State private var activeTabID: Subview.ID?
//    @State private var transitionSource: Int = 0
//    @Namespace private var animation
//
//    var body: some View {
//        Group(subviews: content) { collection in
//            LazyVGrid(
//                columns: Array(
//                    repeating: GridItem(spacing: config.spacing),
//                    count: 2
//                ),
//                spacing: config.spacing
//            ) {
//                /// Only displaying the first four images, and the remaining ones showing a count (like + 4) at the fourth image, similar to the X (twitter) app
//                let remainingCount = max(collection.count - 4, 0)
//                ForEach(collection.prefix(4)) { item in
//                    let index = collection.index(item.id)
//                    GeometryReader {
//                        let size = $0.size
//
//                        item
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: size.width, height: size.height)
//                            .clipShape(.rect(cornerRadius: config.cornerRadius))
//
//                        // && remainingCount > 0
//                        if collection.prefix(4).last?.id == item.id {
//                            RoundedRectangle(cornerRadius: config.cornerRadius)
//                                .fill(.black.opacity(0.33))
//                                .overlay {
//                                    Text("+\(remainingCount)")
//                                        .font(.largeTitle)
//                                        .fontWeight(.semibold)
//                                        .foregroundStyle(.white)
//                                }
//                        }
//                    }
//                    .frame(height: config.height)
//                    .onTapGesture {
//                        /// For opening the selected image in the detail tab view
//                        activeTabID = item.id
//                        /// For opening navigation detail view
//                        isPresented = true
//                        /// For Zoom Transition
//                        transitionSource = index
//                    }
//                    .matchedTransitionSource(id: index, in: animation) {
//                        config in
//                        config
//                            .clipShape(
//                                .rect(cornerRadius: self.config.cornerRadius)
//                            )
//                    }
//
//                }
//            }
//            .navigationDestination(isPresented: $isPresented) {
//                TabView(selection: $activeTabID) {
//                    ForEach(collection) { item in
//                        item
//                            .aspectRatio(contentMode: .fit)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .tag(item.id)
//                    }
//                }
//                .tabViewStyle(.page)
//                .background {
//                    Rectangle()
//                        .fill(.black)
//                        .ignoresSafeArea()
//                }
//                .overlay {
//                    overlay
//                }
//                .navigationTransition(
//                    .zoom(sourceID: transitionSource, in: animation)
//                )
//                .toolbarVisibility(.hidden, for: .navigationBar)
//
//            }
//            /// Updating transitionSource when tab item get's changed
//            .onChange(of: activeTabID) { oldValue, newValue in
//                /// Consider this example: ehn the tab view at detail view is at index 6 or 7 and when it dismisses, the zoom transition won't have any effect because there's no matchedTransitionSource for that index. therefore, indexes greater than 3 will always have a transition ID of 3
//                transitionSource = min(collection.index(newValue), 3)
//                sendUpdate(collection, id: newValue)
//            }
//            .onChange(of: isPresented) { oldValue, newValue in
//                sendUpdate(collection, id: activeTabID)
//            }
//        }
//    }
//
//    private func sendUpdate(_ collection: SubviewsCollection, id: Subview.ID?) {
//        if let viewID = collection.first(where: { $0.id == id })?
//            .containerValues.activeViewID
//        {
//            updates(isPresented, viewID)
//        }
//    }
//
//    struct Config {
//        var height: CGFloat = 150
//        var cornerRadius: CGFloat = 15
//        var spacing: CGFloat = 10
//    }
//}
//
///// To retrieve the current active ID, we can utilize container values to pass the ID to the view and then extract it from the subview
//extension ContainerValues {
//    @Entry var activeViewID: AnyHashable?
//}
//
//extension SubviewsCollection {
//    func index(_ id: SubviewsCollection.Element.ID?) -> Int {
//        firstIndex(where: { $0.id == id }) ?? 0
//    }
//}
