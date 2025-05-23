///
//  @filename   ObjectiveView.swift
//  @package
//
//  @author     jeffy
//  @date       2024/1/14
//  @abstract
//
//  Copyright © 2024 and Confidential to jeffy All rights reserved.
//

import SwiftData
import SwiftUI

struct ObjectiveView: View {
    @Environment(\.modelContext) var modelContext
    @Query var objs: [Objective]

    @State private var selected: Objective?
    @State private var path = NavigationPath()

    var body: some View {
        List {
            ForEach(objs) { objective in
                //                Section {
                //                    NavigationLink(value: objective) {
                if !objective.isDeleted {

                    CardView(name: objective.name)
                        .onTapGesture {
                            selected = objective
                        }
                        .transition(.scale)
                        .animation(.default, value: objective.isDeleted)
                }
                //                    }
                //                }
            }
            .navigationDestination(isPresented: .constant(selected != nil && selected?.isDeleted == false)) {
                if let selected = selected {
                    ObjectiveDetailView(objec: selected, navigationPath: $path)
                        .onDisappear {
                            self.selected = nil
                        }
                }
            }

            Button("delete first Objective") {
                guard !objs.isEmpty else { return }
                withAnimation {
                    objs.first!.isDeleted = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    modelContext.delete(objs.first!)
                }
            }
        }

        .listSectionSpacing(.compact)
        .listStyle(.grouped)
        .scrollContentBackground(.hidden)
        .onAppear {
            print(modelContext.sqliteCommand)
        }
    }

    init(searchString: String = "", sortOrder: [SortDescriptor<Objective>] = []) {
        _objs = Query(
            filter: #Predicate { objective in
                if searchString.isEmpty {
                    true
                }
                else {
                    objective.name.localizedStandardContains(searchString)
                }
            },
            sort: sortOrder
        )
    }

    func deleteObjective(at offsets: IndexSet) {
        for offset in offsets {
            let item = objs[offset]
            modelContext.delete(item)
        }
    }
}

struct CardView: View {
    let name: String

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 319, height: 105)
                .background(Color(red: 0.16, green: 0.38, blue: 0.33))
                .cornerRadius(25)
            HStack(spacing: 0) {

                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 59, height: 57)
                    .background(Color(red: 0.24, green: 0.84, blue: 0.60))
                    .cornerRadius(12)
                Text("📚" + name)
                    .font(Font.custom("SFProDisplay", size: 14).weight(.bold))
                    .foregroundColor(Color(red: 0.24, green: 0.84, blue: 0.60))
                ZStack {

                }
                .frame(width: 36, height: 36)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 31, height: 31)
                    .background(
                        AsyncImage(url: URL(string: "https://via.placeholder.com/31x31"))
                    )
                Text("Booked for 8 PM ")
                    .font(Font.custom("SFProDisplay", size: 14))
                    .foregroundColor(Color(red: 0.24, green: 0.84, blue: 0.60).opacity(0.50))
            }
        }
    }
}
