import SwiftUI

struct FeatherLaunchScreen: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Aviary.cream, Aviary.creamDark],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Aviary.sage.opacity(0.18))
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulse ? 1.08 : 0.94)
                    BirdGlyph(size: 64, color: Aviary.forest)
                }
                Text("Backyard Birds")
                    .font(Aviary.title(28))
                    .foregroundColor(Aviary.ink)
                Text("Loading your field guide...")
                    .font(Aviary.body(14))
                    .foregroundColor(Aviary.inkSoft)
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
