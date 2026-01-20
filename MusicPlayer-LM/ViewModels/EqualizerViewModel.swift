import Foundation
import SwiftUI
import Combine

@MainActor
class EqualizerViewModel: ObservableObject {
    private let audioEngine = AudioEngineManager.shared
    
    @Published var bandGains: [Float] = Array(repeating: 0.0, count: 20)
    @Published var selectedPreset: EqualizerPreset?
    
    let frequencies: [Float] = [
        31.25, 32, 62.5, 64, 93.75, 125, 187.5, 250, 375, 500,
        750, 1000, 1500, 2000, 3000, 4000, 6000, 8000, 12000, 16000
    ].sorted()
    
    var audioAnalyzer: AudioAnalyzer {
        audioEngine.audioAnalyzer
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        for i in 0..<20 {
            bandGains[i] = audioEngine.getEQGain(band: i)
        }
        
        $bandGains
            .debounce(for: 0.05, scheduler: DispatchQueue.main)
            .sink { [weak self] gains in
                self?.updateAudioEngine(gains: gains)
            }
            .store(in: &cancellables)
    }
    
    func applyPreset(_ preset: EqualizerPreset) {
        selectedPreset = preset
        bandGains = preset.gains
    }
    
    func resetToFlat() {
        applyPreset(.flat)
    }
    
    func refresh() {
        for i in 0..<20 {
            bandGains[i] = audioEngine.getEQGain(band: i)
        }
        checkIfPresetMatches()
    }
    
    private func updateAudioEngine(gains: [Float]) {
        for (index, gain) in gains.enumerated() {
            audioEngine.setEQ(band: index, gain: gain)
        }
        
        checkIfPresetMatches()
    }
    
    private func checkIfPresetMatches() {
        for preset in EqualizerPreset.allPresets {
            if preset.gains == bandGains {
                selectedPreset = preset
                return
            }
        }
        selectedPreset = nil
    }
}
