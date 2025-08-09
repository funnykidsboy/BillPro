import SwiftUI
import CoreData

struct ItemPickerView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CatalogItem.name, ascending: true)])
    private var items: FetchedResults<CatalogItem>

    let onPick: (CatalogItem) -> Void
    @State private var search = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(filtered, id: \.id) { it in
                    Button {
                        onPick(it)
                    } label: {
                        HStack {
                            Text(it.name)
                            Spacer()
                            Text(Currency.string(it.defaultPrice as Decimal)).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .searchable(text: $search, prompt: "Tìm mặt hàng")
            .navigationBarTitle("Kho mặt hàng")
            .navigationBarItems(trailing:
                NavigationLink("Thêm") { CatalogItemEditorView() }
            )
        }
    }

    var filtered: [CatalogItem] {
        guard !search.isEmpty else { return Array(items) }
        return items.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }
}

struct CatalogItemEditorView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    @State private var name = ""
    @State private var price = "0"

    var body: some View {
        Form {
            TextField("Tên mặt hàng", text: $name)
            TextField("Giá mặc định", text: $price).keyboardType(.decimalPad)
        }
        .navigationBarTitle("Thêm mặt hàng", displayMode: .inline)
        .navigationBarItems(trailing: Button("Lưu") {
            let it = CatalogItem(context: context)
            it.id = UUID()
            it.name = name
            it.defaultPrice = NSDecimalNumber(string: price)
            it.unit = "cái"
            it.isActive = true
            try? context.save()
            presentation.wrappedValue.dismiss()
        }.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty))
    }
}
