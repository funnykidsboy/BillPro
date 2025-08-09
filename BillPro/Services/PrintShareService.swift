import UIKit

final class PrintShareService: NSObject, UIActivityItemSource {
    static let shared = PrintShareService()
    private var shareURL: URL?

    func printFile(url: URL) {
        let controller = UIPrintInteractionController.shared
        controller.printingItem = url
        controller.present(animated: true, completionHandler: nil)
    }

    func share(url: URL) {
        shareURL = url
        let vc = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any { shareURL as Any }
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any { shareURL as Any }
}
