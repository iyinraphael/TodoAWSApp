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
                    await performOnAppear()
                }
        }
        .padding()
    }
    func performOnAppear() async {
        await subscribeTodos()
    }
    
    func performCreate() async {
        do {
            let todo = Todo(name: "Build iOS Application", description: "Buid an iOS application")
            let savedTodo = try await Amplify.DataStore.save(todo)
            print("Created item: \(savedTodo.name)")
        } catch {
            print("Unable to perform operation: \(error)")
        }
    }
    
    func performQuery() async {
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
    
    func subscribeTodos() async {
        do {
            let mutationEvents = Amplify.DataStore.observe(Todo.self)
            for try await mutationEvent in mutationEvents {
                print("Subscription got this value: \(mutationEvent)")
                do {
                    let todo = try mutationEvent.decodeModel(as: Todo.self)
                    
                    switch mutationEvent.mutationType {
                    case "create":
                        print("Created: \(todo)")
                    case "update":
                        print("Updated: \(todo)")
                    case "delete":
                        print("Deleted: \(todo)")
                    default:
                        break
                    }
                } catch {
                    print("Model could not be decoded: \(error)")
                }
            }
        } catch {
            print("Unable to observe mutation events")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(name: "hello view")
    }
}
