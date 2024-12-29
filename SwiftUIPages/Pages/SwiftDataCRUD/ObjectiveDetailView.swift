///
//  @filename   ObjectiveDetailView.swift
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

struct ObjectiveDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var objec: Objective
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text(objec.name)
            ForEach(objec.keyResults) { keyResult in
                Text(keyResult.name)
            }
        }
        .navigationTitle("ObjectiveDetail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// #Preview {
//    ObjectiveDetailView()
// }
