import Foundation
import SwiftUI
import AVFoundation
import Combine

// MARK: - Player View Model
@MainActor
class PlayerViewModel: ObservableObject {
    private let audioEngine = AudioEngineManager.shared
    
    @Published var currentSong: Song?
    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var duration: TimeInterval = 0.0
    @Published var visualizerTheme: VisualizerTheme = .synthwave
    
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var showStatus: Bool = false
    @Published var statusMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    var audioAnalyzer: AudioAnalyzer {
        audioEngine.audioAnalyzer
    }
    
    // Synthesizer State
    @Published var pitch: Float = 0.0 // 0 = normal
    @Published var speed: Float = 1.0 // 1.0 = normal
    @Published var reverb: Float = 0.0 // 0 = dry
    @Published var bass: Float = 0.0
    @Published var mid: Float = 0.0
    @Published var treble: Float = 0.0
    
    init() {
        audioEngine.$currentTime
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentTime)
        
        audioEngine.$duration
            .receive(on: DispatchQueue.main)
            .assign(to: &$duration)
            
        audioEngine.$isPlaying
            .receive(on: DispatchQueue.main)
            .assign(to: &$isPlaying)
    }
    
    func play(song: Song) {
        currentSong = song
        
        let _ = song.fileURL.startAccessingSecurityScopedResource()
        
        if let randomTheme = VisualizerTheme.allCases.randomElement() {
            visualizerTheme = randomTheme
        }
        
        audioEngine.play(url: song.fileURL)
    }
    
    func togglePlayPause() {
        if isPlaying {
            audioEngine.pause()
            isPlaying = false
        } else {
            audioEngine.resume()
            isPlaying = true
        }
    }
    
    func seek(to time: TimeInterval) {
        audioEngine.seek(to: time)
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - Effects
    func updatePitch(_ value: Float) {
        pitch = value
        audioEngine.setPitch(value)
    }
    
    func updateSpeed(_ value: Float) {
        speed = value
        audioEngine.setSpeed(value)
    }
    
    func updateReverb(_ value: Float) {
        reverb = value
        audioEngine.setReverb(value)
    }
    
    func updateEQ(bass: Float, mid: Float, treble: Float) {
        self.bass = bass
        self.mid = mid
        self.treble = treble
        
        // Map 3-band controls to 20-band equalizer
        // Bass: Bands 0-6 (31Hz - 187Hz)
        for i in 0...6 {
            audioEngine.setEQ(band: i, gain: bass)
        }
        
        // Mid: Bands 7-13 (250Hz - 2kHz)
        for i in 7...13 {
            audioEngine.setEQ(band: i, gain: mid)
        }
        
        // Treble: Bands 14-19 (3kHz - 16kHz)
        for i in 14...19 {
            audioEngine.setEQ(band: i, gain: treble)
        }
    }
    
    func cycleVisualizerTheme() {
        let allThemes = VisualizerTheme.allCases
        if let currentIndex = allThemes.firstIndex(of: visualizerTheme) {
            let nextIndex = (currentIndex + 1) % allThemes.count
            visualizerTheme = allThemes[nextIndex]
        }
    }
}
