import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Order.createdAt, ascending: false)])
    private var orders: FetchedResults<Order>

    @State private var searchText = ""
    @State private var showNewOrder = false

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredOrders, id: \.id) { order in
                    NavigationLink(destination: InvoiceView(order: order)) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(order.customerName).font(.headline)
                                Spacer()
                                Text(Currency.string(order.total))
                                    .font(.subheadline)
                            }
                            HStack(spacing: 12) {
                                Label(order.customerPhone, systemImage: "phone")
                                Label(order.deliveryDate.toString(), systemImage: "calendar")
                            }
                            .font(.caption).foregroundColor(.secondary)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            context.delete(order)
                            try? context.save()
                        } label: { Label("Xoá", systemImage: "trash") }
                    }
                }
            }
            .navigationBarTitle("Đơn hàng")
            .navigationBarItems(trailing: Button(action: { showNewOrder = true }) { Image(systemName: "plus.circle.fill") })
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Tìm tên hoặc SĐT")
            .sheet(isPresented: $showNewOrder) {
                OrderEditorView()
                    .environment(\.managedObjectContext, context)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var filteredOrders: [Order] {
        orders.filter { o in
            searchText.isEmpty ||
            o.customerName.localizedCaseInsensitiveContains(searchText) ||
            o.customerPhone.localizedCaseInsensitiveContains(searchText)
        }
    }
}
