import SwiftUI

struct CountdownDetailView: View {
  
  @ObservedObject var presenter: CountdownDetailPresenter
  
  var body: some View {
    Form {
      CountdownView(
        name: $presenter.name,
        date: $presenter.date
      )
      
      Section(footer: Text(self.presenter.footer)) {
        HStack {
          Spacer()
          Button(action: {
            self.presenter.userSave()
          }) {
            Text("Save")
          }
          .disabled(presenter.saveDisabled)
          Spacer()
        }
        HStack {
          Spacer()
          Button(action: {
            self.presenter.userReset()
          }) {
            Text("Reset to now")
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
