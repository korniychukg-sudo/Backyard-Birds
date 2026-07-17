import SwiftUI

struct GuideView: View {
    @EnvironmentObject var store: BirdStore
    @State private var query = ""
    @State private var selectedGroup: BirdGroupKind? = nil
    @State private var selectedColor: BirdColorTag? = nil
    @State private var spottedOnly = false

    private var filtered: [BirdSpecies] {
        var list = SpeciesData.all
        if let g = selectedGroup {
            list = list.filter { $0.group == g }
        }
        if let c = selectedColor {
            list = list.filter { $0.colors.contains(c) }
        }
        if spottedOnly {
            list = list.filter { store.isSpotted($0.id) }
        }
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty {
            list = list.filter {
                $0.name.lowercased().contains(q) || $0.latin.lowercased().contains(q)
            }
        }
        return list
    }

    private var isFiltering: Bool {
        selectedGroup != nil || selectedColor != nil || spottedOnly
            || !query.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Field Guide")
                        .font(Aviary.title(30))
                        .foregroundColor(Aviary.ink)
                    Text("\(SpeciesData.all.count) backyard species in 6 groups")
                        .font(Aviary.body(13))
                        .foregroundColor(Aviary.inkSoft)
                }

                searchBar

                groupChips

                colorChips

                if isFiltering {
                    filteredResults
                } else {
                    groupSections
                }
            }
            .padding(16)
            .aviaryContentWidth()
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    // MARK: - Search & filters

    private var searchBar: some View {
        HStack(spacing: 8) {
            SearchIcon(size: 15)
            TextField("Search by name...", text: $query)
                .font(Aviary.body(15))
                .foregroundColor(Aviary.ink)
                .disableAutocorrection(true)
            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    CloseIcon(size: 11)
                        .padding(4)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Aviary.card)
                .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
        )
    }

    private var groupChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "All groups", isOn: selectedGroup == nil) {
                    selectedGroup = nil
                }
                ForEach(BirdGroupKind.allCases) { g in
                    FilterChip(label: g.shortTitle, isOn: selectedGroup == g) {
                        selectedGroup = selectedGroup == g ? nil : g
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private var colorChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: spottedOnly ? "Spotted only" : "Any status", isOn: spottedOnly) {
                    spottedOnly.toggle()
                }
                ForEach(BirdColorTag.allCases) { tag in
                    Button {
                        selectedColor = selectedColor == tag ? nil : tag
                    } label: {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(tag.swatch)
                                .frame(width: 11, height: 11)
                                .overlay(Circle().stroke(Aviary.line, lineWidth: 1))
                            Text(tag.label)
                                .font(Aviary.body(13, .semibold))
                                .foregroundColor(selectedColor == tag ? .white : Aviary.ink)
                        }
                        .padding(.horizontal, 11)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(selectedColor == tag ? Aviary.forest : Aviary.creamDark))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 2)
        }
    }

    // MARK: - Results

    private var filteredResults: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(filtered.count == 1 ? "1 species" : "\(filtered.count) species")
                .font(Aviary.body(13, .semibold))
                .foregroundColor(Aviary.inkSoft)
            if filtered.isEmpty {
                EmptyStateView(
                    title: "No matches",
                    message: "Try clearing a filter or checking the spelling — or maybe this bird just hasn't made the guide yet."
                )
                .aviaryCard()
            } else {
                VStack(spacing: 10) {
                    ForEach(filtered) { s in
                        SpeciesRow(species: s, spotted: store.isSpotted(s.id))
                    }
                }
            }
        }
    }

    private var groupSections: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(BirdGroupKind.allCases) { group in
                let members = SpeciesData.inGroup(group)
                VStack(alignment: .leading, spacing: 10) {
                    ZStack(alignment: .bottomLeading) {
                        BirdArtView(name: group.bannerName, cornerRadius: Aviary.corner)
                            .frame(height: 92)
                            .clipped()
                        VStack(alignment: .leading, spacing: 2) {
                            Text(group.title)
                                .font(Aviary.title(18))
                                .foregroundColor(Aviary.ink)
                            Text("\(store.spottedCount(in: group)) of \(members.count) spotted")
                                .font(Aviary.body(12, .semibold))
                                .foregroundColor(Aviary.inkSoft)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                    }
                    Text(group.blurb)
                        .font(Aviary.body(13))
                        .foregroundColor(Aviary.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(members) { s in
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
}

// MARK: - Species list row

struct SpeciesRow: View {
    let species: BirdSpecies
    let spotted: Bool

    var body: some View {
        NavigationLink(destination: SpeciesDetailView(species: species)) {
            HStack(spacing: 12) {
                BirdArtView(name: species.artName, cornerRadius: 12)
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 4) {
                    Text(species.name)
                        .font(Aviary.body(15, .semibold))
                        .foregroundColor(Aviary.ink)
                    Text(species.latin)
                        .font(Aviary.body(12).italic())
                        .foregroundColor(Aviary.inkSoft)
                    HStack(spacing: 6) {
                        AviaryChip(text: species.sizeClass.label, color: Aviary.sky)
                        AviaryChip(text: species.rarity.label, color: species.rarity.color)
                    }
                }
                Spacer()
                if spotted {
                    ZStack {
                        Circle().fill(Aviary.sage).frame(width: 24, height: 24)
                        CheckIcon(size: 11, color: .white, weight: 2.2)
                    }
                } else {
                    ChevronIcon(direction: .right, size: 12)
                }
            }
            .aviaryCard(padding: 12)
        }
        .buttonStyle(.plain)
    }
}
