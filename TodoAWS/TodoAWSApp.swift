//
//  TodoAWSApp.swift
//  TodoAWS
//
//  Created by Raphael Iyin on 7/18/23.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin

@main
struct TodoAWSApp: App {
    
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    

    func configureAmplify() {
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: dataStorePlugin)
            Amplify.Logging.logLevel = .info
            try Amplify.configure()
            print("Initialized Amplify")
        } catch {
            print("could not initialize Amplify: \(error)")
        }
    }
    
}
