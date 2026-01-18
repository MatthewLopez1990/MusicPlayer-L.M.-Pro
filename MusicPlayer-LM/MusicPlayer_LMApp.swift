//
//  MusicPlayer_LMApp.swift
//  MusicPlayer-LM
//
//  Created by Matthew Lopez on 1/17/26.
//

import SwiftUI
import SwiftData

@main
struct MusicPlayer_LMApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
