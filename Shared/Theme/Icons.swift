import SwiftUI

// Custom SF-Symbol-style glyphs drawn from scratch to match design-specs/icons.jsx.
// All are sized via the provided size; colors via foregroundColor.

struct MicGlyph: View {
    var size: CGFloat = 38
    var color: Color = .white
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 32
            let stroke = StrokeStyle(lineWidth: 2.2 * s, lineCap: .round)

            // capsule body 12,4 8x16 r4
            let body = Path(roundedRect: CGRect(x: 12 * s, y: 4 * s, width: 8 * s, height: 16 * s),
                            cornerRadius: 4 * s)
            ctx.fill(body, with: .color(color))

            // arc M8 14.5 a 8 8 0 0 0 16 0
            var arc = Path()
            arc.addArc(center: CGPoint(x: 16 * s, y: 14.5 * s),
                       radius: 8 * s, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            ctx.stroke(arc, with: .color(color), style: stroke)

            // stem
            var stem = Path()
            stem.move(to: CGPoint(x: 16 * s, y: 22.5 * s))
            stem.addLine(to: CGPoint(x: 16 * s, y: 28 * s))
            ctx.stroke(stem, with: .color(color), style: stroke)

            // base
            var base = Path()
            base.move(to: CGPoint(x: 11.5 * s, y: 28 * s))
            base.addLine(to: CGPoint(x: 20.5 * s, y: 28 * s))
            ctx.stroke(base, with: .color(color), style: stroke)
        }
        .frame(width: size, height: size)
    }
}

struct GlobeGlyph: View {
    var size: CGFloat = 22
    var color: Color = FWColor.label
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 24
            let stroke = StrokeStyle(lineWidth: 1.6 * s)
            let circle = Path(ellipseIn: CGRect(x: 3 * s, y: 3 * s, width: 18 * s, height: 18 * s))
            ctx.stroke(circle, with: .color(color), style: stroke)

            let oval = Path(ellipseIn: CGRect(x: 7.5 * s, y: 3 * s, width: 9 * s, height: 18 * s))
            ctx.stroke(oval, with: .color(color), style: stroke)

            var eq = Path()
            eq.move(to: CGPoint(x: 3 * s, y: 12 * s))
            eq.addLine(to: CGPoint(x: 21 * s, y: 12 * s))
            ctx.stroke(eq, with: .color(color), style: stroke)
        }
        .frame(width: size, height: size)
    }
}

struct BackspaceGlyph: View {
    var size: CGFloat = 22
    var color: Color = FWColor.label
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let s = w / 26
            let stroke = StrokeStyle(lineWidth: 1.7 * s, lineCap: .round, lineJoin: .round)
            var outline = Path()
            outline.move(to: CGPoint(x: 8 * s, y: 1 * s))
            outline.addLine(to: CGPoint(x: 22 * s, y: 1 * s))
            outline.addQuadCurve(to: CGPoint(x: 25 * s, y: 4 * s),
                                 control: CGPoint(x: 25 * s, y: 1 * s))
            outline.addLine(to: CGPoint(x: 25 * s, y: 18 * s))
            outline.addQuadCurve(to: CGPoint(x: 22 * s, y: 21 * s),
                                 control: CGPoint(x: 25 * s, y: 21 * s))
            outline.addLine(to: CGPoint(x: 8 * s, y: 21 * s))
            outline.addLine(to: CGPoint(x: 1 * s, y: 11 * s))
            outline.closeSubpath()
            ctx.stroke(outline, with: .color(color), style: stroke)

            var x1 = Path()
            x1.move(to: CGPoint(x: 12 * s, y: 7 * s))
            x1.addLine(to: CGPoint(x: 20 * s, y: 15 * s))
            ctx.stroke(x1, with: .color(color), style: stroke)
            var x2 = Path()
            x2.move(to: CGPoint(x: 20 * s, y: 7 * s))
            x2.addLine(to: CGPoint(x: 12 * s, y: 15 * s))
            ctx.stroke(x2, with: .color(color), style: stroke)
        }
        .frame(width: size, height: size + (size * 4.0/22.0))
    }
}

