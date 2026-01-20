import Foundation

enum VisualizerTheme: String, CaseIterable, Identifiable {
    case synthwave = "Synthwave"
    case tieDye = "Tie-Dye"
    case constellation = "Constellation"
    
    var id: String { rawValue }
}
