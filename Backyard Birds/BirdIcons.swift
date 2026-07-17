import SwiftUI

// All in-app iconography is drawn from custom Paths — no SF Symbols, no emoji.

// MARK: - Basic strokes

struct ChevronIcon: View {
    enum Direction { case left, right, up, down }
    var direction: Direction = .right
    var size: CGFloat = 14
    var color: Color = Aviary.inkSoft
    var weight: CGFloat = 2.4

    var body: some View {
        ChevronShape(direction: direction)
            .stroke(color, style: StrokeStyle(lineWidth: weight, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
    }
}

struct ChevronShape: Shape {
    let direction: ChevronIcon.Direction
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        switch direction {
        case .right:
            p.move(to: CGPoint(x: w * 0.32, y: h * 0.12))
            p.addLine(to: CGPoint(x: w * 0.72, y: h * 0.5))
            p.addLine(to: CGPoint(x: w * 0.32, y: h * 0.88))
        case .left:
            p.move(to: CGPoint(x: w * 0.68, y: h * 0.12))
            p.addLine(to: CGPoint(x: w * 0.28, y: h * 0.5))
            p.addLine(to: CGPoint(x: w * 0.68, y: h * 0.88))
        case .up:
            p.move(to: CGPoint(x: w * 0.12, y: h * 0.68))
            p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.28))
            p.addLine(to: CGPoint(x: w * 0.88, y: h * 0.68))
        case .down:
            p.move(to: CGPoint(x: w * 0.12, y: h * 0.32))
            p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.72))
            p.addLine(to: CGPoint(x: w * 0.88, y: h * 0.32))
        }
        return p
    }
}

struct PlusIcon: View {
    var size: CGFloat = 16
    var color: Color = .white
    var weight: CGFloat = 2.6
    var body: some View {
        PlusShape()
            .stroke(color, style: StrokeStyle(lineWidth: weight, lineCap: .round))
            .frame(width: size, height: size)
    }
}

struct PlusShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return p
    }
}

struct CloseIcon: View {
    var size: CGFloat = 14
    var color: Color = Aviary.inkSoft
    var weight: CGFloat = 2.4
    var body: some View {
        CloseShape()
            .stroke(color, style: StrokeStyle(lineWidth: weight, lineCap: .round))
            .frame(width: size, height: size)
    }
}

struct CloseShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return p
    }
}

struct CheckIcon: View {
    var size: CGFloat = 14
    var color: Color = .white
    var weight: CGFloat = 2.6
    var body: some View {
        CheckShape()
            .stroke(color, style: StrokeStyle(lineWidth: weight, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
    }
}

struct CheckShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.width * 0.08, y: rect.height * 0.55))
        p.addLine(to: CGPoint(x: rect.width * 0.38, y: rect.height * 0.85))
        p.addLine(to: CGPoint(x: rect.width * 0.92, y: rect.height * 0.18))
        return p
    }
}

struct SearchIcon: View {
    var size: CGFloat = 16
    var color: Color = Aviary.inkSoft
    var body: some View {
        SearchShape()
            .stroke(color, style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
            .frame(width: size, height: size)
    }
}

struct SearchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = rect.width * 0.36
        p.addEllipse(in: CGRect(x: rect.minX + 2, y: rect.minY + 2, width: r * 2, height: r * 2))
        p.move(to: CGPoint(x: rect.minX + 2 + r * 1.72, y: rect.minY + 2 + r * 1.72))
        p.addLine(to: CGPoint(x: rect.maxX - 1, y: rect.maxY - 1))
        return p
    }
}

// MARK: - Filled glyphs

struct FeatherGlyph: View {
    var size: CGFloat = 20
    var color: Color = Aviary.forest
    var body: some View {
        FeatherShape()
            .fill(color)
            .frame(width: size, height: size)
    }
}

struct FeatherShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.85, y: h * 0.05))
        p.addQuadCurve(to: CGPoint(x: w * 0.2, y: h * 0.75), control: CGPoint(x: w * 0.85, y: h * 0.55))
        p.addQuadCurve(to: CGPoint(x: w * 0.15, y: h * 0.95), control: CGPoint(x: w * 0.12, y: h * 0.85))
        p.addQuadCurve(to: CGPoint(x: w * 0.35, y: h * 0.78), control: CGPoint(x: w * 0.25, y: h * 0.9))
        p.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.05), control: CGPoint(x: w * 0.42, y: h * 0.28))
        p.closeSubpath()
        return p
    }
}

