//
//  DataCRUDView.swift
//
//
//  Created by jeffy on 2024/1/8.
//

import SwiftData
import SwiftUI

/// Create + Read + Update + Delete
struct DataCRUDView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var path = NavigationPath()
    @State private var sortOrder = [SortDescriptor(\Objective.name)]
    @State private var searchText = ""

    var body: some View {
        NavigationStack(path: $path) {
            ObjectiveView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("Objective")
                .navigationDestination(for: Objective.self) { obj in
                    ObjectiveDetailView(objec: obj, navigationPath: $path)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)")
                                .tag([SortDescriptor(\Objective.name)])

                            Text("Name (Z-A)")
                                .tag([SortDescriptor(\Objective.name, order: .reverse)])
                        }
                    }

                    Button("Add Person", systemImage: "plus", action: addObjective)
                }
                .searchable(text: $searchText)
        }
    }

    private func addObjective() {
        let newItem = Objective(timestamp: Date(), name: "default")
        modelContext.insert(newItem)
    }
}

struct ItemDetailView: View {
    @Bindable var item: Objective
    var body: some View {
        Form {
            TextField("Name", text: $item.name)
        }
        .navigationTitle("Edit Item")
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return DataCRUDView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

@MainActor
struct Previewer {
    let container: ModelContainer
    let item: Objective

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Objective.self, configurations: config)
        item = Objective(timestamp: Date(), name: "previewer")
        container.mainContext.insert(item)
    }
}
