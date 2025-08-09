import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Image(systemName: "doc.text.magnifyingglass").font(.system(size: 54))
                Text("BillPro — iOS 15 Minimal").font(.headline)
                Text("Build OK · TrollStore IPA").foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("BillPro")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
