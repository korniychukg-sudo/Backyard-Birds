import SwiftUI

// MARK: - Art loading

/// Loads a bundled Art/*.png by name, with a drawn fallback so a missing
/// file can never produce a blank hole in the UI.
struct BirdArtView: View {
    let name: String
    var cornerRadius: CGFloat = Aviary.corner

    var body: some View {
        Group {
            if let ui = ArtCache.image(named: name) {
                Image(uiImage: ui)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    Aviary.creamDark
                    BirdGlyph(size: 44, color: Aviary.inkSoft.opacity(0.5))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

enum ArtCache {
    private static var cache = NSCache<NSString, UIImage>()

    static func image(named name: String) -> UIImage? {
        if let hit = cache.object(forKey: name as NSString) { return hit }
        guard let url = Bundle.main.url(forResource: name, withExtension: "png", subdirectory: "Art")
                ?? Bundle.main.url(forResource: name, withExtension: "png") else { return nil }
        guard let img = UIImage(contentsOfFile: url.path) else { return nil }
        cache.setObject(img, forKey: name as NSString)
        return img
    }
}

// MARK: - Cards & layout

struct AviaryCard: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: Aviary.corner, style: .continuous)
                    .fill(Aviary.card)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
            )
    }
}

extension View {
    func aviaryCard(padding: CGFloat = 16) -> some View {
        modifier(AviaryCard(padding: padding))
    }

    /// Constrains content width on iPad so screens don't stretch edge to edge.
    func aviaryContentWidth() -> some View {
        frame(maxWidth: Aviary.contentMaxWidth)
            .frame(maxWidth: .infinity)
    }
}

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(Aviary.title(20))
                .foregroundColor(Aviary.ink)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Aviary.body(13))
                    .foregroundColor(Aviary.inkSoft)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Chips

struct AviaryChip: View {
    let text: String
    var color: Color = Aviary.forest
    var filled: Bool = false

    var body: some View {
        Text(text)
            .font(Aviary.body(12, .semibold))
            .foregroundColor(filled ? .white : color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule().fill(filled ? color : color.opacity(0.14))
            )
    }
}

struct FilterChip: View {
    let label: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Aviary.body(13, .semibold))
                .foregroundColor(isOn ? .white : Aviary.ink)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Capsule().fill(isOn ? Aviary.forest : Aviary.creamDark))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Buttons

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = Aviary.forest
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Aviary.body(16, .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color)
            )
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
    }
}

struct SoftButtonStyle: ButtonStyle {
    var color: Color = Aviary.forest
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Aviary.body(15, .semibold))
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color.opacity(0.12))
            )
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

// MARK: - Progress ring

struct ProgressRing: View {
    let progress: Double            // 0...1
    var lineWidth: CGFloat = 10
    var size: CGFloat = 96
    var color: Color = Aviary.forest
    var track: Color = Aviary.creamDark

