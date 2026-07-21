// Birds Next Door — deterministic art generator (macOS, swiftc)
// Usage: birdgen <outDir> [sample|all|icon|banners]
import Foundation
import CoreGraphics
import ImageIO
import AppKit

// MARK: - Seeded RNG (deterministic)
struct PorchRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 0x9E3779B97F4A7C15 : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state &* 0x2545F4914F6CDD1D
    }
    mutating func d(_ lo: Double, _ hi: Double) -> Double {
        lo + (hi - lo) * (Double(next() >> 11) / Double(1 << 53))
    }
    mutating func i(_ lo: Int, _ hi: Int) -> Int { Int(d(Double(lo), Double(hi + 1)).rounded(.down)) }
}

func seedFor(_ name: String) -> UInt64 {
    var h: UInt64 = 1469598103934665603
    for b in name.utf8 { h = (h ^ UInt64(b)) &* 1099511628211 }
    return h
}

// MARK: - Color helpers
struct Col {
    var r: CGFloat, g: CGFloat, b: CGFloat
    init(_ hex: UInt32) {
        r = CGFloat((hex >> 16) & 0xFF) / 255
        g = CGFloat((hex >> 8) & 0xFF) / 255
        b = CGFloat(hex & 0xFF) / 255
    }
    init(r: CGFloat, g: CGFloat, b: CGFloat) { self.r = r; self.g = g; self.b = b }
    func cg(_ a: CGFloat = 1) -> CGColor { CGColor(srgbRed: r, green: g, blue: b, alpha: a) }
    func darker(_ k: CGFloat) -> Col { Col(r: r * (1 - k), g: g * (1 - k), b: b * (1 - k)) }
    func lighter(_ k: CGFloat) -> Col {
        Col(r: r + (1 - r) * k, g: g + (1 - g) * k, b: b + (1 - b) * k)
    }
    func mix(_ o: Col, _ t: CGFloat) -> Col {
        Col(r: r + (o.r - r) * t, g: g + (o.g - g) * t, b: b + (o.b - b) * t)
    }
}

// MARK: - Canvas
final class Canvas {
    let ctx: CGContext
    let w: Int, h: Int
    init(_ w: Int, _ h: Int) {
        self.w = w; self.h = h
        ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0,
                        space: CGColorSpace(name: CGColorSpace.sRGB)!,
                        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    }
    func fill(_ c: Col) {
        ctx.setFillColor(c.cg())
        ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
    }
    func vGradient(_ top: Col, _ bottom: Col) {
        let g = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB)!,
                           colors: [bottom.cg(), top.cg()] as CFArray, locations: [0, 1])!
        ctx.drawLinearGradient(g, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: CGFloat(h)), options: [])
    }
    func ellipse(_ cx: CGFloat, _ cy: CGFloat, _ rx: CGFloat, _ ry: CGFloat, _ c: Col, alpha: CGFloat = 1, rot: CGFloat = 0) {
        ctx.saveGState()
        ctx.translateBy(x: cx, y: cy)
        ctx.rotate(by: rot * .pi / 180)
        ctx.setFillColor(c.cg(alpha))
        ctx.fillEllipse(in: CGRect(x: -rx, y: -ry, width: rx * 2, height: ry * 2))
        ctx.restoreGState()
    }
    func poly(_ pts: [CGPoint], _ c: Col, alpha: CGFloat = 1) {
        guard pts.count > 2 else { return }
        ctx.setFillColor(c.cg(alpha))
        ctx.beginPath()
        ctx.move(to: pts[0])
        for p in pts.dropFirst() { ctx.addLine(to: p) }
        ctx.closePath()
        ctx.fillPath()
    }
    func path(_ build: (CGMutablePath) -> Void, _ c: Col, alpha: CGFloat = 1) {
        let p = CGMutablePath()
        build(p)
        ctx.setFillColor(c.cg(alpha))
        ctx.addPath(p)
        ctx.fillPath()
    }
    func stroke(_ from: CGPoint, _ to: CGPoint, _ c: Col, width: CGFloat, alpha: CGFloat = 1) {
        ctx.setStrokeColor(c.cg(alpha))
        ctx.setLineWidth(width)
        ctx.setLineCap(.round)
        ctx.beginPath()
        ctx.move(to: from)
        ctx.addLine(to: to)
        ctx.strokePath()
    }
    // Half-res deterministic grain scaled 2x — texture + PNG weight
    func grain(seed: UInt64, alpha: CGFloat, block: Int = 3) {
        var rng = PorchRNG(seed: seed)
        let gw = w / block, gh = h / block
        var buf = [UInt8](repeating: 0, count: gw * gh)
        for idx in 0..<buf.count { buf[idx] = UInt8(truncatingIfNeeded: rng.next()) }
        let provider = CGDataProvider(data: Data(buf) as CFData)!
        let img = CGImage(width: gw, height: gh, bitsPerComponent: 8, bitsPerPixel: 8,
                          bytesPerRow: gw, space: CGColorSpaceCreateDeviceGray(),
                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
                          provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
        ctx.saveGState()
        ctx.setAlpha(alpha)
        ctx.setBlendMode(.overlay)
        ctx.interpolationQuality = .none
        ctx.draw(img, in: CGRect(x: 0, y: 0, width: w, height: h))
        ctx.restoreGState()
    }
    func write(_ url: URL) {
        let img = ctx.makeImage()!
        let dest = CGImageDestinationCreateWithURL(url as CFURL, "public.png" as CFString, 1, nil)!
        CGImageDestinationAddImage(dest, img, nil)
        CGImageDestinationFinalize(dest)
    }
}

