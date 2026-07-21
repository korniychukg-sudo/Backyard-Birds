import SwiftUI

struct SpeciesDetailView: View {
    @EnvironmentObject var store: BirdStore
    let species: BirdSpecies
    @State private var showAddSighting = false

    private var firstSeen: BirdSighting? { store.firstSighting(of: species.id) }
    private var allSightings: [BirdSighting] { store.sightings(of: species.id) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                hero

                badgesRow

                if let first = firstSeen {
                    lifeListCard(first: first)
                }

                infoSection(title: "How to Identify", accent: Aviary.forest) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(species.idTips.enumerated()), id: \.offset) { pair in
                            HStack(alignment: .top, spacing: 10) {
                                ZStack {
                                    Circle().fill(Aviary.forest.opacity(0.12)).frame(width: 22, height: 22)
                                    Text("\(pair.offset + 1)")
                                        .font(Aviary.body(12, .bold))
                                        .foregroundColor(Aviary.forest)
                                }
                                Text(pair.element)
                                    .font(Aviary.body(14))
                                    .foregroundColor(Aviary.ink)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                infoSection(title: "Listen For", accent: Aviary.terracotta) {
                    detailText(species.song)
                }

                infoSection(title: "Habitat", accent: Aviary.sage) {
                    detailText(species.habitat)
                }

                infoSection(title: "Diet", accent: Aviary.amberDeep) {
                    detailText(species.diet)
                }

                infoSection(title: "At Your Feeder", accent: Aviary.sky) {
                    detailText(species.feederTip)
                }

                infoSection(title: "Behavior", accent: Aviary.forest) {
                    detailText(species.behavior)
                }

                funFactCard

                seasonCard

                similarSection

                if !allSightings.isEmpty {
                    sightingHistory
                }

                Button {
                    showAddSighting = true
                } label: {
                    Text(firstSeen == nil ? "Log First Sighting" : "Log Another Sighting")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 4)
            }
            .padding(16)
            .aviaryContentWidth()
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(species.name)
                    .font(Aviary.body(16, .bold))
                    .foregroundColor(Aviary.ink)
                    .lineLimit(1)
            }
        }
        .sheet(isPresented: $showAddSighting) {
            AddSightingView(preselectedSpeciesId: species.id)
                .environmentObject(store)
        }
    }

    // MARK: - Pieces

    private var hero: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                BirdArtView(name: species.artName, cornerRadius: 0)
                    .frame(height: 250)
                    .clipped()
                if firstSeen != nil {
                    SpottedBadge()
                        .padding(12)
                }
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(species.name)
                    .font(Aviary.title(24))
                    .foregroundColor(Aviary.ink)
                Text(species.latin)
                    .font(Aviary.body(14).italic())
                    .foregroundColor(Aviary.inkSoft)
                Text(species.group.title)
                    .font(Aviary.body(12, .semibold))
                    .foregroundColor(species.group.accent)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Aviary.card)
        }
        .clipShape(RoundedRectangle(cornerRadius: Aviary.corner, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }

    private var badgesRow: some View {
        HStack(spacing: 8) {
            AviaryChip(text: species.lengthLabel, color: Aviary.sky)
            AviaryChip(text: species.rarity.label, color: species.rarity.color)
            AviaryChip(text: species.seasonLabel, color: Aviary.forest)
            Spacer(minLength: 0)
        }
    }

    private func lifeListCard(first: BirdSighting) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Aviary.sage.opacity(0.16)).frame(width: 44, height: 44)
                PorchGlyph(size: 21, color: Aviary.sage)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("On your life list")
                    .font(Aviary.body(14, .bold))
                    .foregroundColor(Aviary.ink)
                Text(lifeLine(first: first))
                    .font(Aviary.body(12))
                    .foregroundColor(Aviary.inkSoft)
            }
            Spacer()
            if allSightings.count > 1 {
                AviaryChip(text: "\(allSightings.count) sightings", color: Aviary.forest)
            }
        }
        .aviaryCard(padding: 12)
    }

    private func lifeLine(first: BirdSighting) -> String {
        var line = "First seen \(AviaryFormat.day.string(from: first.date))"
        let place = first.place.trimmingCharacters(in: .whitespaces)
        if !place.isEmpty { line += " at \(place)" }
        return line
    }

    private func infoSection<Content: View>(title: String, accent: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accent)
                    .frame(width: 4, height: 16)
                Text(title)
                    .font(Aviary.title(16))
                    .foregroundColor(Aviary.ink)
            }
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .aviaryCard()
    }

    private func detailText(_ text: String) -> some View {
        Text(text)
            .font(Aviary.body(14))
            .foregroundColor(Aviary.ink)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var funFactCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                StarGlyph(size: 16, color: Aviary.amber)
                Text("Did You Know?")
                    .font(Aviary.title(16))
                    .foregroundColor(Aviary.ink)
            }
            Text(species.funFact)
                .font(Aviary.body(14))
                .foregroundColor(Aviary.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Aviary.corner, style: .continuous)
                .fill(Aviary.amber.opacity(0.13))
        )
    }

    private var seasonCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                CalendarGlyph(size: 15, color: Aviary.forest)
                Text("When to Look")
                    .font(Aviary.title(16))
                    .foregroundColor(Aviary.ink)
                Spacer()
                Text(species.seasonLabel)
                    .font(Aviary.body(12, .semibold))
                    .foregroundColor(Aviary.inkSoft)
            }
            HStack(spacing: 4) {
                ForEach(1...12, id: \.self) { m in
                    let active = species.months.contains(m)
                    VStack(spacing: 3) {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(active ? Aviary.forest : Aviary.creamDark)
                            .frame(height: 18)
                        Text(String(AviaryFormat.monthShort(m).prefix(1)))
                            .font(Aviary.body(9))
                            .foregroundColor(Aviary.inkSoft)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .aviaryCard()
    }

    private var similarSection: some View {
        let similars = species.similarIds.compactMap { SpeciesData.species($0) }
        return Group {
            if !similars.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader(title: "Compare With", subtitle: "Species that are easy to confuse")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(similars) { s in
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
        }
    }

    private var sightingHistory: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Your Sightings", subtitle: "\(allSightings.count) logged")
            VStack(spacing: 10) {
                ForEach(allSightings) { s in
                    NavigationLink(destination: SightingDetailView(sighting: s)) {
                        HStack(spacing: 10) {
                            CalendarGlyph(size: 14)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(AviaryFormat.day.string(from: s.date))
                                    .font(Aviary.body(14, .semibold))
                                    .foregroundColor(Aviary.ink)
                                if !s.place.isEmpty {
                                    Text(s.place)
                                        .font(Aviary.body(12))
                                        .foregroundColor(Aviary.inkSoft)
                                }
                            }
                            Spacer()
                            if s.count > 1 {
                                AviaryChip(text: "x\(s.count)", color: Aviary.amberDeep)
                            }
                            ChevronIcon(direction: .right, size: 11)
                        }
                        .aviaryCard(padding: 12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
