import UIKit

final class PrintShareService: NSObject, UIActivityItemSource {
    static let shared = PrintShareService()

    private var shareURL: URL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("dummy.txt")

    // MARK: - Public API
    func printFile(url: URL) {
        // iOS 15: dùng UIPrintInteractionController
        let pic = UIPrintInteractionController.shared
        pic.printingItem = url

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            pic.present(from: root.view.frame, in: root.view, animated: true, completionHandler: nil)
        }
    }

    func share(url: URL, from viewController: UIViewController? = nil) {
        self.shareURL = url
        let vc = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        if let host = viewController {
            host.present(vc, animated: true)
            return
        }
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(vc, animated: true)
        }
    }

    // MARK: - UIActivityItemSource
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return shareURL
    }
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return shareURL
    }
}
