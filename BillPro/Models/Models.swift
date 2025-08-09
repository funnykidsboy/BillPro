import Foundation

struct Item: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var unitPrice: Decimal
    var quantity: Decimal
    var amount: Decimal { unitPrice * quantity }
}

struct Order: Identifiable, Hashable {
    let id = UUID()
    var customerName: String
    var phone: String
    var deliveryDate: Date
    var items: [Item] = []
    var discountValue: Decimal = 0

    var totalQuantity: Decimal { items.reduce(0 as Decimal) { $0 + $1.quantity } }
    var subtotal: Decimal      { items.reduce(0 as Decimal) { $0 + $1.amount } }
    var discountComputed: Decimal { max(0, discountValue) }
    var total: Decimal { max(0, subtotal - discountComputed) }
}