// MARK: - Bird spec
enum BeakStyle { case cone, thin, chisel, needle, stout, curved }

struct BirdSpec {
    var id: String
    var group: String
    var body: Col
    var breast: Col?
    var wing: Col
    var head: Col?
    var cap: Col?          // top-of-head patch
    var mask: Col?         // band through the eye
    var brow: Col?         // stripe above the eye
    var throat: Col?       // chin/throat patch
    var belly: Col?        // lower belly wash
    var beak: BeakStyle = .cone
    var beakC: Col = Col(0x4A4038)
    var scale: CGFloat = 1.0
    var headScale: CGFloat = 1.0
    var beakLen: CGFloat = 1.0
    var tailLen: CGFloat = 1.0
    var tailUp: Bool = false       // cocked wren tail
    var crest: Bool = false
    var crestC: Col?
    var wingbars: Int = 0
    var wingbarC: Col = Col(0xF2EFE6)
    var streaks: Bool = false
    var streakC: Col = Col(0x6B5138)
    var breastSpot: Bool = false
    var wingPatch: Col?            // epaulet / colored shoulder patch
    var napeSpot: Col?             // woodpecker red nape
    var eyeC: Col = Col(0x1E1A18)
    var eyeRing: Bool = false
    var glossy: Bool = false
    var barredWing: Bool = false   // black/white barred wing rows
    var wingSpots: Bool = false    // dove / flicker dark wing spots
}

// MARK: - Group palettes
let groupBG: [String: (Col, Col, Col)] = [
    "songbirds":   (Col(0xF7EFDC), Col(0xF2D9BC), Col(0xEFC9A0)),
    "littleBirds": (Col(0xEEF2E4), Col(0xD8E4C9), Col(0xC4D6AC)),
    "finches":     (Col(0xF8F1D8), Col(0xEFDFAE), Col(0xE7CF8C)),
    "sparrows":    (Col(0xF5EEDF), Col(0xE4D6BE), Col(0xD3BE9C)),
    "woodpeckers": (Col(0xEAF0F2), Col(0xCFDEE2), Col(0xB8CFD6)),
    "jays":        (Col(0xE8F0F8), Col(0xCCDEEE), Col(0xAECBE4)),
]

let leafGreens = [Col(0x7B9E6B), Col(0x5F8756), Col(0x94AE7A), Col(0x6E9463)]
let branchCol = Col(0x77573C)

