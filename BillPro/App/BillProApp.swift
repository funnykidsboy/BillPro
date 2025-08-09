import SwiftUI

@main
struct BillProApp: App {
    let persistence = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
