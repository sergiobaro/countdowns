import SwiftUI

struct CountdownsListView: View {
  
  @State private var items = {
    (0...30).map { "Countdown \($0)" }
  }()
  
  @State private var showAddCountdown = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(self.items, id: \.self) { item in
          NavigationLink(destination: EditCountdownView(title: item)) {
            Text(item)
          }
        }
        .onDelete(perform: { index in
          self.items.remove(at: index.first!)
        })
      }
      .navigationBarTitle("Countdowns")
      .navigationBarItems(trailing:
        Button(action: { self.showAddCountdown = true }) {
          Image(systemName: "plus.circle")
            .font(.title)
        }
        .sheet(isPresented: self.$showAddCountdown) {
          AddCountdownView()
        }
      )
    }
  }
}

struct CountdownsListView_Previews: PreviewProvider {
  static var previews: some View {
    CountdownsListView()
  }
}
