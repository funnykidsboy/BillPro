import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var orders: [Order] = [
        Order(
            customerName: "Nguyễn Văn A",
            phone: "0900000000",
            deliveryDate: Date(),
            items: [
                Item(name: "Áo thun", unitPrice: 120_000, quantity: 2),
                Item(name: "Quần jean", unitPrice: 350_000, quantity: 1)
            ],
            discountValue: 0
        )
    ]

    private var filtered: [Order] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty { return orders }
        return orders.filter { $0.customerName.lowercased().contains(q) || $0.phone.lowercased().contains(q) }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filtered) { order in
                    NavigationLink(destination: InvoiceView(order: order)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(order.customerName).font(.headline)
                            HStack {
                                Text(order.phone).foregroundColor(.secondary)
                                Spacer()
                                Text(order.deliveryDate, style: .date).foregroundColor(.secondary)
                            }.font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Đơn hàng")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}