// MARK: - Bird portrait
func drawBird(_ spec: BirdSpec, size: Int = 1400) -> Canvas {
    let cv = Canvas(size, size)
    var rng = PorchRNG(seed: seedFor(spec.id))
    let S = CGFloat(size) / 1400.0
    let (bgTop, bgBot, circle) = groupBG[spec.group] ?? groupBG["songbirds"]!

    cv.vGradient(bgTop, bgBot)

    // soft halo circle
    cv.ellipse(700 * S, 700 * S, 545 * S, 545 * S, circle, alpha: 0.55)
    cv.ellipse(700 * S, 700 * S, 500 * S, 500 * S, circle.lighter(0.25), alpha: 0.6)

    // bokeh dots
    for _ in 0..<14 {
        let x = CGFloat(rng.d(80, 1320)) * S
        let y = CGFloat(rng.d(160, 1300)) * S
        let r = CGFloat(rng.d(8, 30)) * S
        cv.ellipse(x, y, r, r, circle.darker(0.12), alpha: CGFloat(rng.d(0.10, 0.28)))
    }

    // branch
    let branchY = 470 * S
    cv.path({ p in
        p.move(to: CGPoint(x: 60 * S, y: branchY - 30 * S))
        p.addQuadCurve(to: CGPoint(x: 1340 * S, y: branchY - 6 * S),
                       control: CGPoint(x: 700 * S, y: branchY + 34 * S))
        p.addLine(to: CGPoint(x: 1340 * S, y: branchY - 40 * S))
        p.addQuadCurve(to: CGPoint(x: 60 * S, y: branchY - 66 * S),
                       control: CGPoint(x: 700 * S, y: branchY - 6 * S))
        p.closeSubpath()
    }, branchCol)
    cv.path({ p in
        p.move(to: CGPoint(x: 60 * S, y: branchY - 30 * S))
        p.addQuadCurve(to: CGPoint(x: 1340 * S, y: branchY - 6 * S),
                       control: CGPoint(x: 700 * S, y: branchY + 34 * S))
        p.addLine(to: CGPoint(x: 1340 * S, y: branchY - 18 * S))
        p.addQuadCurve(to: CGPoint(x: 60 * S, y: branchY - 42 * S),
                       control: CGPoint(x: 700 * S, y: branchY + 20 * S))
        p.closeSubpath()
    }, branchCol.lighter(0.18))

    // leaves on the branch ends
    for (lx, flip) in [(150.0, false), (245.0, false), (1180.0, true), (1275.0, true)] {
        let g = leafGreens[rng.i(0, leafGreens.count - 1)]
        let dir: CGFloat = flip ? -1 : 1
        let bx = CGFloat(lx) * S
        let by = branchY + CGFloat(rng.d(-8, 10)) * S
        cv.path({ p in
            p.move(to: CGPoint(x: bx, y: by))
            p.addQuadCurve(to: CGPoint(x: bx + dir * 96 * S, y: by + 118 * S),
                           control: CGPoint(x: bx + dir * 116 * S, y: by + 22 * S))
            p.addQuadCurve(to: CGPoint(x: bx, y: by),
                           control: CGPoint(x: bx - dir * 26 * S, y: by + 92 * S))
        }, g, alpha: 0.9)
    }
    // hanging leaves top corners
    for (lx, flip) in [(90.0, false), (1310.0, true)] {
        let g = leafGreens[rng.i(0, leafGreens.count - 1)]
        let dir: CGFloat = flip ? -1 : 1
        let bx = CGFloat(lx) * S
        cv.path({ p in
            p.move(to: CGPoint(x: bx, y: 1400 * S))
            p.addQuadCurve(to: CGPoint(x: bx + dir * 130 * S, y: 1210 * S),
                           control: CGPoint(x: bx + dir * 160 * S, y: 1360 * S))
            p.addQuadCurve(to: CGPoint(x: bx, y: 1400 * S),
                           control: CGPoint(x: bx - dir * 20 * S, y: 1280 * S))
        }, g, alpha: 0.75)
    }

    // ---------- BIRD ----------
    let s = spec.scale * S
    let bcx = 730 * S, bcy = (470 + 240 * spec.scale) * S   // body sits on branch
    let brx = 235 * s, bry = 185 * s
    let headC = spec.head ?? spec.body
    let shade = spec.body.darker(0.18)

    // tail
    let tailBaseX = bcx + brx * 0.62
    let tailBaseY = bcy + (spec.tailUp ? -bry * 0.05 : bry * 0.10)
    let tLen = 300 * s * spec.tailLen
    let tAng: CGFloat = spec.tailUp ? 38 : -30
    let rad = tAng * .pi / 180
    let tipX = tailBaseX + cos(rad) * tLen
    let tipY = tailBaseY + sin(rad) * tLen
    let perp = CGPoint(x: -sin(rad), y: cos(rad))
    let halfW = 62 * s
    cv.poly([
        CGPoint(x: tailBaseX - perp.x * halfW, y: tailBaseY - perp.y * halfW - 26 * s),
        CGPoint(x: tailBaseX + perp.x * halfW, y: tailBaseY + perp.y * halfW + 8 * s),
        CGPoint(x: tipX + perp.x * halfW * 0.55, y: tipY + perp.y * halfW * 0.55),
        CGPoint(x: tipX - perp.x * halfW * 0.55, y: tipY - perp.y * halfW * 0.55),
    ], spec.wing.darker(0.10))

    // legs
    let legTopY = bcy - bry * 0.72
    cv.stroke(CGPoint(x: bcx - 46 * s, y: legTopY), CGPoint(x: bcx - 58 * s, y: branchY - 6 * S), Col(0x6B5138), width: 11 * s)
    cv.stroke(CGPoint(x: bcx + 30 * s, y: legTopY), CGPoint(x: bcx + 40 * s, y: branchY - 2 * S), Col(0x6B5138), width: 11 * s)

    // body
    cv.ellipse(bcx, bcy, brx, bry, spec.body, rot: -6)
    // back shading
    cv.ctx.saveGState()
    let bodyClip = CGMutablePath()
    bodyClip.addEllipse(in: CGRect(x: bcx - brx, y: bcy - bry, width: brx * 2, height: bry * 2),
                        transform: CGAffineTransform(translationX: bcx, y: bcy)
                            .rotated(by: -6 * .pi / 180)
                            .translatedBy(x: -bcx, y: -bcy))
    cv.ctx.addPath(bodyClip)
    cv.ctx.clip()
    cv.ellipse(bcx + brx * 0.35, bcy + bry * 0.45, brx * 0.95, bry * 0.8, shade, alpha: 0.5)
    // breast
    if let br = spec.breast {
        cv.ellipse(bcx - brx * 0.42, bcy - bry * 0.18, brx * 0.72, bry * 0.85, br)
    }
    if let belly = spec.belly {
        cv.ellipse(bcx - brx * 0.10, bcy - bry * 0.72, brx * 0.85, bry * 0.55, belly, alpha: 0.95)
    }
    // streaked breast
    if spec.streaks {
        for k in 0..<9 {
            let sx = bcx - brx * 0.78 + CGFloat(k % 3) * 44 * s + CGFloat(rng.d(-8, 8)) * s
            let sy = bcy - bry * 0.05 - CGFloat(k / 3) * 52 * s + CGFloat(rng.d(-6, 6)) * s
            cv.ellipse(sx, sy, 10 * s, 26 * s, spec.streakC, alpha: 0.7, rot: CGFloat(rng.d(-14, 14)))
        }
    }
    if spec.breastSpot {
        cv.ellipse(bcx - brx * 0.45, bcy + bry * 0.02, 30 * s, 36 * s, spec.streakC, alpha: 0.9)
    }
    cv.ctx.restoreGState()

    // wing
    let wcx = bcx + brx * 0.18, wcy = bcy + bry * 0.08
    cv.ellipse(wcx, wcy, brx * 0.74, bry * 0.60, spec.wing, rot: -32)
    cv.ellipse(wcx + 14 * s, wcy + 10 * s, brx * 0.60, bry * 0.46, spec.wing.darker(0.12), rot: -32)
    if spec.barredWing {
        cv.ctx.saveGState()
        let wclip = CGMutablePath()
        wclip.addEllipse(in: CGRect(x: wcx - brx * 0.74, y: wcy - bry * 0.60, width: brx * 1.48, height: bry * 1.20),
                         transform: CGAffineTransform(translationX: wcx, y: wcy)
                             .rotated(by: -32 * .pi / 180)
                             .translatedBy(x: -wcx, y: -wcy))
        cv.ctx.addPath(wclip)
        cv.ctx.clip()
        for k in 0..<5 {
            cv.ellipse(wcx - 30 * s + CGFloat(k) * 28 * s, wcy + 20 * s - CGFloat(k) * 26 * s,
                       90 * s, 12 * s, spec.wingbarC, alpha: 0.9, rot: -32)
        }
        cv.ctx.restoreGState()
    }
    if spec.wingSpots {
        for k in 0..<4 {
            cv.ellipse(wcx - 44 * s + CGFloat(k % 2) * 66 * s, wcy + 30 * s - CGFloat(k / 2) * 62 * s,
                       17 * s, 13 * s, spec.wing.darker(0.5), alpha: 0.85, rot: -20)
        }
    }
    for wb in 0..<spec.wingbars {
        cv.ellipse(wcx - 16 * s + CGFloat(wb) * 40 * s, wcy + 26 * s - CGFloat(wb) * 44 * s,
                   74 * s, 11 * s, spec.wingbarC, alpha: 0.95, rot: -34)
    }
    if let patch = spec.wingPatch {
        cv.ellipse(wcx - brx * 0.34, wcy + bry * 0.34, 52 * s, 34 * s, patch, rot: -24)
        cv.ellipse(wcx - brx * 0.34 + 14 * s, wcy + bry * 0.34 - 22 * s, 44 * s, 12 * s, Col(0xE8C25A), rot: -24)
    }
    if spec.glossy {
        cv.ellipse(bcx - brx * 0.2, bcy + bry * 0.35, brx * 0.5, bry * 0.28, spec.body.lighter(0.35), alpha: 0.35, rot: -14)
    }

    // head
    let hr = 118 * s * spec.headScale
    let hcx = bcx - brx * 0.66
    let hcy = bcy + bry * 0.82
    // crest behind head
    if spec.crest {
        let cc = spec.crestC ?? headC
        cv.poly([
            CGPoint(x: hcx + hr * 0.05, y: hcy + hr * 0.55),
            CGPoint(x: hcx + hr * 0.72, y: hcy + hr * 1.62),
            CGPoint(x: hcx + hr * 0.95, y: hcy + hr * 0.30),
        ], cc)
        cv.poly([
            CGPoint(x: hcx + hr * 0.30, y: hcy + hr * 0.72),
            CGPoint(x: hcx + hr * 1.12, y: hcy + hr * 1.18),
            CGPoint(x: hcx + hr * 1.05, y: hcy + hr * 0.12),
        ], cc.darker(0.10))
    }
    cv.ellipse(hcx, hcy, hr, hr, headC)
    // cheek highlight for chickadee-type: draw white cheek before cap/throat
    if spec.cap != nil && spec.throat != nil && spec.id.contains("hickadee") {
        cv.ellipse(hcx - hr * 0.15, hcy - hr * 0.05, hr * 0.72, hr * 0.62, Col(0xF4F1E8))
    }
    // cap
    if let cap = spec.cap {
        cv.ctx.saveGState()
        let hclip = CGMutablePath()
        hclip.addEllipse(in: CGRect(x: hcx - hr, y: hcy - hr, width: hr * 2, height: hr * 2))
        cv.ctx.addPath(hclip)
        cv.ctx.clip()
        cv.ellipse(hcx, hcy + hr * 0.62, hr * 1.02, hr * 0.62, cap)
        cv.ctx.restoreGState()
    }
    // brow stripe
    if let brow = spec.brow {
        cv.ellipse(hcx - hr * 0.28, hcy + hr * 0.34, hr * 0.66, hr * 0.14, brow, rot: -8)
    }
    // mask through eye
    if let mask = spec.mask {
        cv.ctx.saveGState()
        let hclip = CGMutablePath()
        hclip.addEllipse(in: CGRect(x: hcx - hr, y: hcy - hr, width: hr * 2, height: hr * 2))
        cv.ctx.addPath(hclip)
        cv.ctx.clip()
        cv.ellipse(hcx - hr * 0.30, hcy + hr * 0.12, hr * 0.78, hr * 0.26, mask, rot: -6)
        cv.ctx.restoreGState()
    }
    // throat patch
    if let th = spec.throat {
        cv.ctx.saveGState()
        let hclip = CGMutablePath()
        hclip.addEllipse(in: CGRect(x: hcx - hr, y: hcy - hr, width: hr * 2, height: hr * 2))
        cv.ctx.addPath(hclip)
        cv.ctx.clip()
        cv.ellipse(hcx - hr * 0.30, hcy - hr * 0.72, hr * 0.72, hr * 0.5, th)
        cv.ctx.restoreGState()
    }
    // nape spot (woodpeckers)
    if let nape = spec.napeSpot {
        cv.ellipse(hcx + hr * 0.55, hcy + hr * 0.60, hr * 0.30, hr * 0.22, nape, rot: 30)
    }

    // beak
    let bx = hcx - hr * 0.92
    let by = hcy + hr * 0.02
    switch spec.beak {
    case .cone:
        cv.poly([CGPoint(x: bx + 20 * s, y: by + 30 * s),
                 CGPoint(x: bx - 66 * s * spec.beakLen, y: by - 2 * s),
                 CGPoint(x: bx + 20 * s, y: by - 34 * s)], spec.beakC)
    case .thin:
        cv.poly([CGPoint(x: bx + 18 * s, y: by + 16 * s),
                 CGPoint(x: bx - 84 * s * spec.beakLen, y: by - 4 * s),
                 CGPoint(x: bx + 18 * s, y: by - 18 * s)], spec.beakC)
    case .chisel:
        cv.poly([CGPoint(x: bx + 18 * s, y: by + 15 * s),
                 CGPoint(x: bx - 108 * s * spec.beakLen, y: by - 1 * s),
                 CGPoint(x: bx + 18 * s, y: by - 17 * s)], spec.beakC)
    case .needle:
        cv.poly([CGPoint(x: bx + 14 * s, y: by + 8 * s),
                 CGPoint(x: bx - 150 * s * spec.beakLen, y: by - 4 * s),
                 CGPoint(x: bx + 14 * s, y: by - 10 * s)], spec.beakC)
    case .stout:
        cv.poly([CGPoint(x: bx + 24 * s, y: by + 36 * s),
                 CGPoint(x: bx - 88 * s * spec.beakLen, y: by - 6 * s),
                 CGPoint(x: bx + 24 * s, y: by - 38 * s)], spec.beakC)
    case .curved:
        cv.path({ p in
            p.move(to: CGPoint(x: bx + 18 * s, y: by + 16 * s))
            p.addQuadCurve(to: CGPoint(x: bx - 92 * s * spec.beakLen, y: by - 22 * s),
                           control: CGPoint(x: bx - 60 * s, y: by + 10 * s))
            p.addQuadCurve(to: CGPoint(x: bx + 18 * s, y: by - 18 * s),
                           control: CGPoint(x: bx - 40 * s, y: by - 18 * s))
            p.closeSubpath()
        }, spec.beakC)
    }

    // eye
    let ex = hcx - hr * 0.34, ey = hcy + hr * 0.22
    if spec.eyeRing { cv.ellipse(ex, ey, 27 * s, 27 * s, Col(0xF2EFE6)) }
    cv.ellipse(ex, ey, 19 * s, 19 * s, spec.eyeC)
    cv.ellipse(ex - 6 * s, ey + 6 * s, 6 * s, 6 * s, Col(0xFFFFFF), alpha: 0.9)

    // grain
    cv.grain(seed: seedFor(spec.id) ^ 0xABCD, alpha: 0.09, block: 3)
    return cv
}

