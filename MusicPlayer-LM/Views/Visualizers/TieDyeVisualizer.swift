import SwiftUI

struct TieDyeVisualizer: View {
    @ObservedObject var analyzer: AudioAnalyzer
    @State private var rotation: Double = 0
    @State private var colorOffset: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<5) { layer in
                TieDyeLayer(
                    rotation: rotation + Double(layer) * 72,
                    scale: 1.0 + CGFloat(analyzer.bass) * 0.5,
                    colorOffset: colorOffset + Double(layer) * 0.2,
                    intensity: CGFloat(analyzer.mid)
                )
                .opacity(0.6)
                .blendMode(.screen)
            }
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(Double(analyzer.treble) * 0.8),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .blur(radius: 20)
        }
        .onChange(of: analyzer.averageAmplitude) { _, newValue in
            withAnimation(.linear(duration: 0.5)) {
                rotation += Double(newValue) * 10
                colorOffset += Double(newValue) * 0.1
            }
        }
    }
}

struct TieDyeLayer: View {
    let rotation: Double
    let scale: CGFloat
    let colorOffset: Double
    let intensity: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<8) { i in
                SpiralBlob(
                    angle: Double(i) * 45,
                    color: colorForIndex(i),
                    intensity: intensity
                )
            }
        }
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
    }
    
    private func colorForIndex(_ index: Int) -> Color {
        let hue = (Double(index) / 8.0 + colorOffset).truncatingRemainder(dividingBy: 1.0)
        return Color(hue: hue, saturation: 0.8, brightness: 0.9)
    }
}

struct SpiralBlob: View {
    let angle: Double
    let color: Color
    let intensity: CGFloat
    
    var body: some View {
        Ellipse()
            .fill(color)
            .frame(width: 120 + intensity * 80, height: 200 + intensity * 100)
            .blur(radius: 30)
            .offset(y: -100)
            .rotationEffect(.degrees(angle))
    }
}
