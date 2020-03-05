
import SwiftUI

struct ContentView: View {
    let name: String
    var body: some View {
        print("Reloading", name)
        return Text(Date().description)
            .tabItem { Text(name) }
    }
}

fileprivate struct ReloadModifier<_Content: View>: ViewModifier {

    private let name = UUID().uuidString
    fileprivate let content: _Content
    fileprivate let timeInterval: TimeInterval
    @State private var lastUpdated = Date()

    private func updateLastUpdated()  {
        let update = lastUpdated.addingTimeInterval(timeInterval)
        let now = Date()
        guard update < now else { return }
        lastUpdated = now
    }

    func body(content: Content) -> some View {

        content
            .id(lastUpdated)
            .onAppear(perform: updateLastUpdated)
    }
}

extension View {

    func reload(after timeInterval: TimeInterval) -> some View {
        modifier(ReloadModifier(content: self, timeInterval: timeInterval))
    }
}
