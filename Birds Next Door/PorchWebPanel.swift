import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Privacy Policy")
                    .font(Aviary.body(17, .bold))
                    .foregroundColor(Aviary.ink)
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    ZStack {
                        Circle().fill(Aviary.creamDark).frame(width: 30, height: 30)
                        CloseIcon(size: 11, color: Aviary.ink)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Aviary.cream)

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Your Privacy")
                        .font(Aviary.title(22))
                        .foregroundColor(Aviary.ink)
                    policyBlock(
                        "Everything stays on your device",
                        "Birds Next Door is a fully offline app. Your life list, sightings, places, notes, quiz scores, and badges are stored only on this device and never leave it."
                    )
                    policyBlock(
                        "No accounts, no tracking",
                        "The app requires no account and collects no personal information. There are no analytics, no advertising identifiers, and no third-party tracking of any kind."
                    )
                    policyBlock(
                        "No special permissions",
                        "Birds Next Door does not request access to your location, camera, photos, contacts, or notifications."
                    )
                    policyBlock(
                        "Deleting your data",
                        "You can erase everything at any time with the Reset All Data option in the More tab, or by deleting the app. Because nothing is stored elsewhere, removal is immediate and complete."
                    )
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.white)
        }
        .preferredColorScheme(.light)
    }

    private func policyBlock(_ title: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(Aviary.body(15, .bold))
                .foregroundColor(Aviary.forest)
            Text(text)
                .font(Aviary.body(14))
                .foregroundColor(Aviary.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
