import SwiftUI

struct AddCountdownView: View {
  
  @ObservedObject private var presenter = AddCountdownPresenter()
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Name", text: $presenter.name)
          DatePicker(selection: $presenter.date, displayedComponents: .date) {
            Text("Date")
          }
          DatePicker(selection: $presenter.date, displayedComponents: .hourAndMinute) {
            Text("Time")
          }
        }
        Section {
          HStack {
            Spacer()
            Button(action: {
              self.presenter.userAdd()
            }) {
              Text("Add")
            }
            .disabled(presenter.disabled)
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