// MARK: - Species art table
func buildSpecs() -> [BirdSpec] {
    var out: [BirdSpec] = []
    // ---- Songbirds & Thrushes (7)
    out.append(BirdSpec(id: "northernCardinal", group: "songbirds", body: Col(0xC8102E), breast: Col(0xD93A44), wing: Col(0xA30D24),
                        mask: Col(0x2B1A17), beak: .cone, beakC: Col(0xE8823C), crest: true, crestC: Col(0xB80E28)))
    out.append(BirdSpec(id: "americanRobin", group: "songbirds", body: Col(0x6B655C), breast: Col(0xD96C34), wing: Col(0x59544C),
                        head: Col(0x46423C), beak: .thin, beakC: Col(0xE3B33C), eyeRing: true))
    out.append(BirdSpec(id: "easternBluebird", group: "songbirds", body: Col(0x3B78C2), breast: Col(0xC56B3F), wing: Col(0x2E62A8),
                        belly: Col(0xF0EBDD), beak: .thin))
    out.append(BirdSpec(id: "northernMockingbird", group: "songbirds", body: Col(0x9A968E), breast: Col(0xD3CFC5), wing: Col(0x767268),
                        beak: .thin, tailLen: 1.45, wingbars: 2))
    out.append(BirdSpec(id: "cedarWaxwing", group: "songbirds", body: Col(0xB9995F), breast: Col(0xC7A96E), wing: Col(0x9A7F50),
                        mask: Col(0x231C18), belly: Col(0xE0D07A), beak: .thin, beakC: Col(0x2E2620),
                        crest: true, crestC: Col(0xAE8F58)))
    out.append(BirdSpec(id: "grayCatbird", group: "songbirds", body: Col(0x6E6E76), breast: Col(0x7C7C84), wing: Col(0x5C5C64),
                        cap: Col(0x26242A), beak: .thin, tailLen: 1.3))
    out.append(BirdSpec(id: "brownThrasher", group: "songbirds", body: Col(0xA8552F), breast: Col(0xE8D9B8), wing: Col(0x94481F),
                        beak: .curved, tailLen: 1.55, wingbars: 2, streaks: true, eyeC: Col(0xD9A63C)))
    // ---- Chickadees, Wrens & Nuthatches (6)
    out.append(BirdSpec(id: "blackcappedChickadee", group: "littleBirds", body: Col(0xCBBFA6), breast: Col(0xE4DBC6), wing: Col(0x8A8578),
                        head: Col(0xF4F1E8), cap: Col(0x26242A), throat: Col(0x26242A), beak: .thin, scale: 0.78, beakLen: 0.5))
    out.append(BirdSpec(id: "tuftedTitmouse", group: "littleBirds", body: Col(0x9A93A0), breast: Col(0xE9E4D8), wing: Col(0x837C8A),
                        belly: Col(0xE0C0A0), beak: .thin, scale: 0.85, beakLen: 0.55, crest: true, crestC: Col(0x8D8694)))
    out.append(BirdSpec(id: "carolinaWren", group: "littleBirds", body: Col(0xA5683C), breast: Col(0xD9B183), wing: Col(0x8F5730),
                        brow: Col(0xF2EDE0), beak: .curved, scale: 0.8, beakLen: 0.8, tailLen: 0.9, tailUp: true))
    out.append(BirdSpec(id: "houseWren", group: "littleBirds", body: Col(0x8F6B4C), breast: Col(0xC3A379), wing: Col(0x7A5A3E),
                        beak: .thin, scale: 0.74, beakLen: 0.7, tailLen: 0.8, tailUp: true))
    out.append(BirdSpec(id: "whitebreastedNuthatch", group: "littleBirds", body: Col(0x7C93A8), breast: Col(0xF2EFE6), wing: Col(0x66809A),
                        head: Col(0xF2EFE6), cap: Col(0x24242C), beak: .chisel, scale: 0.82, beakLen: 0.7, tailLen: 0.6))
    out.append(BirdSpec(id: "redbreastedNuthatch", group: "littleBirds", body: Col(0x7C93A8), breast: Col(0xC77E4A), wing: Col(0x66809A),
                        head: Col(0xE9E4D8), cap: Col(0x24242C), mask: Col(0x24242C), beak: .chisel, scale: 0.72, beakLen: 0.55, tailLen: 0.55))
    // ---- Finches & Buntings (7)
    out.append(BirdSpec(id: "americanGoldfinch", group: "finches", body: Col(0xE8C821), breast: Col(0xF2D944), wing: Col(0x2A2822),
                        cap: Col(0x2A2822), beak: .cone, beakC: Col(0xD98E6B), scale: 0.78, beakLen: 0.6, wingbars: 2))
    out.append(BirdSpec(id: "houseFinch", group: "finches", body: Col(0x9C7B5C), breast: Col(0xC24E4E), wing: Col(0x84674C),
                        head: Col(0xB05050), beak: .cone, scale: 0.82, beakLen: 0.7, streaks: true))
    out.append(BirdSpec(id: "purpleFinch", group: "finches", body: Col(0xA6486B), breast: Col(0xC06283), wing: Col(0x7C4A56),
                        beak: .cone, scale: 0.82, beakLen: 0.7))
    out.append(BirdSpec(id: "pineSiskin", group: "finches", body: Col(0x9C8A66), breast: Col(0xC9BC96), wing: Col(0x7E6E50),
                        beak: .thin, scale: 0.74, beakLen: 0.6, wingbars: 1, wingbarC: Col(0xE0D07A), streaks: true))
    out.append(BirdSpec(id: "indigoBunting", group: "finches", body: Col(0x3A54C4), breast: Col(0x4A66D4), wing: Col(0x2C3F9E),
                        head: Col(0x2F46B8), beak: .cone, beakC: Col(0x8C8C94), scale: 0.78, beakLen: 0.6))
    out.append(BirdSpec(id: "rosebreastedGrosbeak", group: "finches", body: Col(0x2A2830), breast: Col(0xF0EBDD), wing: Col(0x1E1C24),
                        throat: Col(0xC42248), belly: Col(0xF0EBDD), beak: .stout, beakC: Col(0xE7DFC8), beakLen: 0.7, wingbars: 1))
    out.append(BirdSpec(id: "eveningGrosbeak", group: "finches", body: Col(0xC9A22E), breast: Col(0xD9B33C), wing: Col(0x2A2822),
                        head: Col(0x5C4A28), brow: Col(0xE8C821), beak: .stout, beakC: Col(0xD9E0B0), beakLen: 0.7, wingbars: 1))
    // ---- Sparrows & Juncos (7)
    out.append(BirdSpec(id: "songSparrow", group: "sparrows", body: Col(0x8A6A4A), breast: Col(0xE4D6BE), wing: Col(0x75573A),
                        brow: Col(0xB8B0A0), beak: .cone, scale: 0.8, beakLen: 0.6, streaks: true, breastSpot: true))
    out.append(BirdSpec(id: "whitethroatedSparrow", group: "sparrows", body: Col(0x8A6A4A), breast: Col(0xB0AA9A), wing: Col(0x75573A),
                        cap: Col(0x33302C), brow: Col(0xF2EDE0), throat: Col(0xF2EDE0), beak: .cone, scale: 0.8, beakLen: 0.6))
    out.append(BirdSpec(id: "whitecrownedSparrow", group: "sparrows", body: Col(0x9C8E78), breast: Col(0xB8B0A0), wing: Col(0x82705A),
                        cap: Col(0xF2EDE0), mask: Col(0x33302C), beak: .cone, beakC: Col(0xD9A05C), scale: 0.82, beakLen: 0.6))
    out.append(BirdSpec(id: "chippingSparrow", group: "sparrows", body: Col(0x9C8E78), breast: Col(0xC5BDAD), wing: Col(0x82705A),
                        cap: Col(0xA8552F), mask: Col(0x33302C), brow: Col(0xF2EDE0), beak: .cone, scale: 0.72, beakLen: 0.55))
    out.append(BirdSpec(id: "houseSparrow", group: "sparrows", body: Col(0x9C7B5C), breast: Col(0xB8B0A0), wing: Col(0x84674C),
                        cap: Col(0x8C8C94), throat: Col(0x33302C), beak: .cone, scale: 0.8, beakLen: 0.6))
    out.append(BirdSpec(id: "darkeyedJunco", group: "sparrows", body: Col(0x5C5A64), breast: Col(0x6E6C76), wing: Col(0x4C4A54),
                        belly: Col(0xF0EBDD), beak: .cone, beakC: Col(0xE0C8B0), scale: 0.78, beakLen: 0.55, tailLen: 0.9))
    out.append(BirdSpec(id: "easternTowhee", group: "sparrows", body: Col(0x2A2830), breast: Col(0xC26534), wing: Col(0x1E1C24),
                        belly: Col(0xF0EBDD), beak: .cone, scale: 0.9, tailLen: 1.2, eyeC: Col(0xB03A2A)))
    // ---- Woodpeckers (6)
    out.append(BirdSpec(id: "downyWoodpecker", group: "woodpeckers", body: Col(0xEFEBE0), breast: Col(0xF6F3EA), wing: Col(0x2A2830),
                        cap: Col(0x2A2830), beak: .chisel, scale: 0.78, beakLen: 0.55, napeSpot: Col(0xC8102E), barredWing: true))
    out.append(BirdSpec(id: "hairyWoodpecker", group: "woodpeckers", body: Col(0xEFEBE0), breast: Col(0xF6F3EA), wing: Col(0x2A2830),
                        cap: Col(0x2A2830), beak: .chisel, scale: 0.92, beakLen: 1.0, napeSpot: Col(0xC8102E), barredWing: true))
    out.append(BirdSpec(id: "redbelliedWoodpecker", group: "woodpeckers", body: Col(0xD9CDB4), breast: Col(0xE4DAC4), wing: Col(0x3A3834),
                        cap: Col(0xC8102E), beak: .chisel, scale: 0.95, beakLen: 0.95, napeSpot: Col(0xC8102E), barredWing: true))
    out.append(BirdSpec(id: "northernFlicker", group: "woodpeckers", body: Col(0xB09270), breast: Col(0xD3C0A0), wing: Col(0x96795C),
                        head: Col(0x9C9C9C), throat: Col(0x33302C), beak: .curved, beakLen: 0.9, napeSpot: Col(0xC8102E),
                        wingSpots: true))
    out.append(BirdSpec(id: "pileatedWoodpecker", group: "woodpeckers", body: Col(0x2A2830), breast: Col(0x3A3840), wing: Col(0x1E1C24),
                        head: Col(0xEFEBE0), mask: Col(0x2A2830), beak: .chisel, scale: 1.05, beakLen: 1.1,
                        crest: true, crestC: Col(0xC8102E)))
    out.append(BirdSpec(id: "yellowbelliedSapsucker", group: "woodpeckers", body: Col(0xD9CDB4), breast: Col(0xE0D07A), wing: Col(0x2A2830),
                        cap: Col(0xC8102E), mask: Col(0x2A2830), throat: Col(0xC8102E), beak: .chisel, scale: 0.85, beakLen: 0.7, barredWing: true))
    // ---- Jays, Doves & Visitors (7)
    out.append(BirdSpec(id: "blueJay", group: "jays", body: Col(0x3E6FC4), breast: Col(0xD9D5CB), wing: Col(0x2E58A8),
                        head: Col(0x4A7ACC), throat: Col(0x33302C), beak: .stout, beakLen: 0.6, tailLen: 1.3,
                        crest: true, crestC: Col(0x3E6FC4), wingbars: 2))
    out.append(BirdSpec(id: "americanCrow", group: "jays", body: Col(0x26262E), breast: Col(0x30303A), wing: Col(0x1C1C24),
                        beak: .stout, beakC: Col(0x1C1C24), scale: 1.08, glossy: true))
    out.append(BirdSpec(id: "commonGrackle", group: "jays", body: Col(0x3A3230), breast: Col(0x46372E), wing: Col(0x2A2320),
                        head: Col(0x3E3E7E), beak: .thin, beakLen: 0.9, tailLen: 1.4, eyeC: Col(0xE0D07A), glossy: true))
    out.append(BirdSpec(id: "redwingedBlackbird", group: "jays", body: Col(0x26262E), breast: Col(0x30303A), wing: Col(0x1C1C24),
                        beak: .thin, beakLen: 0.85, wingPatch: Col(0xC8102E)))
    out.append(BirdSpec(id: "baltimoreOriole", group: "jays", body: Col(0xE8862B), breast: Col(0xF0973A), wing: Col(0x26242A),
                        head: Col(0x26242A), beak: .thin, beakLen: 0.8, wingbars: 1))
    out.append(BirdSpec(id: "mourningDove", group: "jays", body: Col(0xB39C82), breast: Col(0xCBB093), wing: Col(0x9E8870),
                        beak: .thin, headScale: 0.72, beakLen: 0.6, tailLen: 1.5, eyeRing: true, wingSpots: true))
    out.append(BirdSpec(id: "rubythroatedHummingbird", group: "jays", body: Col(0x3E8E5A), breast: Col(0xE9E4D8), wing: Col(0x2E7048),
                        throat: Col(0xC41E3A), beak: .needle, scale: 0.6, tailLen: 0.7))
    return out
}

