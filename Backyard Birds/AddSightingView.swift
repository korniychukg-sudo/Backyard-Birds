import SwiftUI

struct AddSightingView: View {
    @EnvironmentObject var store: BirdStore
    @Environment(\.presentationMode) private var presentationMode

    private let editingId: UUID?
    @State private var speciesId: String?
    @State private var date: Date
    @State private var place: String
    @State private var count: Int
    @State private var notes: String
    @State private var speciesQuery = ""
    @State private var showDatePicker = false

    init(preselectedSpeciesId: String? = nil, editing: BirdSighting? = nil) {
        editingId = editing?.id
        _speciesId = State(initialValue: editing?.speciesId ?? preselectedSpeciesId)
        _date = State(initialValue: editing?.date ?? Date())
        _place = State(initialValue: editing?.place ?? "")
        _count = State(initialValue: editing?.count ?? 1)
        _notes = State(initialValue: editing?.notes ?? "")
    }

    private var isEditing: Bool { editingId != nil }

    private var selectedSpecies: BirdSpecies? {
        speciesId.flatMap { SpeciesData.species($0) }
    }

    private var canSave: Bool { selectedSpecies != nil }

    private var searchResults: [BirdSpecies] {
        let q = speciesQuery.trimmingCharacters(in: .whitespaces).lowercased()
        if q.isEmpty { return SpeciesData.all }
        return SpeciesData.all.filter { $0.name.lowercased().contains(q) }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if let species = selectedSpecies {
                        selectedSpeciesCard(species)
                    } else {
                        speciesPicker
                    }

                    if selectedSpecies != nil {
                        dateSection
                        placeSection
                        countSection
                        notesSection

                        Button(isEditing ? "Save Changes" : "Add to Life List") {
                            save()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!canSave)
                    }
                }
                .padding(16)
                .aviaryContentWidth()
            }
            .background(Aviary.cream.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(isEditing ? "Edit Sighting" : "New Sighting")
                        .font(Aviary.body(16, .bold))
                        .foregroundColor(Aviary.ink)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .font(Aviary.body(15))
                            .foregroundColor(Aviary.inkSoft)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.light)
    }

    // MARK: - Species picking

    private func selectedSpeciesCard(_ species: BirdSpecies) -> some View {
        HStack(spacing: 12) {
            BirdArtView(name: species.artName, cornerRadius: 12)
                .frame(width: 64, height: 64)
            VStack(alignment: .leading, spacing: 3) {
                Text(species.name)
                    .font(Aviary.body(16, .bold))
                    .foregroundColor(Aviary.ink)
                Text(species.latin)
                    .font(Aviary.body(12).italic())
                    .foregroundColor(Aviary.inkSoft)
                if store.isSpotted(species.id) && !isEditing {
                    Text("Already on your life list — logging another sighting")
                        .font(Aviary.body(11))
                        .foregroundColor(Aviary.sage)
                } else if !isEditing {
                    Text("A new lifer!")
                        .font(Aviary.body(11, .bold))
                        .foregroundColor(Aviary.amberDeep)
                }
            }
            Spacer()
            if !isEditing {
                Button {
                    speciesId = nil
                    speciesQuery = ""
                } label: {
                    Text("Change")
                        .font(Aviary.body(13, .semibold))
                        .foregroundColor(Aviary.forest)
                }
                .buttonStyle(.plain)
            }
        }
        .aviaryCard(padding: 12)
    }

    private var speciesPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Which bird did you see?")
                .font(Aviary.title(18))
                .foregroundColor(Aviary.ink)

            HStack(spacing: 8) {
                SearchIcon(size: 15)
                TextField("Search species...", text: $speciesQuery)
                    .font(Aviary.body(15))
                    .foregroundColor(Aviary.ink)
                    .disableAutocorrection(true)
                if !speciesQuery.isEmpty {
                    Button {
                        speciesQuery = ""
                    } label: {
                        CloseIcon(size: 11).padding(4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Aviary.card)
            )

            if searchResults.isEmpty {
                Text("No species match that name.")
                    .font(Aviary.body(13))
                    .foregroundColor(Aviary.inkSoft)
                    .padding(.vertical, 12)
            } else {
                VStack(spacing: 8) {
                    ForEach(searchResults) { s in
                        Button {
                            speciesId = s.id
                        } label: {
                            HStack(spacing: 10) {
                                BirdArtView(name: s.artName, cornerRadius: 9)
                                    .frame(width: 44, height: 44)
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(s.name)
                                        .font(Aviary.body(14, .semibold))
                                        .foregroundColor(Aviary.ink)
                                    Text(s.group.shortTitle)
                                        .font(Aviary.body(11))
                                        .foregroundColor(Aviary.inkSoft)
                                }
                                Spacer()
                                if store.isSpotted(s.id) {
                                    ZStack {
                                        Circle().fill(Aviary.sage).frame(width: 20, height: 20)
                                        CheckIcon(size: 9, color: .white, weight: 2)
                                    }
                                }
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Aviary.card)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Fields

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldLabel("When")
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { showDatePicker.toggle() }
            } label: {
                HStack {
                    CalendarGlyph(size: 15, color: Aviary.forest)
                    Text(AviaryFormat.day.string(from: date))
                        .font(Aviary.body(15, .semibold))
                        .foregroundColor(Aviary.ink)
                    Spacer()
                    ChevronIcon(direction: showDatePicker ? .up : .down, size: 12)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Aviary.card)
                )
            }
            .buttonStyle(.plain)

            if showDatePicker {
                AviaryDatePicker(selection: $date)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Aviary.card)
                    )
            }

            HStack(spacing: 8) {
                quickDateChip("Today", daysAgo: 0)
                quickDateChip("Yesterday", daysAgo: 1)
            }
        }
    }

    private func quickDateChip(_ label: String, daysAgo: Int) -> some View {
        let target = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        let isOn = Calendar.current.isDate(date, inSameDayAs: target)
        return FilterChip(label: label, isOn: isOn) {
            date = target
        }
    }

    private var placeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldLabel("Where")
            TextField("e.g. Back porch feeder", text: $place)
                .font(Aviary.body(15))
                .foregroundColor(Aviary.ink)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Aviary.card)
                )
            if !store.distinctPlaces.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(store.distinctPlaces.prefix(6), id: \.self) { p in
                            FilterChip(label: p, isOn: place == p) {
                                place = place == p ? "" : p
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }

    private var countSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldLabel("How many birds?")
            HStack(spacing: 14) {
                stepperButton("-") {
                    if count > 1 { count -= 1 }
                }
                Text("\(count)")
                    .font(Aviary.title(22))
                    .foregroundColor(Aviary.ink)
                    .frame(minWidth: 44)
                stepperButton("+") {
                    if count < 999 { count += 1 }
                }
                Spacer()
            }
        }
    }

    private func stepperButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Aviary.card)
                    .frame(width: 44, height: 44)
                if symbol == "+" {
                    PlusIcon(size: 14, color: Aviary.forest)
                } else {
                    Capsule()
                        .fill(Aviary.forest)
                        .frame(width: 14, height: 2.6)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldLabel("Notes")
            ZStack(alignment: .topLeading) {
                if notes.isEmpty {
                    Text("What was it doing? Singing, feeding, gathering nest material...")
                        .font(Aviary.body(14))
                        .foregroundColor(Aviary.inkSoft.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                }
                TextEditor(text: $notes)
                    .font(Aviary.body(14))
                    .foregroundColor(Aviary.ink)
                    .frame(minHeight: 90)
                    .padding(6)
                    .background(Color.clear)
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Aviary.card)
            )
        }
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(Aviary.body(13, .bold))
            .foregroundColor(Aviary.inkSoft)
    }

    // MARK: - Save

    private func save() {
        guard let speciesId = speciesId else { return }
        let trimmedPlace = place.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        if let editingId = editingId,
           var existing = store.sightings.first(where: { $0.id == editingId }) {
            existing.speciesId = speciesId
            existing.date = date
            existing.place = trimmedPlace
            existing.count = count
            existing.notes = trimmedNotes
            store.updateSighting(existing)
        } else {
            let sighting = BirdSighting(
                speciesId: speciesId,
                date: date,
                place: trimmedPlace,
                count: count,
                notes: trimmedNotes
            )
            store.addSighting(sighting)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