struct BirdGlyph: View {
    var size: CGFloat = 22
    var color: Color = Aviary.forest
    var body: some View {
        BirdShape()
            .fill(color)
            .frame(width: size, height: size * 0.9)
    }
}

// Simple perched-bird silhouette used for the tab bar and accents.
struct BirdShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // body
        p.addEllipse(in: CGRect(x: w * 0.18, y: h * 0.32, width: w * 0.52, height: h * 0.46))
        // head
        p.addEllipse(in: CGRect(x: w * 0.06, y: h * 0.12, width: w * 0.3, height: h * 0.32))
        // beak
        p.move(to: CGPoint(x: w * 0.09, y: h * 0.24))
        p.addLine(to: CGPoint(x: w * -0.02, y: h * 0.3))
        p.addLine(to: CGPoint(x: w * 0.09, y: h * 0.34))
        p.closeSubpath()
        // tail
        p.move(to: CGPoint(x: w * 0.62, y: h * 0.42))
        p.addLine(to: CGPoint(x: w * 0.98, y: h * 0.22))
        p.addLine(to: CGPoint(x: w * 0.72, y: h * 0.6))
        p.closeSubpath()
        return p
    }
}

struct EggGlyph: View {
    var size: CGFloat = 20
    var color: Color = Aviary.sage
    var body: some View {
        EggShape().fill(color).frame(width: size * 0.78, height: size)
    }
}

struct EggShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addCurve(to: CGPoint(x: w, y: h * 0.62),
                   control1: CGPoint(x: w * 0.85, y: h * 0.05),
                   control2: CGPoint(x: w, y: h * 0.35))
        p.addCurve(to: CGPoint(x: w * 0.5, y: h),
                   control1: CGPoint(x: w, y: h * 0.85),
                   control2: CGPoint(x: w * 0.78, y: h))
        p.addCurve(to: CGPoint(x: 0, y: h * 0.62),
                   control1: CGPoint(x: w * 0.22, y: h),
                   control2: CGPoint(x: 0, y: h * 0.85))
        p.addCurve(to: CGPoint(x: w * 0.5, y: 0),
                   control1: CGPoint(x: 0, y: h * 0.35),
                   control2: CGPoint(x: w * 0.15, y: h * 0.05))
        p.closeSubpath()
        return p
    }
}

struct StarGlyph: View {
    var size: CGFloat = 20
    var color: Color = Aviary.amber
    var body: some View {
        StarShape().fill(color).frame(width: size, height: size)
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let rOuter = rect.width / 2
        let rInner = rOuter * 0.42
        for i in 0..<10 {
            let ang = (CGFloat(i) * .pi / 5) - .pi / 2
            let r = i % 2 == 0 ? rOuter : rInner
            let pt = CGPoint(x: c.x + cos(ang) * r, y: c.y + sin(ang) * r)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

struct LeafGlyph: View {
    var size: CGFloat = 20
    var color: Color = Aviary.sage
    var body: some View {
        LeafShape().fill(color).frame(width: size, height: size)
    }
}

struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h), control: CGPoint(x: w * 1.05, y: h * 0.45))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: 0), control: CGPoint(x: w * -0.05, y: h * 0.55))
        p.closeSubpath()
        return p
    }
}

