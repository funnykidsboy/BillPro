import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {}

@objc(OrderItem)
public class OrderItem: NSManagedObject {}

@objc(CatalogItem)
public class CatalogItem: NSManagedObject {}

extension Order {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> { NSFetchRequest<Order>(entityName: "Order") }
    @NSManaged public var id: UUID
    @NSManaged public var customerName: String
    @NSManaged public var customerPhone: String
    @NSManaged public var deliveryDate: Date
    @NSManaged public var createdAt: Date
    @NSManaged public var discountValue: NSDecimalNumber
    @NSManaged public var discountType: String // "amount" | "percent"
    @NSManaged public var note: String?
    @NSManaged public var items: NSSet?

    var itemsArray: [OrderItem] { (items as? Set<OrderItem> ?? []).sorted { $0.createdAt < $1.createdAt } }

    var subtotal: Decimal { itemsArray.reduce(Decimal(0)) { $0 + $1.amount } }
    var totalQuantity: Decimal { itemsArray.reduce(0 as Decimal) { total, item in total + (item.quantity?.decimalValue ?? 0) } } } }
    var discountComputed: Decimal {
        let sub = subtotal
        let val = discountValue as Decimal
        if discountType == "percent" {
            return sub * val / 100
        }
        return val
    }
    var total: Decimal { max(0, subtotal - discountComputed) }
}

extension OrderItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderItem> { NSFetchRequest<OrderItem>(entityName: "OrderItem") }
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var unitPrice: NSDecimalNumber
    @NSManaged public var quantity: NSDecimalNumber
    @NSManaged public var createdAt: Date
    @NSManaged public var order: Order?

    var amount: Decimal { (unitPrice as Decimal) * (quantity as Decimal) }
}

extension CatalogItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatalogItem> { NSFetchRequest<CatalogItem>(entityName: "CatalogItem") }
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var defaultPrice: NSDecimalNumber
    @NSManaged public var unit: String
    @NSManaged public var isActive: Bool
}

// Decimal ops
extension Decimal {
    static func * (lhs: Decimal, rhs: Decimal) -> Decimal { NSDecimalNumber(decimal: lhs).multiplying(by: NSDecimalNumber(decimal: rhs)).decimalValue }
    static func + (lhs: Decimal, rhs: Decimal) -> Decimal { NSDecimalNumber(decimal: lhs).adding(NSDecimalNumber(decimal: rhs)).decimalValue }
    static func - (lhs: Decimal, rhs: Decimal) -> Decimal { NSDecimalNumber(decimal: lhs).subtracting(NSDecimalNumber(decimal: rhs)).decimalValue }
    static func / (lhs: Decimal, rhs: Decimal) -> Decimal { NSDecimalNumber(decimal: lhs).dividing(by: NSDecimalNumber(decimal: rhs)).decimalValue }
}

extension NSDecimalNumber {
    static func from(_ d: Decimal) -> NSDecimalNumber { NSDecimalNumber(decimal: d) }
}
