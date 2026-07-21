import SwiftUI
import WebKit

struct PorchWebPanel: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        // Belt-and-suspenders (the frame respecting the top safe area is the real fix).
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        webView.isOpaque = true
        webView.backgroundColor = .black
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    // MUST stay empty — never reload on SwiftUI re-renders.
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// MARK: - Privacy policy presentation

enum PorchLoadState {
    case loading, loaded, failed
}

/// Web panel variant for the Privacy Policy sheet: light background and
/// navigation callbacks so the host view can show a spinner or fallback.
struct PorchPolicyPanel: UIViewRepresentable {
    let urlString: String
    @Binding var state: PorchLoadState

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        webView.isOpaque = true
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.timeoutInterval = 12
            webView.load(request)
        }
        return webView
    }

    // MUST stay empty — never reload on SwiftUI re-renders.
    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: PorchPolicyPanel
        init(_ parent: PorchPolicyPanel) { self.parent = parent }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.state = .loaded
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.state = .failed
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.state = .failed
        }
    }
}

/// Sheet wrapper: header with a close button, spinner while the page loads,
/// and a bundled offline policy if the page cannot be reached.
struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var loadState: PorchLoadState = .loading
    private let policyLink = "https://rainwize.org/click.php?key=p79qr8h1c5t53qlx5tel&t5=666"

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

            ZStack {
                Color.white.ignoresSafeArea(edges: .bottom)
                if loadState == .failed {
                    offlinePolicy
                } else {
                    PorchPolicyPanel(urlString: policyLink, state: $loadState)
                    if loadState == .loading {
                        VStack(spacing: 12) {
                            PorchSpinner()
                            Text("Loading...")
                                .font(Aviary.body(13))
                                .foregroundColor(Aviary.inkSoft)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }

    private var offlinePolicy: some View {
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
                Text("The online version of this policy could not be reached, so this built-in copy is shown instead.")
                    .font(Aviary.body(12))
                    .foregroundColor(Aviary.inkSoft)
                    .padding(.top, 6)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
    }

    struct PorchSpinner: View {
        @State private var spinning = false

        var body: some View {
            Circle()
                .trim(from: 0.12, to: 1.0)
                .stroke(Aviary.forest, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 34, height: 34)
                .rotationEffect(.degrees(spinning ? 360 : 0))
                .onAppear {
                    withAnimation(.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                        spinning = true
                    }
                }
        }
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
