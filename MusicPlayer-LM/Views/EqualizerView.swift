import SwiftUI

struct EqualizerView: View {
    @ObservedObject var viewModel: EqualizerViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SpectrumAnalyzer(analyzer: viewModel.audioAnalyzer)
                    .frame(height: 120)
                    .padding(.horizontal)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 20) {
                        presetPicker
                        
                        equalizerBands
                        
                        resetButton
                    }
                    .padding()
                }
            }
            .navigationTitle("Equalizer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.refresh()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var presetPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Presets")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(EqualizerPreset.allPresets) { preset in
                        Button(action: {
                            viewModel.applyPreset(preset)
                        }) {
                            Text(preset.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    viewModel.selectedPreset?.id == preset.id ?
                                    Color.blue : Color(.systemGray5)
                                )
                                .foregroundColor(
                                    viewModel.selectedPreset?.id == preset.id ?
                                    .white : .primary
                                )
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var equalizerBands: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Frequency Bands")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            GeometryReader { geometry in
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(0..<20, id: \.self) { band in
                        VStack(spacing: 4) {
                            Text("\(Int(viewModel.bandGains[band]))dB")
                                .font(.system(size: 8))
                                .foregroundColor(.secondary)
                                .frame(height: 12)
                            
                            VerticalSlider(
                                value: $viewModel.bandGains[band],
                                range: -12...12
                            )
                            .frame(width: geometry.size.width / 20 - 2)
                            
                            Text(formatFrequency(viewModel.frequencies[band]))
                                .font(.system(size: 7))
                                .foregroundColor(.secondary)
                                .rotationEffect(.degrees(-45))
                                .offset(y: 10)
                                .frame(height: 20)
                        }
                    }
                }
            }
            .frame(height: 280)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
    
    private var resetButton: some View {
        Button(action: {
            viewModel.resetToFlat()
        }) {
            Text("Reset to Flat")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
    
    private func formatFrequency(_ freq: Float) -> String {
        if freq >= 1000 {
            return String(format: "%.1fk", freq / 1000)
        } else {
            return String(format: "%.0f", freq)
        }
    }
}

struct VerticalSlider: View {
    @Binding var value: Float
    let range: ClosedRange<Float>
    
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(.systemGray5))
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(value >= 0 ? Color.green : Color.orange)
                    .frame(height: abs(normalizedHeight(in: geometry.size)))
                    .offset(y: value >= 0 ? 0 : -normalizedHeight(in: geometry.size))
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .shadow(radius: 2)
                    .offset(y: -normalizedOffset(in: geometry.size))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        isDragging = true
                        updateValue(from: gesture.location.y, in: geometry.size)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
    }
    
    private func normalizedHeight(in size: CGSize) -> CGFloat {
        let normalized = CGFloat((value - 0) / (range.upperBound - range.lowerBound))
        return normalized * (size.height / 2)
    }
    
    private func normalizedOffset(in size: CGSize) -> CGFloat {
        let normalized = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
        return (1 - normalized) * size.height
    }
    
    private func updateValue(from y: CGFloat, in size: CGSize) {
        let normalized = 1 - (y / size.height)
        let newValue = Float(normalized) * (range.upperBound - range.lowerBound) + range.lowerBound
        value = min(max(newValue, range.lowerBound), range.upperBound)
    }
}

struct SpectrumAnalyzer: View {
    @ObservedObject var analyzer: AudioAnalyzer
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let barWidth = size.width / 20
                
                for i in 0..<20 {
                    let level = getLevelForBand(i)
                    let height = CGFloat(level) * size.height * 0.8
                    
                    let x = CGFloat(i) * barWidth
                    let rect = CGRect(
                        x: x + 2,
                        y: size.height - height,
                        width: barWidth - 4,
                        height: height
                    )
                    
                    let color = colorForLevel(level)
                    context.fill(
                        Path(roundedRect: rect, cornerRadius: 2),
                        with: .color(color)
                    )
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemGray6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(12)
    }
    
    private func getLevelForBand(_ band: Int) -> Float {
        switch band {
        case 0...6:
            return analyzer.bass
        case 7...13:
            return analyzer.mid
        case 14...19:
            return analyzer.treble
        default:
            return 0
        }
    }
    
    private func colorForLevel(_ level: Float) -> Color {
        if level > 0.7 {
            return .red
        } else if level > 0.4 {
            return .orange
        } else {
            return .green
        }
    }
}
