import SwiftUI

// Milestone badges computed live from store data — nothing extra to persist.
struct AviaryBadge: Identifiable {
    let id: String
    let title: String
    let detail: String
    let icon: BadgeIconKind
    let tint: Color
    let isEarned: (BirdStore) -> Bool
    let progress: (BirdStore) -> (current: Int, goal: Int)
}

enum BadgeIconKind {
    case feather, egg, nest, star, ring, sun, leaf, drop
}

enum BadgeKit {
    static let all: [AviaryBadge] = [
        AviaryBadge(
            id: "firstLifer",
            title: "First Lifer",
            detail: "Log your very first bird sighting.",
            icon: .egg, tint: Aviary.sage,
            isEarned: { !$0.sightings.isEmpty },
            progress: { (min($0.sightings.count, 1), 1) }
        ),
        AviaryBadge(
            id: "five",
            title: "Backyard Five",
            detail: "Spot 5 different species.",
            icon: .feather, tint: Aviary.amberDeep,
            isEarned: { $0.spottedSpeciesIds.count >= 5 },
            progress: { (min($0.spottedSpeciesIds.count, 5), 5) }
        ),
        AviaryBadge(
            id: "ten",
            title: "Ten Up",
            detail: "Spot 10 different species.",
            icon: .feather, tint: Aviary.terracotta,
            isEarned: { $0.spottedSpeciesIds.count >= 10 },
            progress: { (min($0.spottedSpeciesIds.count, 10), 10) }
        ),
        AviaryBadge(
            id: "twenty",
            title: "Serious Lister",
            detail: "Spot 20 different species.",
            icon: .star, tint: Aviary.forest,
            isEarned: { $0.spottedSpeciesIds.count >= 20 },
            progress: { (min($0.spottedSpeciesIds.count, 20), 20) }
        ),
        AviaryBadge(
            id: "thirty",
            title: "Yard Expert",
            detail: "Spot 30 different species.",
            icon: .star, tint: Aviary.sky,
            isEarned: { $0.spottedSpeciesIds.count >= 30 },
            progress: { (min($0.spottedSpeciesIds.count, 30), 30) }
        ),
        AviaryBadge(
            id: "fullGuide",
            title: "The Full Guide",
            detail: "Spot all 40 species in the guide.",
            icon: .ring, tint: Aviary.amber,
            isEarned: { $0.spottedSpeciesIds.count >= SpeciesData.all.count },
            progress: { (min($0.spottedSpeciesIds.count, SpeciesData.all.count), SpeciesData.all.count) }
        ),
        AviaryBadge(
            id: "explorer",
            title: "Explorer",
            detail: "Log sightings in 3 different places.",
            icon: .leaf, tint: Aviary.sage,
            isEarned: { $0.distinctPlaces.count >= 3 },
            progress: { (min($0.distinctPlaces.count, 3), 3) }
        ),
        AviaryBadge(
            id: "wanderer",
            title: "Wanderer",
            detail: "Log sightings in 10 different places.",
            icon: .leaf, tint: Aviary.forest,
            isEarned: { $0.distinctPlaces.count >= 10 },
            progress: { (min($0.distinctPlaces.count, 10), 10) }
        ),
        AviaryBadge(
            id: "journal25",
            title: "Field Journal",
            detail: "Log 25 sightings in total.",
            icon: .nest, tint: Aviary.amberDeep,
            isEarned: { $0.sightings.count >= 25 },
            progress: { (min($0.sightings.count, 25), 25) }
        ),
        AviaryBadge(
            id: "journal100",
            title: "Century Watch",
            detail: "Log 100 sightings in total.",
            icon: .nest, tint: Aviary.terracotta,
            isEarned: { $0.sightings.count >= 100 },
            progress: { (min($0.sightings.count, 100), 100) }
        ),
        AviaryBadge(
            id: "earlyBird",
            title: "Early Bird",
            detail: "Log a sighting dated before 8 AM.",
            icon: .sun, tint: Aviary.amber,
            isEarned: { store in
                store.sightings.contains { Calendar.current.component(.hour, from: $0.date) < 8 }
            },
            progress: { store in
                (store.sightings.contains { Calendar.current.component(.hour, from: $0.date) < 8 } ? 1 : 0, 1)
            }
        ),
        AviaryBadge(
            id: "allGroups",
            title: "Six of Six",
            detail: "Spot at least one bird from every group.",
            icon: .ring, tint: Aviary.forestDeep,
            isEarned: { store in
                BirdGroupKind.allCases.allSatisfy { store.spottedCount(in: $0) > 0 }
            },
            progress: { store in
                (BirdGroupKind.allCases.filter { store.spottedCount(in: $0) > 0 }.count, BirdGroupKind.allCases.count)
            }
        ),
        AviaryBadge(
            id: "quizAce",
            title: "Quiz Ace",
            detail: "Score a perfect 10 on the Bird ID Quiz.",
            icon: .star, tint: Aviary.rose,
            isEarned: { $0.quizBestScore >= 10 },
            progress: { (min($0.quizBestScore, 10), 10) }
        ),
        AviaryBadge(
            id: "quizFan",
            title: "Quiz Regular",
            detail: "Finish 5 quiz rounds.",
            icon: .drop, tint: Aviary.sky,
            isEarned: { $0.quizRunsCompleted >= 5 },
            progress: { (min($0.quizRunsCompleted, 5), 5) }
        ),
        AviaryBadge(
            id: "bookworm",
            title: "Field Scholar",
            detail: "Read all 8 birding tip guides.",
            icon: .leaf, tint: Aviary.amberDeep,
            isEarned: { $0.readTipIds.count >= SpeciesDataB.tips.count },
            progress: { (min($0.readTipIds.count, SpeciesDataB.tips.count), SpeciesDataB.tips.count) }
        ),
        AviaryBadge(
            id: "flockCounter",
            title: "Flock Counter",
            detail: "Count 100 individual birds across all sightings.",
            icon: .feather, tint: Aviary.forest,
            isEarned: { $0.totalBirdsCounted >= 100 },
            progress: { (min($0.totalBirdsCounted, 100), 100) }
        ),
    ]

    static func earned(in store: BirdStore) -> [AviaryBadge] {
        all.filter { $0.isEarned(store) }
    }
}
