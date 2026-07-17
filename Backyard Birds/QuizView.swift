import SwiftUI

// 10-question Bird ID Quiz built from guide data: name the portrait,
// or answer a fact question about a species.
struct QuizView: View {
    @EnvironmentObject var store: BirdStore

    @State private var questions: [QuizQuestion] = []
    @State private var index = 0
    @State private var score = 0
    @State private var selectedOption: Int? = nil
    @State private var finished = false
    @State private var recorded = false

    var body: some View {
        Group {
            if finished {
                resultScreen
            } else if questions.isEmpty {
                startScreen
            } else {
                questionScreen
            }
        }
        .background(Aviary.cream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Bird ID Quiz")
                    .font(Aviary.body(16, .bold))
                    .foregroundColor(Aviary.ink)
            }
        }
    }

    // MARK: - Screens

    private var startScreen: some View {
        ScrollView {
            VStack(spacing: 18) {
                BirdArtView(name: "bird_blueJay")
                    .frame(width: 180, height: 180)
                Text("Ten Questions")
                    .font(Aviary.title(24))
                    .foregroundColor(Aviary.ink)
                Text("Name birds from their portraits and answer field-guide questions. Each correct answer is a point — can you get all ten?")
                    .font(Aviary.body(14))
                    .foregroundColor(Aviary.inkSoft)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                if store.quizBestScore > 0 {
                    AviaryChip(text: "Best score: \(store.quizBestScore)/10", color: Aviary.amberDeep)
                }
                Button("Start Quiz") {
                    startNewRun()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
            .aviaryContentWidth()
        }
    }

    private var questionScreen: some View {
        let q = questions[index]
        return ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Question \(index + 1) of \(questions.count)")
                        .font(Aviary.body(13, .semibold))
                        .foregroundColor(Aviary.inkSoft)
                    Spacer()
                    AviaryChip(text: "Score: \(score)", color: Aviary.forest)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Aviary.creamDark)
                        Capsule()
                            .fill(Aviary.forest)
                            .frame(width: geo.size.width * CGFloat(index) / CGFloat(questions.count))
                    }
                }
                .frame(height: 6)

                if let artName = q.artName {
                    HStack {
                        Spacer()
                        BirdArtView(name: artName)
                            .frame(width: 230, height: 230)
                        Spacer()
                    }
                }

                Text(q.prompt)
                    .font(Aviary.title(18))
                    .foregroundColor(Aviary.ink)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 10) {
                    ForEach(Array(q.options.enumerated()), id: \.offset) { pair in
                        optionButton(q: q, optionIndex: pair.offset, label: pair.element)
                    }
                }

                if selectedOption != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedOption == q.correctIndex ? "Correct!" : "Not quite")
                            .font(Aviary.body(15, .bold))
                            .foregroundColor(selectedOption == q.correctIndex ? Aviary.sage : Aviary.rose)
                        Text(q.explanation)
                            .font(Aviary.body(13))
                            .foregroundColor(Aviary.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        Button(index + 1 < questions.count ? "Next Question" : "See Results") {
                            advance()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    .aviaryCard()
                }
            }
            .padding(16)
            .aviaryContentWidth()
        }
    }

    private func optionButton(q: QuizQuestion, optionIndex: Int, label: String) -> some View {
        let answered = selectedOption != nil
        let isCorrect = optionIndex == q.correctIndex
        let isPicked = selectedOption == optionIndex

        var background: Color = Aviary.card
        var border: Color = Color.clear
        if answered {
            if isCorrect {
                background = Aviary.sage.opacity(0.18)
                border = Aviary.sage
            } else if isPicked {
                background = Aviary.rose.opacity(0.14)
                border = Aviary.rose
            }
        }

        return Button {
            guard selectedOption == nil else { return }
            selectedOption = optionIndex
            if isCorrect { score += 1 }
        } label: {
            HStack {
                Text(label)
                    .font(Aviary.body(15, .semibold))
                    .foregroundColor(Aviary.ink)
                    .multilineTextAlignment(.leading)
                Spacer()
                if answered && isCorrect {
                    CheckIcon(size: 13, color: Aviary.sage, weight: 2.6)
                } else if answered && isPicked {
                    CloseIcon(size: 12, color: Aviary.rose)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(border, lineWidth: 1.6)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var resultScreen: some View {
        ScrollView {
            VStack(spacing: 18) {
                ZStack {
                    ProgressRing(progress: Double(score) / 10.0, lineWidth: 12, size: 130,
                                 color: score >= 8 ? Aviary.sage : (score >= 5 ? Aviary.amberDeep : Aviary.terracotta))
                    VStack(spacing: 0) {
                        Text("\(score)")
                            .font(Aviary.title(40))
                            .foregroundColor(Aviary.ink)
                        Text("of 10")
                            .font(Aviary.body(13))
                            .foregroundColor(Aviary.inkSoft)
                    }
                }
                Text(resultTitle)
                    .font(Aviary.title(22))
                    .foregroundColor(Aviary.ink)
                Text(resultMessage)
                    .font(Aviary.body(14))
                    .foregroundColor(Aviary.inkSoft)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                if score >= store.quizBestScore && score > 0 {
                    AviaryChip(text: "New personal best!", color: Aviary.amberDeep, filled: true)
                }
                Button("Play Again") {
                    startNewRun()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
            .aviaryContentWidth()
        }
        .onAppear {
            if !recorded {
                recorded = true
                store.recordQuizRun(score: score)
            }
        }
    }

    private var resultTitle: String {
        switch score {
        case 10: return "Perfect Ten!"
        case 8...9: return "Sharp-eyed Birder"
        case 5...7: return "Solid Fieldwork"
        case 3...4: return "Fledgling Progress"
        default: return "Everyone Starts Somewhere"
        }
    }
    private var resultMessage: String {
        switch score {
        case 10: return "Flawless identification — the field guide has nothing left to teach you. Time to earn it outdoors!"
        case 8...9: return "Nearly perfect. One more browse through the guide and the top score is yours."
        case 5...7: return "A solid showing. The tricky lookalikes — finches, sparrows, woodpeckers — reward a second study."
        case 3...4: return "You are getting the hang of it. Try reading a few species pages, then come back."
        default: return "Every expert birder once mixed up a finch and a sparrow. Browse the guide and try again!"
        }
    }

    // MARK: - Engine

    private func startNewRun() {
        questions = QuizBuilder.buildRun()
        index = 0
        score = 0
        selectedOption = nil
        finished = false
        recorded = false
    }

    private func advance() {
        selectedOption = nil
        if index + 1 < questions.count {
            index += 1
        } else {
            finished = true
        }
    }
}

// MARK: - Question builder

enum QuizBuilder {
    static func buildRun() -> [QuizQuestion] {
        let all = SpeciesData.all.shuffled()
        var questions: [QuizQuestion] = []

        // 6 portrait questions
        for species in all.prefix(6) {
            let wrong = all.filter { $0.id != species.id }.shuffled().prefix(3)
            var options = wrong.map { $0.name }
            let correctIndex = Int.random(in: 0...3)
            options.insert(species.name, at: correctIndex)
            questions.append(QuizQuestion(
                kind: .portraitToName,
                prompt: "Which bird is this?",
                artName: species.artName,
                options: options,
                correctIndex: correctIndex,
                explanation: "\(species.name) — \(species.idTips.first ?? species.behavior)"
            ))
        }

        // 4 fact questions
        questions.append(contentsOf: factQuestions().shuffled().prefix(4))

        return questions.shuffled()
    }

    private static func factQuestions() -> [QuizQuestion] {
        var out: [QuizQuestion] = []
        let all = SpeciesData.all

        // Which group does X belong to?
        if let s = all.randomElement() {
            let wrongGroups = BirdGroupKind.allCases.filter { $0 != s.group }.shuffled().prefix(3)
            var options = wrongGroups.map { $0.title }
            let ci = Int.random(in: 0...3)
            options.insert(s.group.title, at: ci)
            out.append(QuizQuestion(
                kind: .nameToFact,
                prompt: "The \(s.name) belongs to which group?",
                artName: nil,
                options: options,
                correctIndex: ci,
                explanation: s.group.blurb
            ))
        }

        // Song matching
        let songBirds = all.shuffled().prefix(4)
        if let target = songBirds.first {
            var options = songBirds.dropFirst().map { $0.name }
            let ci = Int.random(in: 0...3)
            options.insert(target.name, at: ci)
            out.append(QuizQuestion(
                kind: .nameToFact,
                prompt: "Whose voice is this? \u{201C}\(shortSong(target.song))\u{201D}",
                artName: nil,
                options: Array(options),
                correctIndex: ci,
                explanation: "\(target.name): \(target.song)"
            ))
        }

        // Seasonal question
        let seasonal = all.filter { !$0.isYearRound }.shuffled()
        let residents = all.filter { $0.isYearRound }.shuffled()
        if let s = seasonal.first, residents.count >= 3 {
            var options = residents.prefix(3).map { $0.name }
            let ci = Int.random(in: 0...3)
            options.insert(s.name, at: ci)
            out.append(QuizQuestion(
                kind: .nameToFact,
                prompt: "Which of these birds is a seasonal visitor rather than a year-round resident?",
                artName: nil,
                options: Array(options),
                correctIndex: ci,
                explanation: "The \(s.name) is a \(s.seasonLabel.lowercased()) bird in most backyards; the others stay all year."
            ))
        }

        // Fun-fact attribution
        if let s = all.randomElement() {
            let wrong = all.filter { $0.id != s.id }.shuffled().prefix(3)
            var options = wrong.map { $0.name }
            let ci = Int.random(in: 0...3)
            options.insert(s.name, at: ci)
            out.append(QuizQuestion(
                kind: .nameToFact,
                prompt: "Which species does this describe? \u{201C}\(s.funFact)\u{201D}",
                artName: nil,
                options: options,
                correctIndex: ci,
                explanation: "That is the \(s.name)."
            ))
        }

        // Diet question
        if let s = all.randomElement() {
            let wrong = all.filter { $0.id != s.id }.shuffled().prefix(3)
            var options = wrong.map { $0.name }
            let ci = Int.random(in: 0...3)
            options.insert(s.name, at: ci)
            out.append(QuizQuestion(
                kind: .nameToFact,
                prompt: "Whose menu is this? \u{201C}\(s.diet)\u{201D}",
                artName: nil,
                options: options,
                correctIndex: ci,
                explanation: "That diet belongs to the \(s.name)."
            ))
        }

        return out
    }

    private static func shortSong(_ song: String) -> String {
        if song.count <= 90 { return song }
        let cut = song.prefix(90)
        if let lastSpace = cut.lastIndex(of: " ") {
            return String(cut[..<lastSpace]) + "..."
        }
        return String(cut) + "..."
    }
}
