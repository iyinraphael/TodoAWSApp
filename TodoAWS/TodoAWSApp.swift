//
//  TodoAWSApp.swift
//  TodoAWS
//
//  Created by Raphael Iyin on 7/18/23.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin

@main
struct TodoAWSApp: App {
    
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(name: "hello")
        }
    }
    

    func configureAmplify() {
        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            Amplify.Logging.logLevel = .info
            try Amplify.configure()
            print("Initialized Amplify")
        } catch {
            print("could not initialize Amplify: \(error)")
        }
    }
    
}