// MARK: - Group banner
func drawBanner(groupId: String, title: String) -> Canvas {
    let cv = Canvas(1600, 900)
    var rng = PorchRNG(seed: seedFor("banner-" + groupId))
    let (bgTop, bgBot, accent) = groupBG[groupId]!
    cv.vGradient(bgTop.darker(0.02), bgBot)
    // big soft arcs
    for k in 0..<3 {
        let r = CGFloat(560 - k * 130)
        cv.ellipse(1280, 220, r, r, accent, alpha: 0.16 + CGFloat(k) * 0.06)
    }
    // feather motifs
    for _ in 0..<7 {
        let x = CGFloat(rng.d(80, 1520))
        let y = CGFloat(rng.d(80, 820))
        let len = CGFloat(rng.d(90, 190))
        let ang = CGFloat(rng.d(-40, 40)) * .pi / 180
        let c = accent.darker(CGFloat(rng.d(0.05, 0.25)))
        cv.ctx.saveGState()
        cv.ctx.translateBy(x: x, y: y)
        cv.ctx.rotate(by: ang)
        cv.path({ p in
            p.move(to: CGPoint(x: 0, y: -len / 2))
            p.addQuadCurve(to: CGPoint(x: 0, y: len / 2), control: CGPoint(x: len * 0.42, y: 0))
            p.addQuadCurve(to: CGPoint(x: 0, y: -len / 2), control: CGPoint(x: -len * 0.42, y: 0))
        }, c, alpha: 0.30)
        cv.stroke(CGPoint(x: 0, y: -len / 2), CGPoint(x: 0, y: len / 2), c.darker(0.2), width: 3, alpha: 0.35)
        cv.ctx.restoreGState()
    }
    // sparkle dots
    for _ in 0..<26 {
        let x = CGFloat(rng.d(40, 1560)), y = CGFloat(rng.d(40, 860))
        let r = CGFloat(rng.d(3, 10))
        cv.ellipse(x, y, r, r, Col(0xFFFFFF), alpha: CGFloat(rng.d(0.15, 0.4)))
    }
    cv.grain(seed: seedFor("banner-" + groupId) ^ 0xEF, alpha: 0.08, block: 2)
    return cv
}

