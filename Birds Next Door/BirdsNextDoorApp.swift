import SwiftUI

@main
struct BirdsNextDoorApp: App {
    @StateObject private var store = BirdStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if !store.onboardingSeen {
                    OnboardingView {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            store.markOnboardingSeen()
                        }
                    }
                } else {
                    RootView()
                        .environmentObject(store)
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
