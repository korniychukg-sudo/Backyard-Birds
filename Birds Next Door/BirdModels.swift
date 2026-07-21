import SwiftUI

// MARK: - Groups

enum BirdGroupKind: String, CaseIterable, Codable, Identifiable {
    case songbirds
    case littleBirds
    case finches
    case sparrows
    case woodpeckers
    case jays

    var id: String { rawValue }

    var title: String {
        switch self {
        case .songbirds: return "Songbirds & Thrushes"
        case .littleBirds: return "Chickadees, Wrens & Nuthatches"
        case .finches: return "Finches & Buntings"
        case .sparrows: return "Sparrows & Juncos"
        case .woodpeckers: return "Woodpeckers"
        case .jays: return "Jays, Doves & Visitors"
        }
    }
    var shortTitle: String {
        switch self {
        case .songbirds: return "Songbirds"
        case .littleBirds: return "Little Acrobats"
        case .finches: return "Finches"
        case .sparrows: return "Sparrows"
        case .woodpeckers: return "Woodpeckers"
        case .jays: return "Jays & Visitors"
        }
    }
    var blurb: String {
        switch self {
        case .songbirds:
            return "The classic voices of the yard — bold, melodic birds that sing from fence posts and treetops."
        case .littleBirds:
            return "Tiny, fearless acrobats that dangle from twigs, cling to bark, and visit feeders in quick raids."
        case .finches:
            return "Seed-cracking specialists with stout bills and cheerful, bouncing flight."
        case .sparrows:
            return "Subtle browns and grays with beautiful patterns — the quiet regulars of brush piles and ground feeders."
        case .woodpeckers:
            return "Bark specialists that drum, chisel, and hitch up trunks in search of insects."
        case .jays:
            return "Big personalities and special guests — from clever corvids to hovering hummingbirds."
        }
    }
    var bannerName: String { "banner_\(rawValue)" }
    var accent: Color {
        switch self {
        case .songbirds: return Aviary.terracotta
        case .littleBirds: return Aviary.sage
        case .finches: return Aviary.amberDeep
        case .sparrows: return Color(hex: 0xA07E52)
        case .woodpeckers: return Color(hex: 0x5E7E8E)
        case .jays: return Aviary.sky
        }
    }
}

// MARK: - Species attributes

enum BirdRarity: String, Codable, CaseIterable {
    case veryCommon
    case common
    case uncommon

    var label: String {
        switch self {
        case .veryCommon: return "Very common"
        case .common: return "Common"
        case .uncommon: return "Uncommon"
        }
    }
    var color: Color {
        switch self {
        case .veryCommon: return Aviary.sage
        case .common: return Aviary.amberDeep
        case .uncommon: return Aviary.terracotta
        }
    }
}

enum BirdSizeClass: String, Codable, CaseIterable {
    case tiny
    case sparrowSized
    case robinSized
    case jaySized
    case crowSized

    var label: String {
        switch self {
        case .tiny: return "Tiny"
        case .sparrowSized: return "Sparrow-sized"
        case .robinSized: return "Robin-sized"
        case .jaySized: return "Jay-sized"
        case .crowSized: return "Crow-sized"
        }
    }
}

enum BirdColorTag: String, Codable, CaseIterable, Identifiable {
    case red, orange, yellow, blue, green, brown, gray, black, white

    var id: String { rawValue }
    var label: String { rawValue.prefix(1).uppercased() + rawValue.dropFirst() }
    var swatch: Color {
        switch self {
        case .red: return Color(hex: 0xC0392B)
        case .orange: return Color(hex: 0xD97B34)
        case .yellow: return Color(hex: 0xD9B33C)
        case .blue: return Color(hex: 0x4A72B0)
        case .green: return Color(hex: 0x4E8E5A)
        case .brown: return Color(hex: 0x8A6A4A)
        case .gray: return Color(hex: 0x8C8C8C)
        case .black: return Color(hex: 0x2E2C30)
        case .white: return Color(hex: 0xF4F1E8)
        }
    }
}

// MARK: - Species

struct BirdSpecies: Identifiable {
    let id: String
    let name: String
    let latin: String
    let group: BirdGroupKind
    let lengthInches: ClosedRange<Double>
    let sizeClass: BirdSizeClass
    let rarity: BirdRarity
    /// Months (1...12) when this bird is typically around a mid-latitude US backyard.
    let months: Set<Int>
    let colors: [BirdColorTag]
    let habitat: String
    let diet: String
    let feederTip: String
    let song: String
    let idTips: [String]
    let behavior: String
    let funFact: String
    let similarIds: [String]

    var artName: String { "bird_\(id)" }
    var isYearRound: Bool { months.count == 12 }

    var seasonLabel: String {
        if isYearRound { return "Year-round" }
        let summer: Set<Int> = [5, 6, 7, 8]
        let winter: Set<Int> = [11, 12, 1, 2]
        if summer.isSubset(of: months) && winter.intersection(months).isEmpty {
            return "Spring & summer"
        }
        if winter.isSubset(of: months) && summer.intersection(months).isEmpty {
            return "Fall & winter"
        }
        return "Seasonal"
    }
    var lengthLabel: String {
        let lo = lengthInches.lowerBound, hi = lengthInches.upperBound
        func fmt(_ v: Double) -> String {
            v == v.rounded() ? String(Int(v)) : String(format: "%.1f", v)
        }
        return "\(fmt(lo))\u{2013}\(fmt(hi)) in"
    }
}

// MARK: - Sightings

struct BirdSighting: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var speciesId: String
    var date: Date
    var place: String
    var count: Int
    var notes: String
    var createdAt: Date = Date()
}

// MARK: - Learn content

struct BirdingTip: Identifiable {
    let id: String
    let title: String
    let summary: String
    let points: [String]
}

struct GlossaryTerm: Identifiable {
    let id: String
    let term: String
    let definition: String
}

// MARK: - Quiz

enum QuizKind {
    case portraitToName      // shown art, pick name
    case nameToFact          // question about a species fact
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let kind: QuizKind
    let prompt: String
    let artName: String?
    let options: [String]
    let correctIndex: Int
    let explanation: String
}
