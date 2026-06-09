import SwiftUI

struct MicButton: View {
    let state: KeyboardState
    let size: CGFloat
    let onPressStart: () -> Void
    let onPressEnd: () -> Void
    let onCancelDrag: () -> Void

    @State private var pressed: Bool = false
    @State private var spinnerAngle: Double = 0
    @State private var shakeOffset: CGFloat = 0

    private var disabled: Bool {
        switch state {
        case .transcribing, .cleaning: return true
        default: return false
        }
    }
    private var isRecording: Bool {
        if case .recording = state { return true }
        return false
    }

    var body: some View {
        ZStack {
            if isRecording {
                PulseRings()
                    .frame(width: size + 24, height: size + 24)
                    .allowsHitTesting(false)
            }

            // Outer disc is always ink (museum: high-contrast monochrome).
            Circle().fill(FWColor.ink)
                .frame(width: size, height: size)
                .overlay(innerContent)
                .scaleEffect(isRecording ? 0.97 : 1.0)
                .offset(x: shakeOffset)
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isRecording)
                .opacity(disabled ? 0.95 : 1.0)
        }
        .frame(width: size, height: size)
        .contentShape(Circle())
        .gesture(dragGesture)
        .onChange(of: state) { _, newVal in
            if case .error = newVal {
                withAnimation(.linear(duration: 0.06).repeatCount(6, autoreverses: true)) {
                    shakeOffset = 6
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.linear(duration: 0.05)) { shakeOffset = 0 }
                }
            }
        }
        .accessibilityLabel("Hold to record")
        .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder
    private var innerContent: some View {
        switch state {
        case .idle:
            // Outlined bone circle holding the mic glyph.
            Circle()
                .strokeBorder(FWColor.bone, lineWidth: 1.2)
                .frame(width: size * 0.55, height: size * 0.55)
                .overlay(MicGlyph(size: 36, color: FWColor.bone))
        case .recording:
            // Solid bone circle holding ink mic glyph.
            Circle()
                .fill(FWColor.bone)
                .frame(width: size * 0.5, height: size * 0.5)
                .overlay(MicGlyph(size: 32, color: FWColor.ink))
        case .transcribing:
            Circle()
                .strokeBorder(FWColor.bone, lineWidth: 1.2)
                .frame(width: size * 0.55, height: size * 0.55)
                .overlay(SpinnerView(angle: spinnerAngle, color: FWColor.bone, size: 32))
                .onAppear {
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        spinnerAngle = 360
                    }
                }
        case .cleaning:
            HatchCircle(size: size * 0.55)
                .overlay(SpinnerView(angle: spinnerAngle, color: FWColor.bone, size: 32))
                .onAppear {
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        spinnerAngle = 360
                    }
                }
        case .error:
            ZStack {
                Circle().fill(FWColor.bone).frame(width: size * 0.5, height: size * 0.5)
                Text("!")
                    .font(FWFont.serif(30, weight: .bold))
                    .foregroundColor(FWColor.ink)
            }
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                if !pressed {
                    pressed = true
                    if disabled { return }
                    onPressStart()
                }
                if isRecording {
                    let center = CGPoint(x: size / 2, y: size / 2)
                    let dx = value.location.x - center.x
                    let dy = value.location.y - center.y
                    let dist = (dx * dx + dy * dy).squareRoot()
                    if dist > size * 0.85 {
                        pressed = false
                        onCancelDrag()
                    }
                }
            }
            .onEnded { _ in
                guard pressed else { return }
                pressed = false
                if disabled { return }
                onPressEnd()
            }
    }
}

struct SpinnerView: View {
    var angle: Double
    var color: Color
    var size: CGFloat
    var body: some View {
        ZStack {
            Circle().stroke(color.opacity(0.22), lineWidth: 1.5)
            Circle().trim(from: 0, to: 0.4)
                .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                .rotationEffect(.degrees(angle))
        }
        .frame(width: size, height: size)
    }
}

struct HatchCircle: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            Circle().fill(FWColor.ink)
                .frame(width: size, height: size)
            // 45° hatch pattern via diagonal lines clipped to the circle.
            Canvas { ctx, sz in
                let step: CGFloat = 4
                let n = Int((sz.width + sz.height) / step) + 2
                for i in 0..<n {
                    let off = CGFloat(i) * step - sz.height
                    var p = Path()
                    p.move(to: CGPoint(x: off, y: 0))
                    p.addLine(to: CGPoint(x: off + sz.height, y: sz.height))
                    ctx.stroke(p, with: .color(FWColor.bone.opacity(0.45)),
                               style: StrokeStyle(lineWidth: 0.6))
                }
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
        }
    }
}

struct PulseRings: View {
    @State private var animate: Bool = false
    var body: some View {
        ZStack {
            ring(delay: 0.0)
            ring(delay: 0.4)
            ring(delay: 0.8)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.6).repeatForever(autoreverses: false)) {
                animate = true
            }
        }
    }
    private func ring(delay: Double) -> some View {
        Circle()
            .strokeBorder(FWColor.ink, lineWidth: 1)
            .scaleEffect(animate ? 1.7 : 0.7)
            .opacity(animate ? 0 : 0.6)
            .animation(.easeOut(duration: 1.6).repeatForever(autoreverses: false).delay(delay),
                       value: animate)
    }
}
