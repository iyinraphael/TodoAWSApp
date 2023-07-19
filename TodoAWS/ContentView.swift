//
//  ContentView.swift
//  TodoAWS
//
//  Created by Raphael Iyin on 7/18/23.
//

import SwiftUI
import Amplify

struct ContentView: View {
    @State var name: String
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(name)
                .task {
                    await performDelete()
                }
        }
        .padding()
    }
    
    func performOnAppear() async {
        do {
            let todos = try await Amplify.DataStore.query(Todo.self, where: Todo.keys.priority.eq(Priority.high))
            for todo in todos {
                print("===Todo===")
                print("Name: `\(todo.name)")
                self.name = todo.name

                if let description = todo.description {
                    print("Description: \(description)")
                }
                if let priority = todo.priority {
                    print("Priority: \(priority)")
                }
            }
        } catch {
            print("Could not save item to DataStore: \(error)")
        }
    }
    
    func performUpdate() async {
        do {
            let todos = try await Amplify.DataStore.query(Todo.self, where: Todo.keys.name.eq("Finish quarterly taxes"))
            guard todos.count == 1, var updatedTodo = todos.first else {
                print("Did not find exactly one Todo, bailing")
                return
            }
            updatedTodo.name = "File quarterly taxes"
            let savedTodo = try await Amplify.DataStore.save(updatedTodo)
            print("Delete item: \(savedTodo.name)")
        } catch {
            print("Unable to perform operation: \(error)")
        }
    }
    
    
    func performDelete() async {
        do {
            let todos = try await Amplify.DataStore.query(Todo.self, where: Todo.keys.name.eq("File quarterly taxes"))
            guard todos.count == 1, var toDeleteTodo = todos.first else {
                print("Did not find exactly one Todo, bailing")
                return
            }
            try await Amplify.DataStore.delete(toDeleteTodo)
            print("Updated item: \(toDeleteTodo.name)")
        } catch {
            print("Unable to perform operation: \(error)")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(name: "hello view")
    }
}