struct SunGlyph: View {
    var size: CGFloat = 20
    var color: Color = Aviary.amber
    var body: some View {
        ZStack {
            Circle().fill(color).frame(width: size * 0.5, height: size * 0.5)
            SunRaysShape()
                .stroke(color, style: StrokeStyle(lineWidth: size * 0.09, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct SunRaysShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r1 = rect.width * 0.34, r2 = rect.width * 0.48
        for i in 0..<8 {
            let ang = CGFloat(i) * .pi / 4
            p.move(to: CGPoint(x: c.x + cos(ang) * r1, y: c.y + sin(ang) * r1))
            p.addLine(to: CGPoint(x: c.x + cos(ang) * r2, y: c.y + sin(ang) * r2))
        }
        return p
    }
}

struct NestGlyph: View {
    var size: CGFloat = 20
    var color: Color = Aviary.amberDeep
    var body: some View {
        ZStack {
            NestBowlShape().fill(color)
            EggShape()
                .fill(Color.white.opacity(0.9))
                .frame(width: size * 0.26, height: size * 0.33)
                .offset(y: -size * 0.18)
        }
        .frame(width: size, height: size)
    }
}

struct NestBowlShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: 0, y: h * 0.45))
        p.addQuadCurve(to: CGPoint(x: w, y: h * 0.45), control: CGPoint(x: w * 0.5, y: h * 0.28))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h), control: CGPoint(x: w * 0.95, y: h * 0.95))
        p.addQuadCurve(to: CGPoint(x: 0, y: h * 0.45), control: CGPoint(x: w * 0.05, y: h * 0.95))
        p.closeSubpath()
        return p
    }
}

struct RingGlyph: View {
    var size: CGFloat = 20
    var color: Color = Aviary.forest
    var body: some View {
        Circle()
            .strokeBorder(color, lineWidth: size * 0.16)
            .frame(width: size, height: size)
    }
}

struct DropGlyph: View {
    var size: CGFloat = 20
    var color: Color = Aviary.sky
    var body: some View {
        DropShape().fill(color).frame(width: size * 0.72, height: size)
    }
}

struct DropShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addCurve(to: CGPoint(x: w * 0.5, y: h),
                   control1: CGPoint(x: w * 1.15, y: h * 0.55),
                   control2: CGPoint(x: w * 0.95, y: h))
        p.addCurve(to: CGPoint(x: w * 0.5, y: 0),
                   control1: CGPoint(x: w * 0.05, y: h),
                   control2: CGPoint(x: w * -0.15, y: h * 0.55))
        p.closeSubpath()
        return p
    }
}

struct PinGlyph: View {
    var size: CGFloat = 16
    var color: Color = Aviary.terracotta
    var body: some View {
        PinShape().fill(color).frame(width: size * 0.75, height: size)
    }
}

struct PinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let r = w / 2
        p.addArc(center: CGPoint(x: w / 2, y: r), radius: r,
                 startAngle: .degrees(150), endAngle: .degrees(30), clockwise: false)
        p.addLine(to: CGPoint(x: w / 2, y: h))
        p.closeSubpath()
        p.addEllipse(in: CGRect(x: w / 2 - r * 0.4, y: r - r * 0.4, width: r * 0.8, height: r * 0.8))
        return p
    }
}

struct CalendarGlyph: View {
    var size: CGFloat = 16
    var color: Color = Aviary.inkSoft
    var body: some View {
        CalendarShape()
            .stroke(color, style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
            .frame(width: size, height: size)
    }
}

struct CalendarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.addRoundedRect(in: CGRect(x: 0, y: h * 0.12, width: w, height: h * 0.85),
                         cornerSize: CGSize(width: 3, height: 3))
        p.move(to: CGPoint(x: 0, y: h * 0.38))
        p.addLine(to: CGPoint(x: w, y: h * 0.38))
        p.move(to: CGPoint(x: w * 0.28, y: 0))
        p.addLine(to: CGPoint(x: w * 0.28, y: h * 0.2))
        p.move(to: CGPoint(x: w * 0.72, y: 0))
        p.addLine(to: CGPoint(x: w * 0.72, y: h * 0.2))
        return p
    }
}

struct BookGlyph: View {
    var size: CGFloat = 22
    var color: Color = Aviary.inkSoft
    var body: some View {
        BookShape()
            .stroke(color, style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size * 0.85)
    }
}

struct BookShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.12))
        p.addQuadCurve(to: CGPoint(x: 0, y: h * 0.08), control: CGPoint(x: w * 0.22, y: h * -0.04))
        p.addLine(to: CGPoint(x: 0, y: h * 0.88))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.95), control: CGPoint(x: w * 0.25, y: h * 0.8))
        p.addQuadCurve(to: CGPoint(x: w, y: h * 0.88), control: CGPoint(x: w * 0.75, y: h * 0.8))
        p.addLine(to: CGPoint(x: w, y: h * 0.08))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.12), control: CGPoint(x: w * 0.78, y: h * -0.04))
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.12))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.95))
        return p
    }
}

