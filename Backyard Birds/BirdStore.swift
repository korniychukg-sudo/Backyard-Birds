import SwiftUI

// Local-only persistence: sightings + progress live as JSON in UserDefaults.
final class BirdStore: ObservableObject {
    @Published private(set) var sightings: [BirdSighting] = []
    @Published private(set) var quizBestScore: Int = 0
    @Published private(set) var quizRunsCompleted: Int = 0
    @Published private(set) var onboardingSeen: Bool = false
    @Published private(set) var readTipIds: Set<String> = []

    private let sightingsKey = "aviary.sightings.v1"
    private let quizBestKey = "aviary.quizBest.v1"
    private let quizRunsKey = "aviary.quizRuns.v1"
    private let onboardingKey = "aviary.onboardingSeen.v1"
    private let readTipsKey = "aviary.readTips.v1"

    init() {
        load()
    }

    // MARK: - Derived

    var sightingsNewestFirst: [BirdSighting] {
        sightings.sorted { $0.date == $1.date ? $0.createdAt > $1.createdAt : $0.date > $1.date }
    }

    var spottedSpeciesIds: Set<String> {
        Set(sightings.map { $0.speciesId })
    }

    func isSpotted(_ speciesId: String) -> Bool {
        spottedSpeciesIds.contains(speciesId)
    }

    /// First (earliest-dated) sighting per species.
    func firstSighting(of speciesId: String) -> BirdSighting? {
        sightings
            .filter { $0.speciesId == speciesId }
            .min { $0.date == $1.date ? $0.createdAt < $1.createdAt : $0.date < $1.date }
    }

    func sightings(of speciesId: String) -> [BirdSighting] {
        sightingsNewestFirst.filter { $0.speciesId == speciesId }
    }

    var distinctPlaces: [String] {
        var seen = Set<String>()
        var out: [String] = []
        for s in sightingsNewestFirst {
            let trimmed = s.place.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }
            let key = trimmed.lowercased()
            if !seen.contains(key) {
                seen.insert(key)
                out.append(trimmed)
            }
        }
        return out
    }

    func spottedCount(in group: BirdGroupKind) -> Int {
        let ids = Set(SpeciesData.inGroup(group).map { $0.id })
        return ids.intersection(spottedSpeciesIds).count
    }

    var totalBirdsCounted: Int {
        sightings.reduce(0) { $0 + $1.count }
    }

    /// Sightings per calendar month (1...12) across all years.
    var sightingsByMonth: [Int] {
        var counts = Array(repeating: 0, count: 12)
        let cal = Calendar.current
        for s in sightings {
            let m = cal.component(.month, from: s.date)
            counts[m - 1] += 1
        }
        return counts
    }

    // MARK: - Mutations

    func addSighting(_ sighting: BirdSighting) {
        sightings.append(sighting)
        save()
    }

    func updateSighting(_ sighting: BirdSighting) {
        guard let idx = sightings.firstIndex(where: { $0.id == sighting.id }) else { return }
        sightings[idx] = sighting
        save()
    }

    func deleteSighting(id: UUID) {
        sightings.removeAll { $0.id == id }
        save()
    }

    func recordQuizRun(score: Int) {
        quizRunsCompleted += 1
        if score > quizBestScore { quizBestScore = score }
        savePrefs()
    }

    func markOnboardingSeen() {
        onboardingSeen = true
        savePrefs()
    }

    func markTipRead(_ id: String) {
        readTipIds.insert(id)
        savePrefs()
    }

    func resetAll() {
        sightings = []
        quizBestScore = 0
        quizRunsCompleted = 0
        readTipIds = []
        save()
        savePrefs()
    }

    // MARK: - Persistence

    private func load() {
        let d = UserDefaults.standard
        if let data = d.data(forKey: sightingsKey),
           let decoded = try? JSONDecoder().decode([BirdSighting].self, from: data) {
            sightings = decoded
        }
        quizBestScore = d.integer(forKey: quizBestKey)
        quizRunsCompleted = d.integer(forKey: quizRunsKey)
        onboardingSeen = d.bool(forKey: onboardingKey)
        if let arr = d.array(forKey: readTipsKey) as? [String] {
            readTipIds = Set(arr)
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(sightings) {
            UserDefaults.standard.set(data, forKey: sightingsKey)
        }
    }

    private func savePrefs() {
        let d = UserDefaults.standard
        d.set(quizBestScore, forKey: quizBestKey)
        d.set(quizRunsCompleted, forKey: quizRunsKey)
        d.set(onboardingSeen, forKey: onboardingKey)
        d.set(Array(readTipIds), forKey: readTipsKey)
    }
}

// MARK: - Bird of the Day

extension BirdStore {
    /// Deterministic date-rotated pick from the full guide.
    static func birdOfTheDay(on date: Date = Date()) -> BirdSpecies {
        let all = SpeciesData.all
        let cal = Calendar.current
        let day = cal.ordinality(of: .day, in: .era, for: date) ?? 0
        return all[day % all.count]
    }
}
