import SwiftUI

struct ParticleConstellationVisualizer: View {
    @ObservedObject var analyzer: AudioAnalyzer
    @State private var particles: [Particle] = []
    @State private var connections: Set<Connection> = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.05, green: 0.0, blue: 0.15),
                        Color(red: 0.0, green: 0.05, blue: 0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                Canvas { context, size in
                    for connection in connections {
                        if let p1 = particles.first(where: { $0.id == connection.particle1 }),
                           let p2 = particles.first(where: { $0.id == connection.particle2 }) {
                            var path = Path()
                            path.move(to: p1.position)
                            path.addLine(to: p2.position)
                            
                            let distance = hypot(p1.position.x - p2.position.x, p1.position.y - p2.position.y)
                            let opacity = max(0, 1.0 - distance / 150.0) * Double(analyzer.mid)
                            
                            context.stroke(
                                path,
                                with: .color(Color.cyan.opacity(opacity)),
                                lineWidth: 1
                            )
                        }
                    }
                    
                    for particle in particles {
                        let size = particle.size * (1.0 + CGFloat(analyzer.bass) * 0.5)
                        let rect = CGRect(
                            x: particle.position.x - size / 2,
                            y: particle.position.y - size / 2,
                            width: size,
                            height: size
                        )
                        
                        context.fill(
                            Path(ellipseIn: rect),
                            with: .color(particle.color.opacity(0.8 + Double(analyzer.treble) * 0.2))
                        )
                        
                        context.fill(
                            Path(ellipseIn: rect.insetBy(dx: size * 0.3, dy: size * 0.3)),
                            with: .color(Color.white.opacity(0.6))
                        )
                    }
                }
                .drawingGroup()
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
            .onChange(of: analyzer.averageAmplitude) { _, newValue in
                updateParticles(amplitude: newValue, size: geometry.size)
            }
        }
    }
    
    private func generateParticles(in size: CGSize) {
        particles = (0..<50).map { i in
            Particle(
                id: i,
                position: CGPoint(
                    x: CGFloat.random(in: 50...(size.width - 50)),
                    y: CGFloat.random(in: 50...(size.height - 50))
                ),
                velocity: CGVector(
                    dx: CGFloat.random(in: -0.5...0.5),
                    dy: CGFloat.random(in: -0.5...0.5)
                ),
                size: CGFloat.random(in: 3...8),
                color: Color(
                    hue: Double.random(in: 0.5...0.7),
                    saturation: 0.7,
                    brightness: 0.9
                )
            )
        }
        updateConnections()
    }
    
    private func updateParticles(amplitude: Float, size: CGSize) {
        let energyMultiplier = 1.0 + CGFloat(amplitude) * 3.0
        
        for i in particles.indices {
            var particle = particles[i]
            
            particle.position.x += particle.velocity.dx * energyMultiplier
            particle.position.y += particle.velocity.dy * energyMultiplier
            
            if particle.position.x < 0 || particle.position.x > size.width {
                particle.velocity.dx *= -1
                particle.position.x = max(0, min(size.width, particle.position.x))
            }
            if particle.position.y < 0 || particle.position.y > size.height {
                particle.velocity.dy *= -1
                particle.position.y = max(0, min(size.height, particle.position.y))
            }
            
            particles[i] = particle
        }
        
        updateConnections()
    }
    
    private func updateConnections() {
        var newConnections = Set<Connection>()
        
        for i in 0..<particles.count {
            for j in (i + 1)..<particles.count {
                let p1 = particles[i]
                let p2 = particles[j]
                let distance = hypot(p1.position.x - p2.position.x, p1.position.y - p2.position.y)
                
                if distance < 120 {
                    newConnections.insert(Connection(particle1: p1.id, particle2: p2.id))
                }
            }
        }
        
        connections = newConnections
    }
}

struct Particle: Identifiable {
    let id: Int
    var position: CGPoint
    var velocity: CGVector
    let size: CGFloat
    let color: Color
}

struct Connection: Hashable {
    let particle1: Int
    let particle2: Int
}
