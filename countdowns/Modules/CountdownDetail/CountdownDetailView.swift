import SwiftUI

struct CountdownDetailView: View {
  @ObservedObject var presenter: CountdownDetailPresenter
  
  var body: some View {
    Form {
      Section {
        TextField("Name", text: $presenter.name)
        DatePicker(selection: $presenter.date, displayedComponents: .date) {
          Text("Date:")
        }
      }
      Section(footer: Text(self.presenter.footer)) {
        HStack {
          Spacer()
          Button(action: {
            self.presenter.userSave()
          }) {
            Text("Save")
          }
          .disabled(presenter.disabled)
          Spacer()
        }
        HStack {
          Spacer()
          Button(action: {
            self.presenter.userReset()
          }) {
            Text("Reset")
          }
          Spacer()
        }
      }
    }
  }
}

struct CountdownDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CountdownDetailView(presenter: CountdownDetailPresenter(countdownId: UUID()))
    }
  }
}
