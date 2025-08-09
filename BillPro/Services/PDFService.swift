import Foundation
import PDFKit
import UIKit

final class PDFService {
    static let shared = PDFService()

    func makeInvoicePDF(for order: Order) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "BillPro",
            kCGPDFContextAuthor: "BillPro User",
            kCGPDFContextTitle: "Invoice " + order.customerName
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            let margin: CGFloat = 24
            var y: CGFloat = margin

            // Header
            "INVOICE".draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 22)])
            y += 32
            ("Customer: " + order.customerName).draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
            y += 18
            ("Phone: " + order.customerPhone).draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
            y += 18
            ("Delivery: " + order.deliveryDate.toString()).draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
            y += 24

            // Table header
            let cols = [0, 70, 220, 320, 360, 450].map { CGFloat($0) }
            let headers = ["", "STT","Item","Price","Q","Amount"]
            for i in 1..<headers.count {
                headers[i].draw(at: CGPoint(x: margin + cols[i], y: y), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
            }
            y += 16

            // Rows
            let items = order.itemsArray
            for (idx, it) in items.enumerated() {
                let values: [String] = [
                    "",
                    "\(idx+1)",
                    it.name,
                    Currency.string(it.unitPrice as Decimal),
                    it.quantity.stringValue,
                    Currency.string(it.amount)
                ]
                for i in 1..<values.count {
                    values[i].draw(at: CGPoint(x: margin + cols[i], y: y), withAttributes: [.font: UIFont.systemFont(ofSize: 11)])
                }
                y += 16
                if y > pageRect.height - 120 {
                    ctx.beginPage(); y = margin
                }
            }

            y += 12
            ("Total Quantity: " + order.totalQuantity.description).draw(at: CGPoint(x: margin + cols[2], y: y), withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
            y += 18
            ("Discount: " + Currency.string(order.discountComputed)).draw(at: CGPoint(x: margin + cols[2], y: y), withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
            y += 18
            ("Total Amount: " + Currency.string(order.total)).draw(at: CGPoint(x: margin + cols[2], y: y), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        }

        let dir = FileManager.default.temporaryDirectory.appendingPathComponent("invoices", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent("invoice_\(order.id).pdf")
        do { try data.write(to: url); return url } catch { print(error); return nil }
    }
}
