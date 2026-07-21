import SwiftUI

struct LifeListView: View {
    @EnvironmentObject var store: BirdStore
    @State private var mode = 0            // 0 = life list, 1 = journal
    @State private var showAddSighting = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Life List")
                            .font(Aviary.title(30))
                            .foregroundColor(Aviary.ink)
                        Text("Every bird you have ever spotted")
                            .font(Aviary.body(13))
                            .foregroundColor(Aviary.inkSoft)
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

                summaryCard

                modePicker

                if mode == 0 {
                    lifeListSection
                } else {
                    journalSection
                }
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

    // MARK: - Summary

    private var summaryCard: some View {
        let total = SpeciesData.all.count
        let spotted = store.spottedSpeciesIds.count
        return VStack(spacing: 14) {
            HStack(spacing: 18) {
                ZStack {
                    ProgressRing(progress: Double(spotted) / Double(total), lineWidth: 9, size: 84)
                    VStack(spacing: 0) {
                        Text("\(spotted)")
                            .font(Aviary.title(24))
                            .foregroundColor(Aviary.forest)
                        Text("of \(total)")
                            .font(Aviary.body(11))
                            .foregroundColor(Aviary.inkSoft)
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    statLine(value: "\(store.sightings.count)", label: "sightings logged")
                    statLine(value: "\(store.distinctPlaces.count)", label: "places visited")
                    statLine(value: "\(store.totalBirdsCounted)", label: "birds counted")
                }
                Spacer(minLength: 0)
            }
            VStack(spacing: 6) {
                ForEach(BirdGroupKind.allCases) { group in
                    let members = SpeciesData.inGroup(group).count
                    let done = store.spottedCount(in: group)
                    HStack(spacing: 8) {
                        Text(group.shortTitle)
                            .font(Aviary.body(12, .semibold))
                            .foregroundColor(Aviary.ink)
                            .frame(width: 110, alignment: .leading)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Aviary.creamDark)
                                Capsule()
                                    .fill(group.accent)
                                    .frame(width: members > 0 ? geo.size.width * CGFloat(done) / CGFloat(members) : 0)
                            }
                        }
                        .frame(height: 8)
                        Text("\(done)/\(members)")
                            .font(Aviary.body(11, .semibold))
                            .foregroundColor(Aviary.inkSoft)
                            .frame(width: 34, alignment: .trailing)
                    }
                }
            }
        }
        .aviaryCard()
    }

    private func statLine(value: String, label: String) -> some View {
        HStack(spacing: 6) {
            Text(value)
                .font(Aviary.title(16))
                .foregroundColor(Aviary.forest)
            Text(label)
                .font(Aviary.body(13))
                .foregroundColor(Aviary.inkSoft)
        }
    }

    private var modePicker: some View {
        HStack(spacing: 0) {
            modeButton(index: 0, label: "Species")
            modeButton(index: 1, label: "Journal")
        }
        .padding(4)
        .background(Capsule().fill(Aviary.creamDark))
    }

    private func modeButton(index: Int, label: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.18)) { mode = index }
        } label: {
            Text(label)
                .font(Aviary.body(14, .semibold))
                .foregroundColor(mode == index ? .white : Aviary.inkSoft)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Capsule().fill(mode == index ? Aviary.forest : Color.clear))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Life list (species mode)

    private var lifeListSection: some View {
        let spottedSpecies = SpeciesData.all.filter { store.isSpotted($0.id) }
        return Group {
            if spottedSpecies.isEmpty {
                EmptyStateView(
                    title: "No lifers yet",
                    message: "Your life list begins with a single sighting. Spot a bird, log it, and watch this page fill with feathers.",
                    artName: "bird_blackcappedChickadee"
                )
                .aviaryCard()
            } else {
                VStack(spacing: 10) {
                    ForEach(spottedSpecies) { s in
                        LifeListRow(species: s, first: store.firstSighting(of: s.id),
                                    count: store.sightings(of: s.id).count)
                    }
                }
            }
        }
    }

    // MARK: - Journal (all sightings)

    private var journalSection: some View {
        Group {
            if store.sightings.isEmpty {
                EmptyStateView(
                    title: "The journal is empty",
                    message: "Each sighting you log — date, place, notes — becomes a page of your birding story.",
                    artName: "bird_carolinaWren"
                )
                .aviaryCard()
            } else {
                VStack(spacing: 10) {
                    ForEach(store.sightingsNewestFirst) { s in
                        NavigationLink(destination: SightingDetailView(sighting: s)) {
                            JournalRow(sighting: s)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// MARK: - Rows

struct LifeListRow: View {
    let species: BirdSpecies
    let first: BirdSighting?
    let count: Int

    var body: some View {
        NavigationLink(destination: SpeciesDetailView(species: species)) {
            HStack(spacing: 12) {
                BirdArtView(name: species.artName, cornerRadius: 12)
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 3) {
                    Text(species.name)
                        .font(Aviary.body(15, .semibold))
                        .foregroundColor(Aviary.ink)
                    if let first = first {
                        Text("Lifer on \(AviaryFormat.day.string(from: first.date))")
                            .font(Aviary.body(12))
                            .foregroundColor(Aviary.inkSoft)
                        if !first.place.isEmpty {
                            HStack(spacing: 4) {
                                PinGlyph(size: 11)
                                Text(first.place)
                                    .font(Aviary.body(12))
                                    .foregroundColor(Aviary.inkSoft)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                Spacer()
                VStack(spacing: 4) {
                    AviaryChip(text: "x\(count)", color: Aviary.forest)
                    ChevronIcon(direction: .right, size: 11)
                }
            }
            .aviaryCard(padding: 12)
        }
        .buttonStyle(.plain)
    }
}

struct JournalRow: View {
    let sighting: BirdSighting

    private var species: BirdSpecies? { SpeciesData.species(sighting.speciesId) }

    var body: some View {
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
                }
                if !sighting.place.isEmpty {
                    HStack(spacing: 5) {
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
}

// MARK: - Sighting detail

struct SightingDetailView: View {
    @EnvironmentObject var store: BirdStore
    @Environment(\.presentationMode) private var presentationMode
    let sighting: BirdSighting
    @State private var showEdit = false
    @State private var confirmDelete = false

    private var species: BirdSpecies? { SpeciesData.species(sighting.speciesId) }
    /// Live copy — reflects edits saved from the edit sheet.
    private var current: BirdSighting {
        store.sightings.first { $0.id == sighting.id } ?? sighting
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let species = species {
                    NavigationLink(destination: SpeciesDetailView(species: species)) {
                        HStack(spacing: 12) {
                            BirdArtView(name: species.artName, cornerRadius: 12)
                                .frame(width: 72, height: 72)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(species.name)
                                    .font(Aviary.title(19))
                                    .foregroundColor(Aviary.ink)
                                Text(species.latin)
                                    .font(Aviary.body(13).italic())
                                    .foregroundColor(Aviary.inkSoft)
                                Text("Open in guide")
                                    .font(Aviary.body(12, .semibold))
                                    .foregroundColor(Aviary.forest)
                            }
                            Spacer()
                            ChevronIcon(direction: .right, size: 13)
                        }
                        .aviaryCard(padding: 12)
                    }
                    .buttonStyle(.plain)
                }

                VStack(alignment: .leading, spacing: 12) {
                    detailRow(label: "Date") {
                        Text(AviaryFormat.day.string(from: current.date))
                    }
                    Divider().background(Aviary.line)
                    detailRow(label: "Place") {
                        Text(current.place.isEmpty ? "Not recorded" : current.place)
                    }
                    Divider().background(Aviary.line)
                    detailRow(label: "Birds seen") {
                        Text("\(current.count)")
                    }
                    if !current.notes.isEmpty {
                        Divider().background(Aviary.line)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Notes")
                                .font(Aviary.body(12, .semibold))
                                .foregroundColor(Aviary.inkSoft)
                            Text(current.notes)
                                .font(Aviary.body(14))
                                .foregroundColor(Aviary.ink)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .aviaryCard()

                Button("Edit Sighting") { showEdit = true }
                    .buttonStyle(SoftButtonStyle())

                Button("Delete Sighting") { confirmDelete = true }
                    .buttonStyle(SoftButtonStyle(color: Aviary.rose))
            }
            .padding(16)
            .aviaryContentWidth()
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Sighting")
                    .font(Aviary.body(16, .bold))
                    .foregroundColor(Aviary.ink)
            }
        }
        .sheet(isPresented: $showEdit) {
            AddSightingView(editing: current)
                .environmentObject(store)
        }
        .alert(isPresented: $confirmDelete) {
            Alert(
                title: Text("Delete this sighting?"),
                message: Text("This cannot be undone. If it is the only sighting of this species, the bird leaves your life list."),
                primaryButton: .destructive(Text("Delete")) {
                    store.deleteSighting(id: sighting.id)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func detailRow<Content: View>(label: String, @ViewBuilder value: () -> Content) -> some View {
        HStack {
            Text(label)
                .font(Aviary.body(13, .semibold))
                .foregroundColor(Aviary.inkSoft)
            Spacer()
            value()
                .font(Aviary.body(14, .semibold))
                .foregroundColor(Aviary.ink)
        }
    }
}
