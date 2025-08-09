import SwiftUI

private func currencyString(_ value: Decimal) -> String {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    nf.currencyCode = "VND"
    nf.maximumFractionDigits = 0
    return nf.string(from: value as NSDecimalNumber) ?? "\(value)"
}

struct InvoiceView: View {
    let order: Order

    var body: some View {
        List {
            Section(header: Text("Khách hàng")) {
                Text(order.customerName)
                Text(order.phone)
                Text(order.deliveryDate, style: .date)
            }

            Section(header: Text("Hóa đơn")) {
                HStack {
                    Text("STT").frame(width: 40, alignment: .leading)
                    Text("Item").frame(maxWidth: .infinity, alignment: .leading)
                    Text("Price").frame(width: 90, alignment: .trailing)
                    Text("Q").frame(width: 40, alignment: .trailing)
                    Text("Amount").frame(width: 110, alignment: .trailing)
                }
                .font(.caption)
                .foregroundColor(.secondary)

                ForEach(Array(order.items.enumerated()), id: \.element.id) { idx, it in
                    HStack {
                        Text("\(idx+1)").frame(width: 40, alignment: .leading)
                        Text(it.name).frame(maxWidth: .infinity, alignment: .leading)
                        Text(currencyString(it.unitPrice)).frame(width: 90, alignment: .trailing)
                        Text("\(NSDecimalNumber(decimal: it.quantity))").frame(width: 40, alignment: .trailing)
                        Text(currencyString(it.amount)).frame(width: 110, alignment: .trailing)
                    }
                    .font(.callout)
                }

                HStack {
                    Text("Total Quantity"); Spacer()
                    Text("\(NSDecimalNumber(decimal: order.totalQuantity))")
                }
                HStack {
                    Text("Discount"); Spacer()
                    Text(currencyString(order.discountComputed)).underline()
                }
                HStack {
                    Text("Total Amount").font(.headline); Spacer()
                    Text(currencyString(order.total)).font(.headline)
                }
            }
        }
        .navigationTitle("Invoice")
    }
}