// MARK: - App icon (abstract emblem, opaque)
func drawIcon() -> Canvas {
    let cv = Canvas(1024, 1024)
    // radial-ish background: cream to sage
    let bgTop = Col(0xF2EEDF), bgBot = Col(0xC9D6BC)
    cv.vGradient(bgTop, bgBot)
    cv.ellipse(512, 560, 430, 430, Col(0xDCE4CC), alpha: 0.7)
    // amber disc emblem
    cv.ellipse(512, 512, 285, 285, Col(0xB98A3A), alpha: 0.30)   // soft shadow ring
    cv.ellipse(512, 522, 262, 262, Col(0xE3A94C))
    cv.ellipse(512, 522, 262, 262, Col(0xD69A3C), alpha: 0.0)
    cv.ellipse(512, 530, 236, 236, Col(0xEDB65C))
    // inner teal ring
    cv.ctx.setStrokeColor(Col(0x4E7D6A).cg(0.85))
    cv.ctx.setLineWidth(16)
    cv.ctx.strokeEllipse(in: CGRect(x: 512 - 190, y: 530 - 190, width: 380, height: 380))
    // inner soft highlight
    cv.ellipse(452, 610, 120, 90, Col(0xF6D08A), alpha: 0.75, rot: -20)
    // sparkles
    for (sx, sy, sr) in [(300.0, 790.0, 16.0), (760.0, 740.0, 11.0), (720.0, 300.0, 14.0)] {
        let c = Col(0xF6E7C2)
        cv.poly([CGPoint(x: sx, y: sy + sr * 2.2), CGPoint(x: sx + sr * 0.55, y: sy + sr * 0.55),
                 CGPoint(x: sx + sr * 2.2, y: sy), CGPoint(x: sx + sr * 0.55, y: sy - sr * 0.55),
                 CGPoint(x: sx, y: sy - sr * 2.2), CGPoint(x: sx - sr * 0.55, y: sy - sr * 0.55),
                 CGPoint(x: sx - sr * 2.2, y: sy), CGPoint(x: sx - sr * 0.55, y: sy + sr * 0.55)], c, alpha: 0.9)
    }
    return cv
}

