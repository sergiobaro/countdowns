import SwiftUI

struct CountdownsListView: View {
  
  @ObservedObject var presenter = CountdownsListPresenter()
  
  @State private var showAddCountdown = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(self.presenter.countdowns) { countdown in
          NavigationLink(destination: CountdownDetailView(presenter: .init(countdownId: countdown.countdownId))) {
            HStack {
              Text(countdown.name)
              Spacer()
              Text(countdown.date)
                .font(.system(size: 12.0))
                .foregroundColor(.gray)
            }
          }
        }
        .onDelete(perform: { index in
          self.presenter.removeCountdown(at: index.first!)
        })
      }
      .navigationBarTitle("Countdowns")
      .navigationBarItems(trailing:
        Button(action: { self.showAddCountdown = true }) {
          Image(systemName: "plus.circle")
            .font(.title)
            .accentColor(.black)
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