struct CheckGlyph: View {
    var size: CGFloat = 16
    var color: Color = .white
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 16
            var p = Path()
            p.move(to: CGPoint(x: 3 * s, y: 8.5 * s))
            p.addLine(to: CGPoint(x: 6.2 * s, y: 11.7 * s))
            p.addLine(to: CGPoint(x: 13 * s, y: 5 * s))
            ctx.stroke(p, with: .color(color),
                       style: StrokeStyle(lineWidth: 2.2 * s, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct WarnGlyph: View {
    var size: CGFloat = 12
    var color: Color = .white.opacity(0.85)
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 16
            var bar = Path()
            bar.move(to: CGPoint(x: 8 * s, y: 4.5 * s))
            bar.addLine(to: CGPoint(x: 8 * s, y: 8.5 * s))
            ctx.stroke(bar, with: .color(color),
                       style: StrokeStyle(lineWidth: 2 * s, lineCap: .round))
            let dot = Path(ellipseIn: CGRect(x: 6.9 * s, y: 10.4 * s, width: 2.2 * s, height: 2.2 * s))
            ctx.fill(dot, with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

struct BangGlyph: View {
    var size: CGFloat = 32
    var color: Color = .white
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 16
            var bar = Path()
            bar.move(to: CGPoint(x: 8 * s, y: 3.5 * s))
            bar.addLine(to: CGPoint(x: 8 * s, y: 9.5 * s))
            ctx.stroke(bar, with: .color(color),
                       style: StrokeStyle(lineWidth: 2.2 * s, lineCap: .round))
            let dot = Path(ellipseIn: CGRect(x: 6.8 * s, y: 10.8 * s, width: 2.4 * s, height: 2.4 * s))
            ctx.fill(dot, with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

struct ChevronGlyph: View {
    var size: CGFloat = 13
    var color: Color = FWColor.tertiaryLabel
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            let s = h / 13
            var p = Path()
            p.move(to: CGPoint(x: 1 * s, y: 1 * s))
            p.addLine(to: CGPoint(x: 6 * s, y: 6.5 * s))
            p.addLine(to: CGPoint(x: 1 * s, y: 12 * s))
            ctx.stroke(p, with: .color(color),
                       style: StrokeStyle(lineWidth: 1.8 * s, lineCap: .round, lineJoin: .round))
            _ = w
        }
        .frame(width: size * 0.55, height: size)
    }
}

struct EyeGlyph: View {
    var size: CGFloat = 18
    var color: Color = Color(hex: 0x8E8E93)
    var off: Bool = false
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            let s = w / 20
            let stroke = StrokeStyle(lineWidth: 1.4 * s)
            var lid = Path()
            lid.move(to: CGPoint(x: 1 * s, y: 7 * s))
            lid.addQuadCurve(to: CGPoint(x: 19 * s, y: 7 * s),
                             control: CGPoint(x: 10 * s, y: -2 * s))
            lid.addQuadCurve(to: CGPoint(x: 1 * s, y: 7 * s),
                             control: CGPoint(x: 10 * s, y: 16 * s))
            ctx.stroke(lid, with: .color(color), style: stroke)

            let pupil = Path(ellipseIn: CGRect(x: 7.5 * s, y: 4.5 * s, width: 5 * s, height: 5 * s))
            ctx.stroke(pupil, with: .color(color), style: stroke)

            if off {
                var slash = Path()
                slash.move(to: CGPoint(x: 2 * s, y: 1 * s))
                slash.addLine(to: CGPoint(x: 18 * s, y: 13 * s))
                ctx.stroke(slash, with: .color(color),
                           style: StrokeStyle(lineWidth: 1.4 * s, lineCap: .round))
            }
            _ = h
        }
        .frame(width: size, height: size * 0.7)
    }
}

struct ExternalGlyph: View {
    var size: CGFloat = 11
    var color: Color = Color(hex: 0x8E8E93)
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 12
            let stroke = StrokeStyle(lineWidth: 1.6 * s, lineCap: .round)

            var arrow = Path()
            arrow.move(to: CGPoint(x: 4 * s, y: 1 * s))
            arrow.addLine(to: CGPoint(x: 11 * s, y: 1 * s))
            arrow.addLine(to: CGPoint(x: 11 * s, y: 8 * s))
            ctx.stroke(arrow, with: .color(color), style: stroke)

            var diag = Path()
            diag.move(to: CGPoint(x: 11 * s, y: 1 * s))
            diag.addLine(to: CGPoint(x: 5 * s, y: 7 * s))
            ctx.stroke(diag, with: .color(color), style: stroke)

            var box = Path()
            box.move(to: CGPoint(x: 9 * s, y: 7 * s))
            box.addLine(to: CGPoint(x: 9 * s, y: 10.5 * s))
            box.addLine(to: CGPoint(x: 1.5 * s, y: 10.5 * s))
            box.addLine(to: CGPoint(x: 1.5 * s, y: 3.5 * s))
            box.addLine(to: CGPoint(x: 5 * s, y: 3.5 * s))
            ctx.stroke(box, with: .color(color), style: stroke)
        }
        .frame(width: size, height: size)
    }
}

struct SparkleGlyph: View {
    var size: CGFloat = 14
    var color: Color = FWColor.aiPurple
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 14
            var p = Path()
            p.move(to: CGPoint(x: 7 * s, y: 1 * s))
            p.addLine(to: CGPoint(x: 8.3 * s, y: 5.2 * s))
            p.addLine(to: CGPoint(x: 12.5 * s, y: 6.5 * s))
            p.addLine(to: CGPoint(x: 8.3 * s, y: 7.8 * s))
            p.addLine(to: CGPoint(x: 7 * s, y: 12 * s))
            p.addLine(to: CGPoint(x: 5.7 * s, y: 7.8 * s))
            p.addLine(to: CGPoint(x: 1.5 * s, y: 6.5 * s))
            p.addLine(to: CGPoint(x: 5.7 * s, y: 5.2 * s))
            p.closeSubpath()
            ctx.fill(p, with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

struct LockGlyph: View {
    var size: CGFloat = 11
    var color: Color = FWColor.placeholderLabel
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let s = w / 14
            let stroke = StrokeStyle(lineWidth: 1.5 * s)
            let body = Path(roundedRect: CGRect(x: 2 * s, y: 6.5 * s, width: 10 * s, height: 8 * s),
                            cornerRadius: 1.5 * s)
            ctx.stroke(body, with: .color(color), style: stroke)
            var shackle = Path()
            shackle.move(to: CGPoint(x: 4.5 * s, y: 6.5 * s))
            shackle.addLine(to: CGPoint(x: 4.5 * s, y: 4.5 * s))
            shackle.addQuadCurve(to: CGPoint(x: 9.5 * s, y: 4.5 * s),
                                 control: CGPoint(x: 7 * s, y: 0.5 * s))
            shackle.addLine(to: CGPoint(x: 9.5 * s, y: 6.5 * s))
            ctx.stroke(shackle, with: .color(color), style: stroke)
        }
        .frame(width: size, height: size + 2)
    }
}

struct InfoGlyph: View {
    var size: CGFloat = 18
    var color: Color = Color(hex: 0x8E8E93)
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 18
            let stroke = StrokeStyle(lineWidth: 1.4 * s, lineCap: .round)
            let circle = Path(ellipseIn: CGRect(x: 1.5 * s, y: 1.5 * s, width: 15 * s, height: 15 * s))
            ctx.stroke(circle, with: .color(color), style: stroke)
            var bar = Path()
            bar.move(to: CGPoint(x: 9 * s, y: 8 * s))
            bar.addLine(to: CGPoint(x: 9 * s, y: 13 * s))
            ctx.stroke(bar, with: .color(color), style: StrokeStyle(lineWidth: 1.6 * s, lineCap: .round))
            let dot = Path(ellipseIn: CGRect(x: 8.1 * s, y: 4.7 * s, width: 1.8 * s, height: 1.8 * s))
            ctx.fill(dot, with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

struct TrashGlyph: View {
    var size: CGFloat = 15
    var color: Color = FWColor.dangerRed
    var body: some View {
        Canvas { ctx, sz in
            let s = sz.width / 16
            let stroke = StrokeStyle(lineWidth: 1.5 * s, lineCap: .round)
            var top = Path()
            top.move(to: CGPoint(x: 3 * s, y: 4.5 * s))
            top.addLine(to: CGPoint(x: 13 * s, y: 4.5 * s))
            ctx.stroke(top, with: .color(color), style: stroke)

            var lid = Path()
            lid.move(to: CGPoint(x: 6.5 * s, y: 4.5 * s))
            lid.addLine(to: CGPoint(x: 6.5 * s, y: 3 * s))
            lid.addLine(to: CGPoint(x: 9.5 * s, y: 3 * s))
            lid.addLine(to: CGPoint(x: 9.5 * s, y: 4.5 * s))
            ctx.stroke(lid, with: .color(color), style: stroke)

            var bin = Path()
            bin.move(to: CGPoint(x: 4 * s, y: 4.5 * s))
            bin.addLine(to: CGPoint(x: 4.6 * s, y: 12.7 * s))
            bin.addLine(to: CGPoint(x: 11.4 * s, y: 12.7 * s))
            bin.addLine(to: CGPoint(x: 12 * s, y: 4.5 * s))
            ctx.stroke(bin, with: .color(color), style: stroke)
        }
        .frame(width: size, height: size)
    }
}
