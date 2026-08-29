import Foundation
import UIKit

@MainActor
final class FacebookLoginManager: ObservableObject {
    @Published private(set) var didOpenFacebook = false

    func openFacebookLogin() {
        guard let url = URL(string: "https://www.facebook.com/login/") else { return }
        UIApplication.shared.open(url)
        didOpenFacebook = true
    }

    func openHelp() {
        guard let url = URL(string: "https://www.facebook.com/help/") else { return }
        UIApplication.shared.open(url)
    }
}
