import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: BirdStore
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case 0:
                    NavigationView { HomeView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                case 1:
                    NavigationView { GuideView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                case 2:
                    NavigationView { LifeListView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                case 3:
                    NavigationView { LearnView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                default:
                    NavigationView { MoreView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom tab bar — HStack of buttons, no system TabView.
            HStack(spacing: 0) {
                tabButton(index: 0, label: "Today") { active in
                    AnyView(SunGlyph(size: 23, color: active ? Aviary.forest : Aviary.inkSoft.opacity(0.55)))
                }
                tabButton(index: 1, label: "Guide") { active in
                    AnyView(BookGlyph(size: 23, color: active ? Aviary.forest : Aviary.inkSoft.opacity(0.55)))
                }
                tabButton(index: 2, label: "Life List") { active in
                    AnyView(PorchGlyph(size: 23, color: active ? Aviary.forest : Aviary.inkSoft.opacity(0.55)))
                }
                tabButton(index: 3, label: "Learn") { active in
                    AnyView(BulbGlyph(size: 23, color: active ? Aviary.forest : Aviary.inkSoft.opacity(0.55)))
                }
                tabButton(index: 4, label: "More") { active in
                    AnyView(DotsGlyph(size: 23, color: active ? Aviary.forest : Aviary.inkSoft.opacity(0.55)))
                }
            }
            .padding(.top, 9)
            .padding(.bottom, 5)
            .background(
                Aviary.card
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: -3)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .background(Aviary.cream.ignoresSafeArea())
    }

    private func tabButton(index: Int, label: String, icon: @escaping (Bool) -> AnyView) -> some View {
        let active = selectedTab == index
        return Button {
            selectedTab = index
        } label: {
            VStack(spacing: 3) {
                icon(active)
                    .frame(height: 24)
                Text(label)
                    .font(Aviary.body(10, active ? .bold : .medium))
                    .foregroundColor(active ? Aviary.forest : Aviary.inkSoft.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