struct ListGlyph: View {
    var size: CGFloat = 22
    var color: Color = Aviary.inkSoft
    var body: some View {
        ListShape()
            .stroke(color, style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
            .frame(width: size, height: size * 0.85)
    }
}

struct ListShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        for row in 0..<3 {
            let y = h * (0.15 + 0.35 * CGFloat(row))
            p.move(to: CGPoint(x: 0, y: y))
            p.addLine(to: CGPoint(x: w * 0.14, y: y))
            p.move(to: CGPoint(x: w * 0.3, y: y))
            p.addLine(to: CGPoint(x: w, y: y))
        }
        return p
    }
}

struct BulbGlyph: View {
    var size: CGFloat = 22
    var color: Color = Aviary.inkSoft
    var body: some View {
        BulbShape()
            .stroke(color, style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
            .frame(width: size * 0.8, height: size)
    }
}

struct BulbShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.32, y: h * 0.72))
        p.addCurve(to: CGPoint(x: w * 0.15, y: h * 0.3),
                   control1: CGPoint(x: w * 0.2, y: h * 0.62),
                   control2: CGPoint(x: w * 0.1, y: h * 0.48))
        p.addArc(center: CGPoint(x: w * 0.5, y: h * 0.3), radius: w * 0.35,
                 startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.addCurve(to: CGPoint(x: w * 0.68, y: h * 0.72),
                   control1: CGPoint(x: w * 0.9, y: h * 0.48),
                   control2: CGPoint(x: w * 0.8, y: h * 0.62))
        p.addLine(to: CGPoint(x: w * 0.32, y: h * 0.72))
        p.move(to: CGPoint(x: w * 0.35, y: h * 0.84))
        p.addLine(to: CGPoint(x: w * 0.65, y: h * 0.84))
        p.move(to: CGPoint(x: w * 0.4, y: h * 0.95))
        p.addLine(to: CGPoint(x: w * 0.6, y: h * 0.95))
        return p
    }
}

struct DotsGlyph: View {
    var size: CGFloat = 22
    var color: Color = Aviary.inkSoft
    var body: some View {
        HStack(spacing: size * 0.18) {
            ForEach(0..<3, id: \.self) { _ in
                Circle().fill(color).frame(width: size * 0.18, height: size * 0.18)
            }
        }
        .frame(width: size, height: size * 0.85)
    }
}

struct BinocularsGlyph: View {
    var size: CGFloat = 22
    var color: Color = Aviary.forest
    var body: some View {
        BinocularsShape().fill(color).frame(width: size, height: size * 0.8)
    }
}

struct BinocularsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.addEllipse(in: CGRect(x: 0, y: h * 0.4, width: w * 0.44, height: h * 0.6))
        p.addEllipse(in: CGRect(x: w * 0.56, y: h * 0.4, width: w * 0.44, height: h * 0.6))
        p.addRect(CGRect(x: w * 0.1, y: h * 0.05, width: w * 0.24, height: h * 0.5))
        p.addRect(CGRect(x: w * 0.66, y: h * 0.05, width: w * 0.24, height: h * 0.5))
        p.addRect(CGRect(x: w * 0.42, y: h * 0.28, width: w * 0.16, height: h * 0.2))
        return p
    }
}

// MARK: - Badge icon dispatcher

struct BadgeIconView: View {
    let kind: BadgeIconKind
    var size: CGFloat = 24
    var color: Color = Aviary.forest

    var body: some View {
        switch kind {
        case .feather: FeatherGlyph(size: size, color: color)
        case .egg: EggGlyph(size: size, color: color)
        case .nest: NestGlyph(size: size, color: color)
        case .star: StarGlyph(size: size, color: color)
        case .ring: RingGlyph(size: size, color: color)
        case .sun: SunGlyph(size: size, color: color)
        case .leaf: LeafGlyph(size: size, color: color)
        case .drop: DropGlyph(size: size, color: color)
        }
    }
}
