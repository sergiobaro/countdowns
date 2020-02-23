import SwiftUI

struct AddCountdownView: View {
  
  @ObservedObject private var presenter = AddCountdownPresenter()
  
  var body: some View {
    NavigationView {
      Form {
        CountdownView(
          name: $presenter.name,
          date: $presenter.date
        )
        
        Section {
          HStack {
            Spacer()
            Button(action: {
              self.presenter.userAdd()
            }) {
              Text("Add")
            }
            .disabled(presenter.addDisabled)
            Spacer()
          }
        }
      }
      .navigationBarTitle("Add Countdown")
    }
  }
}

struct AddCountdownView_Previews: PreviewProvider {
  static var previews: some View {
    AddCountdownView()
  }
}