// MARK: - Main
let args = CommandLine.arguments
guard args.count >= 2 else {
    print("usage: birdgen <outDir> [sample|birds|banners|icon|all]")
    exit(1)
}
let outDir = URL(fileURLWithPath: args[1])
let mode = args.count > 2 ? args[2] : "all"
try? FileManager.default.createDirectory(at: outDir, withIntermediateDirectories: true)

let specs = buildSpecs()
let sampleIds = ["northernCardinal", "blackcappedChickadee", "americanGoldfinch", "downyWoodpecker", "mourningDove"]

if mode == "sample" {
    for spec in specs where sampleIds.contains(spec.id) {
        let cv = drawBird(spec)
        cv.write(outDir.appendingPathComponent("bird_\(spec.id).png"))
        print("wrote bird_\(spec.id).png")
    }
} else {
    if mode == "birds" || mode == "all" {
        for spec in specs {
            let cv = drawBird(spec)
            cv.write(outDir.appendingPathComponent("bird_\(spec.id).png"))
            print("wrote bird_\(spec.id).png")
        }
    }
    if mode == "banners" || mode == "all" {
        let titles = ["songbirds": "Songbirds", "littleBirds": "Little Acrobats", "finches": "Finches",
                      "sparrows": "Sparrows", "woodpeckers": "Woodpeckers", "jays": "Jays & Visitors"]
        for (gid, title) in titles {
            let cv = drawBanner(groupId: gid, title: title)
            cv.write(outDir.appendingPathComponent("banner_\(gid).png"))
            print("wrote banner_\(gid).png")
        }
    }
    if mode == "icon" || mode == "all" {
        let cv = drawIcon()
        cv.write(outDir.appendingPathComponent("AppIcon-1024.png"))
        print("wrote AppIcon-1024.png")
    }
}
print("done")
