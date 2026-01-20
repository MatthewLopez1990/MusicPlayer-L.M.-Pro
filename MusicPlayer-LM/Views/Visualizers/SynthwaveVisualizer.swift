import SwiftUI

struct SynthwaveVisualizer: View {
    @ObservedObject var analyzer: AudioAnalyzer
    @State private var gridOffset: CGFloat = 0
    @State private var sunScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.0, blue: 0.2),
                    Color(red: 0.3, green: 0.0, blue: 0.5),
                    Color(red: 0.5, green: 0.1, blue: 0.3)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 100)
                
                SynthwaveSun(scale: 1.0 + CGFloat(analyzer.bass) * 0.3)
                    .frame(width: 150, height: 150)
                
                Spacer()
                
                PerspectiveGrid(offset: gridOffset, bass: CGFloat(analyzer.bass))
                    .frame(height: 200)
            }
        }
        .onChange(of: analyzer.averageAmplitude) { _, newValue in
            withAnimation(.linear(duration: 0.1)) {
                gridOffset += CGFloat(newValue) * 2.0
            }
        }
    }
}

struct SynthwaveSun: View {
    let scale: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.3, blue: 0.6),
                            Color(red: 1.0, green: 0.6, blue: 0.0),
                            Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.5)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 75
                    )
                )
                .blur(radius: 10)
                .scaleEffect(scale)
            
            ForEach(0..<8) { i in
                Rectangle()
                    .fill(Color(red: 1.0, green: 0.4, blue: 0.6))
                    .frame(width: 150, height: 3)
                    .offset(y: CGFloat(i) * 12 - 42)
                    .mask(
                        Circle()
                            .frame(width: 150, height: 150)
                    )
            }
        }
    }
}

struct PerspectiveGrid: View {
    let offset: CGFloat
    let bass: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<20) { i in
                    let y = CGFloat(i) * 20 + offset.truncatingRemainder(dividingBy: 20)
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                    .stroke(
                        Color(red: 0.0, green: 1.0, blue: 1.0).opacity(0.3 + Double(bass) * 0.4),
                        lineWidth: 2
                    )
                }
                
                ForEach(-5..<6) { i in
                    let perspectiveX = geometry.size.width / 2 + CGFloat(i) * 40
                    Path { path in
                        path.move(to: CGPoint(x: perspectiveX, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width / 2 + CGFloat(i) * 100, y: geometry.size.height))
                    }
                    .stroke(
                        Color(red: 1.0, green: 0.0, blue: 1.0).opacity(0.3 + Double(bass) * 0.4),
                        lineWidth: 2
                    )
                }
            }
        }
    }
}
