import Foundation

struct EqualizerPreset: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let gains: [Float]
    
    static let flat = EqualizerPreset(
        name: "Flat",
        gains: Array(repeating: 0.0, count: 20)
    )
    
    static let rock = EqualizerPreset(
        name: "Rock",
        gains: [4, 3, 2, 1, -1, -2, -1, 1, 3, 5, 3.5, 2.5, 1.5, 0, -1.5, -1.5, 0, 2, 4, 5.5]
    )
    
    static let pop = EqualizerPreset(
        name: "Pop",
        gains: [-1, -1, 0, 2, 4, 5, 4, 2, 0, -1, -1, 0, 1, 3, 4.5, 3.5, 1, 0, -0.5, -1]
    )
    
    static let jazz = EqualizerPreset(
        name: "Jazz",
        gains: [3, 2, 1, 2, -1, -2, -2, 0, 2, 3, 2.5, 1.5, 1.5, 0, -1.5, -2, -1, 1, 2.5, 3.5]
    )
    
    static let classical = EqualizerPreset(
        name: "Classical",
        gains: [4, 3, 2, 1, 0, 0, -1, -1, 0, 2, 3.5, 2.5, 1.5, 0.5, -0.5, -0.5, -1, -0.5, 1, 2.5]
    )
    
    static let electronic = EqualizerPreset(
        name: "Electronic",
        gains: [5, 4, 3, 2, 1, 0, -1, -2, 0, 4, 4.5, 3.5, 2.5, 1.5, 0.5, -0.5, -1.5, -1, 2, 5]
    )
    
    static let hiphop = EqualizerPreset(
        name: "Hip-Hop",
        gains: [6, 5, 4, 3, 2, 0, -1, -2, -1, 2, 5.5, 4.5, 3.5, 2.5, 1, -0.5, -1.5, -1.5, 0, 3]
    )
    
    static let vocal = EqualizerPreset(
        name: "Vocal",
        gains: [-2, -2, -1, 0, 1, 3, 4, 4, 3, 1, -2, -1.5, -0.5, 0.5, 2, 3.5, 4, 3.5, 2, 0.5]
    )
    
    static let bass = EqualizerPreset(
        name: "Bass Boost",
        gains: [8, 7, 6, 5, 4, 2, 0, -1, -2, -2, 7.5, 6.5, 5.5, 3.5, 3, 1, -0.5, -1.5, -2, -2]
    )
    
    static let treble = EqualizerPreset(
        name: "Treble Boost",
        gains: [-2, -2, -1, 0, 1, 2, 3, 5, 7, 8, -2, -1.5, -0.5, 0.5, 1.5, 2.5, 4, 6, 7.5, 8]
    )
    
    static let allPresets: [EqualizerPreset] = [
        .flat, .rock, .pop, .jazz, .classical, 
        .electronic, .hiphop, .vocal, .bass, .treble
    ]
}
