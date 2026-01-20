import SwiftUI

struct PlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State private var showSynthesizer = false
    @State private var showEqualizer = false
    @StateObject private var equalizerViewModel = EqualizerViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                switch viewModel.visualizerTheme {
                case .synthwave:
                    SynthwaveVisualizer(analyzer: viewModel.audioAnalyzer)
                case .tieDye:
                    TieDyeVisualizer(analyzer: viewModel.audioAnalyzer)
                case .constellation:
                    ParticleConstellationVisualizer(analyzer: viewModel.audioAnalyzer)
                }
                
                if let song = viewModel.currentSong {
                    VStack {
                        Spacer()
                        
                        Text(song.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 5)
                        
                        Text(song.artist)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.5), radius: 5)
                        
                        Spacer()
                            .frame(height: 60)
                    }
                } else {
                    Text("Select a Song")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.cycleVisualizerTheme()
                        }) {
                            Image(systemName: "wand.and.stars")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.3)))
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            
            Spacer()
            
            if viewModel.currentSong != nil {
                VStack(spacing: 12) {
                    Slider(value: Binding(
                        get: { viewModel.currentTime },
                        set: { newValue in
                            viewModel.seek(to: newValue)
                        }
                    ), in: 0...max(viewModel.duration, 0.01))
                    .accentColor(.purple)
                    
                    HStack {
                        Text(viewModel.formatTime(viewModel.currentTime))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(viewModel.formatTime(viewModel.duration))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            HStack(spacing: 40) {
                Button(action: {
                    // Previous
                }) {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                }
                
                Button(action: {
                    viewModel.togglePlayPause()
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 80))
                }
                
                Button(action: {
                    // Next
                }) {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                }
            }
            .padding()
            
            HStack(spacing: 16) {
                Button(action: {
                    showEqualizer.toggle()
                }) {
                    Label("Equalizer", systemImage: "slider.horizontal.3")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    showSynthesizer.toggle()
                }) {
                    Label("Effects", systemImage: "waveform.circle")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom)
            
            .sheet(isPresented: $showEqualizer) {
                EqualizerView(viewModel: equalizerViewModel)
            }
            .sheet(isPresented: $showSynthesizer) {
                SynthesizerControlView(viewModel: viewModel)
            }
        }
    }
}
