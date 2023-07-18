//
//  ContentView.swift
//  TodoAWS
//
//  Created by Raphael Iyin on 7/18/23.
//

import SwiftUI
import Amplify

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .task {
                    await performOnAppear()
                }
        }
        .padding()
    }
    
    func performOnAppear() async {
        do {
            let item = Todo(name: "Finish quarterly taxes",
                            priority: .high,
                            description: "Taxes are due for the quarter next week")
            let saveItem = try await Amplify.DataStore.save(item)
            print("Saved item: \(saveItem.name)")
        } catch {
            print("Could not save item to DataStore: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
