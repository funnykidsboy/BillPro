import UIKit

final class PrintShareService: NSObject, UIActivityItemSource {
    private let shareURL: URL

    init(url: URL) {
        self.shareURL = url
    }

    func present(from viewController: UIViewController? = nil) {
        let items: [Any] = [self]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)

        if let host = viewController {
            host.present(vc, animated: true)
            return
        }
        // iOS 15+: lấy windowScene hiện tại
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
