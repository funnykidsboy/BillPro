import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "shippingbox").font(.system(size: 56))
            Text("BillPro Minimal").font(.headline)
            Text("iOS 15 • TrollStore IPA").foregroundColor(.secondary)
        }
        .padding()
    }
}
