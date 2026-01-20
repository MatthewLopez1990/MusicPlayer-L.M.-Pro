import Foundation
import SwiftData

// MARK: - Song Model
@Model
final class Song: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var artist: String
    var fileURL: URL
    var bookmarkData: Data?
    var duration: TimeInterval
    var dateAdded: Date
    
    init(title: String, artist: String, fileURL: URL, duration: TimeInterval, bookmarkData: Data? = nil) {
        self.id = UUID()
        self.title = title
        self.artist = artist
        self.fileURL = fileURL
        self.duration = duration
        self.bookmarkData = bookmarkData
        self.dateAdded = Date()
    }
}
