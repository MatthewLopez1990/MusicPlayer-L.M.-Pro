import Foundation
import SwiftUI
import UniformTypeIdentifiers

// MARK: - Library Manager
class LibraryManager {
    static let shared = LibraryManager()
    
    // We strictly use security scoped resources for external files
    func startAccessing(url: URL) -> Bool {
        return url.startAccessingSecurityScopedResource()
    }
    
    func stopAccessing(url: URL) {
        url.stopAccessingSecurityScopedResource()
    }
    
    // Scan a folder for audio files
    func scanFolder(at url: URL) -> [URL] {
        guard url.startAccessingSecurityScopedResource() else {
            print("[LibraryManager] Failed to access security scoped resource: \(url)")
            return []
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        var audioFiles: [URL] = []
        let fileManager = FileManager.default
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]
        
        // Allowed extensions
        let allowedExtensions = ["mp3", "m4a", "wav", "flac"]
        
        if let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: nil, options: options) {
            for case let fileURL as URL in enumerator {
                if allowedExtensions.contains(fileURL.pathExtension.lowercased()) {
                    audioFiles.append(fileURL)
                }
            }
        }
        
        return audioFiles
    }
}
