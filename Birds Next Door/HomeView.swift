import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: BirdStore
    @State private var showAddSighting = false

    private var month: Int { Calendar.current.component(.month, from: Date()) }
    private var bird: BirdSpecies { BirdStore.birdOfTheDay() }

    private var inSeasonNow: [BirdSpecies] {
        SpeciesData.activeIn(month: month)
            .filter { !$0.isYearRound }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                birdOfTheDayCard

                progressCard

                if !inSeasonNow.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(
                            title: "In Season Now",
                            subtitle: "Seasonal visitors to watch for in \(AviaryFormat.monthName(month))"
                        )
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(inSeasonNow) { s in
                                    NavigationLink(destination: SpeciesDetailView(species: s)) {
                                        SeasonMiniCard(species: s, spotted: store.isSpotted(s.id))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                    }
                }

                recentSightings

                badgesPreview
            }
            .padding(16)
            .aviaryContentWidth()
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddSighting) {
            AddSightingView()
                .environmentObject(store)
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(AviaryFormat.weekdayDay.string(from: Date()))
                    .font(Aviary.body(13, .semibold))
                    .foregroundColor(Aviary.inkSoft)
                Text("Birds Next Door")
                    .font(Aviary.title(30))
                    .foregroundColor(Aviary.ink)
            }
            Spacer()
            Button {
                showAddSighting = true
            } label: {
                HStack(spacing: 6) {
                    PlusIcon(size: 12, color: .white)
                    Text("Log")
                        .font(Aviary.body(14, .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Capsule().fill(Aviary.forest))
            }
            .buttonStyle(.plain)
        }
    }

    private var birdOfTheDayCard: some View {
        NavigationLink(destination: SpeciesDetailView(species: bird)) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    BirdArtView(name: bird.artName, cornerRadius: 0)
                        .frame(height: 210)
                        .clipped()
                    AviaryChip(text: "Bird of the Day", color: Aviary.amberDeep, filled: true)
                        .padding(12)
                }
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(bird.name)
                            .font(Aviary.title(19))
                            .foregroundColor(Aviary.ink)
                        Text(bird.latin)
                            .font(Aviary.body(13).italic())
                            .foregroundColor(Aviary.inkSoft)
                    }
                    Spacer()
                    if store.isSpotted(bird.id) {
                        SpottedBadge()
                    } else {
                        ChevronIcon(direction: .right, size: 14)
                    }
                }
                .padding(14)
                .background(Aviary.card)
            }
            .clipShape(RoundedRectangle(cornerRadius: Aviary.corner, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var progressCard: some View {
        let total = SpeciesData.all.count
        let spotted = store.spottedSpeciesIds.count
        return HStack(spacing: 18) {
            ZStack {
                ProgressRing(
                    progress: Double(spotted) / Double(total),
                    lineWidth: 9, size: 84
                )
                VStack(spacing: 0) {
                    Text("\(spotted)")
                        .font(Aviary.title(24))
                        .foregroundColor(Aviary.forest)
                    Text("of \(total)")
                        .font(Aviary.body(11))
                        .foregroundColor(Aviary.inkSoft)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Life List Progress")
                    .font(Aviary.title(17))
                    .foregroundColor(Aviary.ink)
                Text(progressLine(spotted: spotted, total: total))
                    .font(Aviary.body(13))
                    .foregroundColor(Aviary.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .aviaryCard()
    }

    private func progressLine(spotted: Int, total: Int) -> String {
        switch spotted {
        case 0: return "Your life list is waiting for its first bird. Step outside and look up."
        case 1..<5: return "A great start! Every new species from here is a lifer."
        case 5..<15: return "The yard regulars are falling into place. Keep watching."
        case 15..<30: return "Impressive coverage — the uncommon visitors are next."
        case 30..<total: return "You are closing in on the complete guide!"
        default: return "The complete guide — every species spotted. Remarkable."
        }
    }

    private var recentSightings: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Recent Sightings")
            if store.sightings.isEmpty {
                VStack(spacing: 10) {
                    Text("Nothing logged yet")
                        .font(Aviary.body(15, .semibold))
                        .foregroundColor(Aviary.ink)
                    Text("Tap Log to record your first bird — the date, the place, and the moment.")
                        .font(Aviary.body(13))
                        .foregroundColor(Aviary.inkSoft)
                        .multilineTextAlignment(.center)
                    Button("Log a Sighting") { showAddSighting = true }
                        .buttonStyle(SoftButtonStyle())
                        .frame(maxWidth: 220)
                }
                .frame(maxWidth: .infinity)
                .aviaryCard()
            } else {
                VStack(spacing: 10) {
                    ForEach(Array(store.sightingsNewestFirst.prefix(3))) { s in
                        SightingRow(sighting: s)
                    }
                }
            }
        }
    }

    private var badgesPreview: some View {
        let earned = BadgeKit.earned(in: store)
        return VStack(alignment: .leading, spacing: 10) {
            SectionHeader(
                title: "Badges",
                subtitle: earned.isEmpty
                    ? "Milestones you unlock as your list grows"
                    : "\(earned.count) of \(BadgeKit.all.count) earned"
            )
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(BadgeKit.all.prefix(8)) { badge in
                        let isEarned = badge.isEarned(store)
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(isEarned ? badge.tint.opacity(0.16) : Aviary.creamDark)
                                    .frame(width: 54, height: 54)
                                BadgeIconView(kind: badge.icon, size: 24,
                                              color: isEarned ? badge.tint : Aviary.inkSoft.opacity(0.35))
                            }
                            Text(badge.title)
                                .font(Aviary.body(10, .semibold))
                                .foregroundColor(isEarned ? Aviary.ink : Aviary.inkSoft.opacity(0.6))
                                .lineLimit(1)
                        }
                        .frame(width: 72)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

// MARK: - Small pieces

struct SpottedBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            CheckIcon(size: 9, color: .white, weight: 2.2)
            Text("Spotted")
                .font(Aviary.body(11, .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(Capsule().fill(Aviary.sage))
    }
}

struct SeasonMiniCard: View {
    let species: BirdSpecies
    let spotted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                BirdArtView(name: species.artName, cornerRadius: 12)
                    .frame(width: 120, height: 120)
                if spotted {
                    ZStack {
                        Circle().fill(Aviary.sage).frame(width: 22, height: 22)
                        CheckIcon(size: 10, color: .white, weight: 2.2)
                    }
                    .padding(6)
                }
            }
            Text(species.name)
                .font(Aviary.body(12, .semibold))
                .foregroundColor(Aviary.ink)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 120, alignment: .leading)
        }
    }
}

struct SightingRow: View {
    @EnvironmentObject var store: BirdStore
    let sighting: BirdSighting

    private var species: BirdSpecies? { SpeciesData.species(sighting.speciesId) }

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 12) {
                BirdArtView(name: species?.artName ?? "", cornerRadius: 10)
                    .frame(width: 52, height: 52)
                VStack(alignment: .leading, spacing: 3) {
                    Text(species?.name ?? "Unknown bird")
                        .font(Aviary.body(15, .semibold))
                        .foregroundColor(Aviary.ink)
                    HStack(spacing: 5) {
                        CalendarGlyph(size: 11)
                        Text(AviaryFormat.day.string(from: sighting.date))
                            .font(Aviary.body(12))
                            .foregroundColor(Aviary.inkSoft)
                        if !sighting.place.isEmpty {
                            PinGlyph(size: 11)
                            Text(sighting.place)
                                .font(Aviary.body(12))
                                .foregroundColor(Aviary.inkSoft)
                                .lineLimit(1)
                        }
                    }
                }
                Spacer()
                if sighting.count > 1 {
                    AviaryChip(text: "x\(sighting.count)", color: Aviary.amberDeep)
                }
                ChevronIcon(direction: .right, size: 12)
            }
            .aviaryCard(padding: 12)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var destination: some View {
        if let species = species {
            SpeciesDetailView(species: species)
        } else {
            EmptyStateView(title: "Species not found", message: "This sighting refers to a species that is no longer in the guide.")
        }
    }
}
