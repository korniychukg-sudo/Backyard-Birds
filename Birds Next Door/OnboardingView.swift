import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var page = 0

    private let pages: [(art: String, title: String, message: String)] = [
        ("bird_northernCardinal",
         "Meet Your Neighbors",
         "An illustrated field guide to 40 backyard birds — how they look, what they eat, and what to listen for."),
        ("bird_americanGoldfinch",
         "Keep a Life List",
         "Log every sighting with its date and place. Watch your personal list grow from first lifer to full guide."),
        ("bird_blueJay",
         "Learn as You Go",
         "Seasonal highlights, birding tips, a glossary, and a ten-question ID quiz to sharpen your eye."),
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Aviary.cream, Aviary.creamDark],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip") { onFinish() }
                        .font(Aviary.body(14, .semibold))
                        .foregroundColor(Aviary.inkSoft)
                        .padding(.trailing, 20)
                        .padding(.top, 12)
                }

                TabView(selection: $page) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        VStack(spacing: 22) {
                            BirdArtView(name: pages[i].art)
                                .frame(width: 250, height: 250)
                                .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 6)
                            Text(pages[i].title)
                                .font(Aviary.title(26))
                                .foregroundColor(Aviary.ink)
                            Text(pages[i].message)
                                .font(Aviary.body(15))
                                .foregroundColor(Aviary.inkSoft)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 36)
                        }
                        .tag(i)
                        .padding(.bottom, 30)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Capsule()
                            .fill(i == page ? Aviary.forest : Aviary.line)
                            .frame(width: i == page ? 22 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.2), value: page)
                    }
                }
                .padding(.bottom, 22)

                Button(page == pages.count - 1 ? "Start Watching" : "Continue") {
                    if page < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.25)) { page += 1 }
                    } else {
                        onFinish()
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 26)
                .frame(maxWidth: 420)
            }
        }
    }
}
