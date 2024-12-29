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

    var body: some View {
        List {
            ForEach(objs) { objective in
                NavigationLink(value: objective) {
                    Text("😓"+objective.name)
                }
            }
            .onDelete(perform: deleteObjective)
        }
    }

    init(searchString: String = "", sortOrder: [SortDescriptor<Objective>] = []) {
        _objs = Query(filter: #Predicate { objective in
            if searchString.isEmpty {
                true
            } else {
                objective.name.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }

    func deleteObjective(at offsets: IndexSet) {
        for offset in offsets {
            let item = objs[offset]
            modelContext.delete(item)
        }
    }
}

