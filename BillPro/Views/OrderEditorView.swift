import SwiftUI
import CoreData

struct OrderEditorView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation

    @State private var name = ""
    @State private var phone = ""
    @State private var date = Date()
    @State private var note = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Khách hàng")) {
                    TextField("Tên khách", text: $name)
                    TextField("Số điện thoại", text: $phone).keyboardType(.phonePad)
                    DatePicker("Ngày giao", selection: $date, displayedComponents: .date)
                    TextField("Ghi chú", text: $note)
                }
            }
            .navigationBarTitle("Thêm đơn hàng", displayMode: .inline)
            .navigationBarItems(leading: Button("Huỷ") { presentation.wrappedValue.dismiss() },
                                trailing: Button("Lưu") { save() }.disabled(!valid))
        }
    }

    var valid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    func save() {
        let order = Order(context: context)
        order.id = UUID()
        order.customerName = name
        order.customerPhone = phone
        order.deliveryDate = date
        order.createdAt = Date()
        order.discountValue = .from(0)
        order.discountType = "amount"
        order.note = note.isEmpty ? nil : note
        do { try context.save() } catch { print(error) }
        presentation.wrappedValue.dismiss()
    }
}
