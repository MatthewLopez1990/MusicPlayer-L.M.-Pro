import Foundation
import AVFoundation
import Accelerate
import Combine

final class AudioAnalyzer: ObservableObject {
    @Published var bass: Float = 0.0
    @Published var mid: Float = 0.0
    @Published var treble: Float = 0.0
    @Published var averageAmplitude: Float = 0.0
    
    private let fftSize = 1024
    private var fftSetup: vDSP_DFT_Setup?
    
    init() {
        fftSetup = vDSP_DFT_zop_CreateSetup(nil, vDSP_Length(fftSize), vDSP_DFT_Direction.FORWARD)
    }
    
    deinit {
        if let setup = fftSetup {
            vDSP_DFT_DestroySetup(setup)
        }
    }
    
    func analyzeTap(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameCount = Int(buffer.frameLength)
        
        let frames = Array(UnsafeBufferPointer(start: channelData, count: min(frameCount, fftSize)))
        
        var amplitude: Float = 0.0
        vDSP_rmsqv(frames, 1, &amplitude, vDSP_Length(frames.count))
        
        DispatchQueue.main.async {
            self.averageAmplitude = min(amplitude * 10.0, 1.0)
        }
        
        performFFT(frames: frames)
    }
    
    private func performFFT(frames: [Float]) {
        guard let setup = fftSetup, frames.count >= fftSize else { return }
        
        let realParts = [Float](frames.prefix(fftSize))
        let imaginaryParts = [Float](repeating: 0.0, count: fftSize)
        
        var realOut = [Float](repeating: 0.0, count: fftSize)
        var imagOut = [Float](repeating: 0.0, count: fftSize)
        
        realParts.withUnsafeBufferPointer { realPtr in
            imaginaryParts.withUnsafeBufferPointer { imagPtr in
                realOut.withUnsafeMutableBufferPointer { realOutPtr in
                    imagOut.withUnsafeMutableBufferPointer { imagOutPtr in
                        vDSP_DFT_Execute(setup, realPtr.baseAddress!, imagPtr.baseAddress!,
                                       realOutPtr.baseAddress!, imagOutPtr.baseAddress!)
                    }
                }
            }
        }
        
        var magnitudes = [Float](repeating: 0.0, count: fftSize / 2)
        for i in 0..<fftSize / 2 {
            let real = realOut[i]
            let imag = imagOut[i]
            magnitudes[i] = sqrt(real * real + imag * imag)
        }
        
        let bassRange = 0..<10
        let midRange = 10..<50
        let trebleRange = 50..<200
        
        let bassAvg = magnitudes[bassRange].reduce(0, +) / Float(bassRange.count)
        let midAvg = magnitudes[midRange].reduce(0, +) / Float(midRange.count)
        let trebleAvg = magnitudes[trebleRange].reduce(0, +) / Float(trebleRange.count)
        
        let maxMagnitude = magnitudes.max() ?? 1.0
        
        DispatchQueue.main.async {
            self.bass = min(bassAvg / maxMagnitude, 1.0)
            self.mid = min(midAvg / maxMagnitude, 1.0)
            self.treble = min(trebleAvg / maxMagnitude, 1.0)
        }
    }
}
