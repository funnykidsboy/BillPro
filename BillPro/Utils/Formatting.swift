import Foundation

enum Currency {
    static let vndFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "VND"
        f.maximumFractionDigits = 0
        f.minimumFractionDigits = 0
        return f
    }()
    static func string(_ d: Decimal) -> String {
        vndFormatter.string(from: NSDecimalNumber(decimal: d)) ?? "\(d) ₫"
    }
}
extension Date {
    func toString(_ format: String = "dd/MM/yyyy") -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}