    var body: some View {
        ZStack {
            Circle()
                .stroke(track, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(max(0, min(1, progress))))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Bar chart (custom, no frameworks)

struct MonthBarChart: View {
    let values: [Int]               // 12 entries
    var barColor: Color = Aviary.forest

    private var maxValue: Int { max(values.max() ?? 1, 1) }

    var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .bottom, spacing: 6) {
                ForEach(0..<12, id: \.self) { i in
                    VStack(spacing: 4) {
                        if values[i] > 0 {
                            Text("\(values[i])")
                                .font(Aviary.body(9, .semibold))
                                .foregroundColor(Aviary.inkSoft)
                        }
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(values[i] > 0 ? barColor : Aviary.creamDark)
                            .frame(height: max(4, CGFloat(values[i]) / CGFloat(maxValue) * 70))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            HStack(spacing: 6) {
                ForEach(0..<12, id: \.self) { i in
                    Text(String(AviaryFormat.monthShort(i + 1).prefix(1)))
                        .font(Aviary.body(9))
                        .foregroundColor(Aviary.inkSoft)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Empty state

struct EmptyStateView: View {
    let title: String
    let message: String
    var artName: String? = nil

    var body: some View {
        VStack(spacing: 12) {
            if let artName = artName {
                BirdArtView(name: artName)
                    .frame(width: 140, height: 140)
            } else {
                BirdGlyph(size: 52, color: Aviary.inkSoft.opacity(0.5))
            }
            Text(title)
                .font(Aviary.title(18))
                .foregroundColor(Aviary.ink)
            Text(message)
                .font(Aviary.body(14))
                .foregroundColor(Aviary.inkSoft)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
    }
}

// MARK: - Stat tile

struct StatTile: View {
    let value: String
    let label: String
    var color: Color = Aviary.forest

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(Aviary.title(24))
                .foregroundColor(color)
            Text(label)
                .font(Aviary.body(12))
                .foregroundColor(Aviary.inkSoft)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Aviary.card)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
    }
}

// MARK: - Custom calendar date picker (no system DatePicker)

struct AviaryDatePicker: View {
    @Binding var selection: Date
    @State private var displayedMonth: Date

    init(selection: Binding<Date>) {
        _selection = selection
        _displayedMonth = State(initialValue: selection.wrappedValue)
    }

    private var cal: Calendar { Calendar.current }

    private var monthStart: Date {
        cal.date(from: cal.dateComponents([.year, .month], from: displayedMonth)) ?? displayedMonth
    }

    private var daysInMonth: Int {
        cal.range(of: .day, in: .month, for: monthStart)?.count ?? 30
    }

    /// Leading blanks so day 1 lands under its weekday (Sun-first grid).
    private var leadingBlanks: Int {
        (cal.component(.weekday, from: monthStart) - cal.firstWeekday + 7) % 7
    }

    private var canGoForward: Bool {
        if let next = cal.date(byAdding: .month, value: 1, to: monthStart) {
            return next <= Date()
        }
        return false
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    if let prev = cal.date(byAdding: .month, value: -1, to: monthStart) {
                        displayedMonth = prev
                    }
                } label: {
                    ChevronIcon(direction: .left, size: 14, color: Aviary.forest)
                        .padding(8)
                }
                .buttonStyle(.plain)
                Spacer()
                Text(AviaryFormat.monthYear.string(from: monthStart))
                    .font(Aviary.body(15, .bold))
                    .foregroundColor(Aviary.ink)
                Spacer()
                Button {
                    if canGoForward, let next = cal.date(byAdding: .month, value: 1, to: monthStart) {
                        displayedMonth = next
                    }
                } label: {
                    ChevronIcon(direction: .right, size: 14, color: canGoForward ? Aviary.forest : Aviary.line)
                        .padding(8)
                }
                .buttonStyle(.plain)
                .disabled(!canGoForward)
            }

            let symbols = ["S", "M", "T", "W", "T", "F", "S"]
            HStack(spacing: 0) {
                ForEach(0..<7, id: \.self) { i in
                    Text(symbols[i])
                        .font(Aviary.body(11, .semibold))
                        .foregroundColor(Aviary.inkSoft)
                        .frame(maxWidth: .infinity)
                }
            }

            let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(0..<leadingBlanks, id: \.self) { _ in
                    Color.clear.frame(height: 34)
                }
                ForEach(1...daysInMonth, id: \.self) { day in
                    let date = cal.date(byAdding: .day, value: day - 1, to: monthStart) ?? monthStart
                    let isSelected = cal.isDate(date, inSameDayAs: selection)
                    let isFuture = date > Date() && !cal.isDateInToday(date)
                    Button {
                        guard !isFuture else { return }
                        // Preserve the current time-of-day when changing the date.
                        let time = cal.dateComponents([.hour, .minute], from: selection)
                        var comps = cal.dateComponents([.year, .month, .day], from: date)
                        comps.hour = time.hour
                        comps.minute = time.minute
                        selection = cal.date(from: comps) ?? date
                    } label: {
                        Text("\(day)")
                            .font(Aviary.body(14, isSelected ? .bold : .regular))
                            .foregroundColor(isSelected ? .white : (isFuture ? Aviary.line : Aviary.ink))
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .background(
                                Circle().fill(isSelected ? Aviary.forest : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(isFuture)
                }
            }
        }
    }
}
