import SwiftUI

struct MoreView: View {
    @EnvironmentObject var store: BirdStore
    @State private var showPrivacy = false
    @State private var confirmReset = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("More")
                        .font(Aviary.title(30))
                        .foregroundColor(Aviary.ink)
                    Text("Stats, badges, and app info")
                        .font(Aviary.body(13))
                        .foregroundColor(Aviary.inkSoft)
                }

                statsSection

                badgesSection

                aboutSection
            }
            .padding(16)
            .aviaryContentWidth()
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $showPrivacy) {
            FeatherWebPanel(urlString: "https://example.com")
        }
        .alert(isPresented: $confirmReset) {
            Alert(
                title: Text("Reset all data?"),
                message: Text("This permanently clears your life list, journal, quiz scores, and badges. There is no undo."),
                primaryButton: .destructive(Text("Reset Everything")) {
                    store.resetAll()
                },
                secondaryButton: .cancel()
            )
        }
    }

    // MARK: - Stats

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Your Stats")
            HStack(spacing: 10) {
                StatTile(value: "\(store.spottedSpeciesIds.count)", label: "species spotted")
                StatTile(value: "\(store.sightings.count)", label: "sightings", color: Aviary.amberDeep)
                StatTile(value: "\(store.distinctPlaces.count)", label: "places", color: Aviary.terracotta)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Sightings by Month")
                    .font(Aviary.body(14, .bold))
                    .foregroundColor(Aviary.ink)
                if store.sightings.isEmpty {
                    Text("Log sightings to see your busiest birding months here.")
                        .font(Aviary.body(13))
                        .foregroundColor(Aviary.inkSoft)
                } else {
                    MonthBarChart(values: store.sightingsByMonth)
                }
            }
            .aviaryCard()

            if !store.distinctPlaces.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Birding Spots")
                        .font(Aviary.body(14, .bold))
                        .foregroundColor(Aviary.ink)
                    ForEach(store.distinctPlaces, id: \.self) { place in
                        HStack(spacing: 10) {
                            PinGlyph(size: 14)
                            Text(place)
                                .font(Aviary.body(14))
                                .foregroundColor(Aviary.ink)
                            Spacer()
                            let count = store.sightings.filter {
                                $0.place.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == place.lowercased()
                            }.count
                            Text(count == 1 ? "1 sighting" : "\(count) sightings")
                                .font(Aviary.body(12))
                                .foregroundColor(Aviary.inkSoft)
                        }
                    }
                }
                .aviaryCard()
            }
        }
    }

    // MARK: - Badges

    private var badgesSection: some View {
        let earned = BadgeKit.earned(in: store).count
        return VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Badges", subtitle: "\(earned) of \(BadgeKit.all.count) earned")
            let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: Aviary.isPad ? 3 : 2)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(BadgeKit.all) { badge in
                    BadgeCard(badge: badge)
                }
            }
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "About")
            VStack(spacing: 0) {
                aboutRow(title: "Privacy Policy") {
                    showPrivacy = true
                }
                Divider().background(Aviary.line).padding(.leading, 16)
                HStack {
                    Text("Version")
                        .font(Aviary.body(15))
                        .foregroundColor(Aviary.ink)
                    Spacer()
                    Text(versionString)
                        .font(Aviary.body(14))
                        .foregroundColor(Aviary.inkSoft)
                }
                .padding(16)
                Divider().background(Aviary.line).padding(.leading, 16)
                aboutRow(title: "Reset All Data", tint: Aviary.rose) {
                    confirmReset = true
                }
            }
            .background(
                RoundedRectangle(cornerRadius: Aviary.corner, style: .continuous)
                    .fill(Aviary.card)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
            )

            Text("Backyard Birds is an offline field guide and life list. All of your sightings stay on this device.")
                .font(Aviary.body(12))
                .foregroundColor(Aviary.inkSoft)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 2)
        }
    }

    private var versionString: String {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(v) (\(b))"
    }

    private func aboutRow(title: String, tint: Color = Aviary.ink, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(Aviary.body(15))
                    .foregroundColor(tint)
                Spacer()
                ChevronIcon(direction: .right, size: 12)
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Badge card

struct BadgeCard: View {
    @EnvironmentObject var store: BirdStore
    let badge: AviaryBadge

    var body: some View {
        let isEarned = badge.isEarned(store)
        let progress = badge.progress(store)
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                ZStack {
                    Circle()
                        .fill(isEarned ? badge.tint.opacity(0.16) : Aviary.creamDark)
                        .frame(width: 44, height: 44)
                    BadgeIconView(kind: badge.icon, size: 21,
                                  color: isEarned ? badge.tint : Aviary.inkSoft.opacity(0.35))
                }
                Spacer()
                if isEarned {
                    ZStack {
                        Circle().fill(badge.tint).frame(width: 20, height: 20)
                        CheckIcon(size: 9, color: .white, weight: 2.2)
                    }
                }
            }
            Text(badge.title)
                .font(Aviary.body(14, .bold))
                .foregroundColor(isEarned ? Aviary.ink : Aviary.inkSoft)
            Text(badge.detail)
                .font(Aviary.body(11))
                .foregroundColor(Aviary.inkSoft)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            if !isEarned {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Aviary.creamDark)
                        Capsule()
                            .fill(badge.tint.opacity(0.6))
                            .frame(width: progress.goal > 0
                                   ? geo.size.width * CGFloat(progress.current) / CGFloat(progress.goal)
                                   : 0)
                    }
                }
                .frame(height: 6)
                Text("\(progress.current)/\(progress.goal)")
                    .font(Aviary.body(10, .semibold))
                    .foregroundColor(Aviary.inkSoft)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Aviary.card)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
    }
}
