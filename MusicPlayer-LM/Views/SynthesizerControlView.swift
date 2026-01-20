import SwiftUI

struct SynthesizerControlView: View {
    @ObservedObject var viewModel: PlayerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Audio Synthesizer")
                .font(.headline)
                .padding(.top)
            
            // Pitch & Speed
            Group {
                VStack {
                    Text("Pitch: \(Int(viewModel.pitch)) cents")
                    Slider(value: Binding(
                        get: { viewModel.pitch },
                        set: { viewModel.updatePitch($0) }
                    ), in: -2400...2400)
                }
                
                VStack {
                    Text("Speed: \(String(format: "%.2fx", viewModel.speed))")
                    Slider(value: Binding(
                        get: { viewModel.speed },
                        set: { viewModel.updateSpeed($0) }
                    ), in: 0.25...2.0)
                }
            }
            
            Divider()
            
            // Reverb
            VStack {
                Text("Reverb Mix: \(Int(viewModel.reverb))%")
                Slider(value: Binding(
                    get: { viewModel.reverb },
                    set: { viewModel.updateReverb($0) }
                ), in: 0...100)
            }
            
            Divider()
            
            // EQ
            Group {
                Text("Equalizer")
                    .font(.subheadline)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Bass")
                        Slider(value: Binding(
                            get: { viewModel.bass },
                            set: { viewModel.updateEQ(bass: $0, mid: viewModel.mid, treble: viewModel.treble) }
                        ), in: -24...24)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 50, height: 150)
                    }
                    
                    VStack {
                        Text("Mid")
                        Slider(value: Binding(
                            get: { viewModel.mid },
                            set: { viewModel.updateEQ(bass: viewModel.bass, mid: $0, treble: viewModel.treble) }
                        ), in: -24...24)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 50, height: 150)
                    }
                    
                    VStack {
                        Text("Treble")
                        Slider(value: Binding(
                            get: { viewModel.treble },
                            set: { viewModel.updateEQ(bass: viewModel.bass, mid: viewModel.mid, treble: $0) }
                        ), in: -24...24)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 50, height: 150)
                    }
                }
                .frame(height: 180)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}
