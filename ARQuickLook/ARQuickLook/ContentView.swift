//
//  ContentView.swift
//  ARQuickLook
//
//  Created by 박건우 on 7/13/24.
//

import SwiftUI
import QuickLook

struct ContentView : View {
    @State
    var selectedModelName: String?
    
    let modelNames = ["Teapot", "Gramophone", "Pig"]

    var body: some View {
        List {
            ForEach(self.modelNames, id: \.self) { modelName in
                Button(action: {
                    self.selectedModelName = modelName
                }) {
                    HStack {
                        Image(modelName.lowercased())
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        Text(modelName)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .quickLookPreview(
            Binding(
                get: {
                    guard let selectedModelName = self.selectedModelName else {
                        return nil
                    }
                    return Bundle.main.url(
                        forResource: selectedModelName,
                        withExtension: "usdz"
                    )
                },
                set: { _ in }
            )
        )
    }
}

#Preview {
    ContentView()
}
