import SwiftUI

struct LearnView: View {
    @EnvironmentObject var store: BirdStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Learn")
                        .font(Aviary.title(30))
                        .foregroundColor(Aviary.ink)
                    Text("Sharpen your eye and your yard")
                        .font(Aviary.body(13))
                        .foregroundColor(Aviary.inkSoft)
                }

                quizCard

                SectionHeader(
                    title: "Birding Tips",
                    subtitle: "\(store.readTipIds.count) of \(SpeciesDataB.tips.count) read"
                )
                VStack(spacing: 10) {
                    ForEach(SpeciesDataB.tips) { tip in
                        NavigationLink(destination: TipDetailView(tip: tip)) {
                            TipRow(tip: tip, isRead: store.readTipIds.contains(tip.id))
                        }
                        .buttonStyle(.plain)
                    }
                }

                SectionHeader(title: "Birder's Glossary", subtitle: "\(SpeciesDataB.glossary.count) terms every birder uses")
                NavigationLink(destination: GlossaryView()) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Aviary.forest.opacity(0.12))
                                .frame(width: 48, height: 48)
                            BookGlyph(size: 22, color: Aviary.forest)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Open the Glossary")
                                .font(Aviary.body(15, .semibold))
                                .foregroundColor(Aviary.ink)
                            Text("From \"lifer\" to \"gorget\" — talk like a birder")
                                .font(Aviary.body(12))
                                .foregroundColor(Aviary.inkSoft)
                        }
                        Spacer()
                        ChevronIcon(direction: .right, size: 12)
                    }
                    .aviaryCard(padding: 12)
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .aviaryContentWidth()
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var quizCard: some View {
        NavigationLink(destination: QuizView()) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color.white.opacity(0.22)).frame(width: 62, height: 62)
                    BinocularsGlyph(size: 30, color: .white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Bird ID Quiz")
                        .font(Aviary.title(19))
                        .foregroundColor(.white)
                    Text("10 questions from the field guide")
                        .font(Aviary.body(13))
                        .foregroundColor(Color.white.opacity(0.85))
                    if store.quizBestScore > 0 {
                        Text("Best score: \(store.quizBestScore)/10")
                            .font(Aviary.body(12, .bold))
                            .foregroundColor(Aviary.amber)
                    }
                }
                Spacer()
                ChevronIcon(direction: .right, size: 14, color: .white)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: Aviary.corner, style: .continuous)
                    .fill(
                        LinearGradient(colors: [Aviary.forest, Aviary.forestDeep],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tips

struct TipRow: View {
    let tip: BirdingTip
    let isRead: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isRead ? Aviary.sage.opacity(0.16) : Aviary.amber.opacity(0.16))
                    .frame(width: 48, height: 48)
                if isRead {
                    CheckIcon(size: 15, color: Aviary.sage, weight: 2.6)
                } else {
                    LeafGlyph(size: 21, color: Aviary.amberDeep)
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(tip.title)
                    .font(Aviary.body(15, .semibold))
                    .foregroundColor(Aviary.ink)
                Text(tip.summary)
                    .font(Aviary.body(12))
                    .foregroundColor(Aviary.inkSoft)
                    .lineLimit(2)
            }
            Spacer()
            ChevronIcon(direction: .right, size: 12)
        }
        .aviaryCard(padding: 12)
    }
}

struct TipDetailView: View {
    @EnvironmentObject var store: BirdStore
    let tip: BirdingTip

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(tip.title)
                    .font(Aviary.title(26))
                    .foregroundColor(Aviary.ink)
                Text(tip.summary)
                    .font(Aviary.body(15))
                    .foregroundColor(Aviary.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(tip.points.enumerated()), id: \.offset) { pair in
                        HStack(alignment: .top, spacing: 12) {
                            ZStack {
                                Circle().fill(Aviary.forest.opacity(0.12)).frame(width: 26, height: 26)
                                Text("\(pair.offset + 1)")
                                    .font(Aviary.body(13, .bold))
                                    .foregroundColor(Aviary.forest)
                            }
                            Text(pair.element)
                                .font(Aviary.body(15))
                                .foregroundColor(Aviary.ink)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .aviaryCard()
            }
            .padding(16)
            .aviaryContentWidth()
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Birding Tip")
                    .font(Aviary.body(16, .bold))
                    .foregroundColor(Aviary.ink)
            }
        }
        .onAppear {
            store.markTipRead(tip.id)
        }
    }
}

// MARK: - Glossary

struct GlossaryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(SpeciesDataB.glossary.sorted { $0.term < $1.term }) { term in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(term.term)
                            .font(Aviary.body(15, .bold))
                            .foregroundColor(Aviary.forest)
                        Text(term.definition)
                            .font(Aviary.body(14))
                            .foregroundColor(Aviary.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .aviaryCard(padding: 14)
                }
            }
            .padding(16)
            .aviaryContentWidth()
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Glossary")
                    .font(Aviary.body(16, .bold))
                    .foregroundColor(Aviary.ink)
            }
        }
    }
}
