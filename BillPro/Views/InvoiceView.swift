import SwiftUI
import CoreData
import UIKit

struct InvoiceView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation

    @ObservedObject var order: Order
    @State private var showAddItem = false
    @State private var showCalc = false

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            table
            Divider()
            footerTotals
            toolbarBottom
        }
        .navigationBarTitle("Hoá đơn", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { presentation.wrappedValue.dismiss() }) { Image(systemName: "chevron.left") },
                            trailing: Button(action: { showAddItem = true }) { Image(systemName: "plus") })
        .sheet(isPresented: $showAddItem) { ItemEditorSheet(order: order) }
        .sheet(isPresented: $showCalc) {
            CalculatorOverlay(isPresented: $showCalc, result: Binding(get: {
                order.discountValue as Decimal
            }, set: { newValue in
                order.discountType = "amount"
                order.discountValue = .from(newValue)
                try? context.save()
            }))
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(order.customerName).font(.title3).bold()
            HStack {
                Label(order.customerPhone, systemImage: "phone")
                Label(order.deliveryDate.toString(), systemImage: "calendar")
                Spacer()
                Text("Tổng: " + Currency.string(order.total)).font(.headline)
            }.font(.caption)
        }.padding()
    }

    private var table: some View {
        List {
            Section {
                HStack {
                    Text("STT").frame(width: 40, alignment: .leading)
                    Text("Item").frame(maxWidth: .infinity, alignment: .leading)
                    Text("Price").frame(width: 90, alignment: .trailing)
                    Text("Q").frame(width: 40, alignment: .trailing)
                    Text("Amount").frame(width: 110, alignment: .trailing)
                }
                .font(.caption).foregroundColor(.secondary)
                ForEach(Array(order.itemsArray.enumerated()), id: \.element.id) { (idx, item) in
                    HStack {
                        Text("\(idx+1)").frame(width: 40, alignment: .leading)
                        Text(item.name).frame(maxWidth: .infinity, alignment: .leading)
                        Text(Currency.string(item.unitPrice as Decimal)).frame(width: 90, alignment: .trailing)
                        Text("\(item.quantity)").frame(width: 40, alignment: .trailing)
                        Text(Currency.string(item.amount)).frame(width: 110, alignment: .trailing)
                    }
                    .contextMenu {
                        Button("Sửa") { /* left as exercise */ }
                        Button("Copy") { copy(item) }
                        Button("Xoá", role: .destructive) { remove(item) }
                    }
                    .swipeActions {
                        Button("Copy") { copy(item) }.tint(.blue)
                        Button("Xoá", role: .destructive) { remove(item) }
                    }
                }
            }
        }.listStyle(.plain)
    }

    private var footerTotals: some View {
        VStack(spacing: 8) {
            HStack { Text("Total Quantity"); Spacer(); Text("\(order.totalQuantity as NSDecimalNumber)") }
            HStack {
                Text("Discount"); Spacer()
                Button(action: { showCalc = true }) {
                    Text(Currency.string(order.discountComputed)).underline()
                }
            }
            HStack { Text("Total Amount").font(.headline); Spacer(); Text(Currency.string(order.total)).font(.headline) }
        }.padding()
    }

    private var toolbarBottom: some View {
        HStack {
            Button { /* multi-delete placeholder */ } label: { Label("Xoá", systemImage: "trash") }
            Spacer()
            Button { /* search in list placeholder */ } label: { Label("Tìm", systemImage: "magnifyingglass") }
            Spacer()
            Button { printInvoice() } label: { Label("In", systemImage: "printer") }
            Spacer()
            Button { sharePDF() } label: { Label("Share", systemImage: "square.and.arrow.up") }
        }
        .padding().background(.ultraThinMaterial)
    }

    func copy(_ item: OrderItem) {
        let new = OrderItem(context: context)
        new.id = UUID()
        new.name = item.name
        new.unitPrice = item.unitPrice
        new.quantity = item.quantity
        new.createdAt = Date()
        new.order = order
        try? context.save()
    }

    func remove(_ item: OrderItem) {
        context.delete(item)
        try? context.save()
    }

    func printInvoice() {
        if let url = PDFService.shared.makeInvoicePDF(for: order) {
            PrintShareService.shared.printFile(url: url)
        }
    }
    func sharePDF() {
        if let url = PDFService.shared.makeInvoicePDF(for: order) {
            PrintShareService.shared.share(url: url)
        }
    }
}

struct ItemEditorSheet: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    @ObservedObject var order: Order
    @State private var name = ""
    @State private var qty = "1"
    @State private var price = "0"
    @State private var showPicker = false

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    TextField("Tên mặt hàng", text: $name)
                    Button { showPicker = true } label: { Image(systemName: "magnifyingglass") }
                }
                TextField("Số lượng", text: $qty).keyboardType(.decimalPad)
                TextField("Đơn giá", text: $price).keyboardType(.decimalPad)
            }
            .navigationBarTitle("Thêm mặt hàng", displayMode: .inline)
            .navigationBarItems(leading: Button("Đóng") { presentation.wrappedValue.dismiss() },
                                trailing: Button("Lưu") {
                let q = NSDecimalNumber(string: qty)
                let p = NSDecimalNumber(string: price)
                let item = OrderItem(context: context)
                item.id = UUID()
                item.name = name
                item.quantity = q
                item.unitPrice = p
                item.createdAt = Date()
                item.order = order
                try? context.save()
                presentation.wrappedValue.dismiss()
            }.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty))
            .sheet(isPresented: $showPicker) {
                ItemPickerView { it in
                    name = it.name
                    price = it.defaultPrice.stringValue
                    showPicker = false
                }
                .environment(\.managedObjectContext, context)
            }
        }
    }
}
