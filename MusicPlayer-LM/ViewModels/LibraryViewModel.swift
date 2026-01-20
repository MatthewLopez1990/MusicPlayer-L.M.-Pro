import Foundation
import SwiftUI
import SwiftData
import Combine

// MARK: - Library View Model
@MainActor
class LibraryViewModel: ObservableObject {
    @Published var songs: [Song] = []
    
    // In a real app, we would inject the ModelContext here
    // For now, we simulate the logic
    
    func importFiles(from urls: [URL], modelContext: ModelContext) {
        for url in urls {
            do {
                // Ensure we have access to the file to create the bookmark
                let accessing = url.startAccessingSecurityScopedResource()
                defer {
                    if accessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                
                // Create security-scoped bookmark for persistence
                // On iOS, we don't specify securityScopeAllowOnlyReadAccess. 
                // Creating a bookmark from a security-scoped URL (while accessing it) preserves the scope.
                let bookmarkData = try url.bookmarkData(options: .minimalBookmark,
                                                      includingResourceValuesForKeys: nil,
                                                      relativeTo: nil)
                
                let song = Song(title: url.deletingPathExtension().lastPathComponent,
                                artist: "Unknown Artist",
                                fileURL: url,
                                duration: 0,
                                bookmarkData: bookmarkData)
                
                modelContext.insert(song)
                print("Imported \(song.title) with secure bookmark.")
                
            } catch {
                print("Error importing file \(url.lastPathComponent): \(error)")
            }
        }
    }
}
