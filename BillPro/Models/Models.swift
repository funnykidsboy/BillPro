import Foundation

struct Item: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var unitPrice: Decimal
    var quantity: Decimal
    var amount: Decimal { unitPrice * quantity }
}

struct Order: Identifiable, Hashable {
    let id: UUID = UUID()
    var customerName: String
    var phone: String
    var deliveryDate: Date
    var items: [Item] = []
    var discountValue: Decimal = 0
    var isPercent: Bool = false

    var totalQuantity: Decimal { items.reduce(0 as Decimal) { $0 + $1.quantity } }
    var subtotal: Decimal { items.reduce(0 as Decimal) { $0 + $1.amount } }
    var discountComputed: Decimal {
        if isPercent {
            let p = max(0, min(discountValue, 100))
            return (subtotal * p) / 100
        } else {
            return max(0, discountValue)
        }
    }
    var total: Decimal {
        let t = subtotal - discountComputed
        return t > 0 ? t : 0
    }
}
