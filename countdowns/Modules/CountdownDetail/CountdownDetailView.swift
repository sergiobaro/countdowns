import SwiftUI

struct CountdownDetailView: View {
  
  @ObservedObject var presenter: CountdownDetailPresenter
  
  var body: some View {
    NavigationView {
      Form {
        CountdownView(
          name: $presenter.name,
          date: $presenter.date
        )
        CountdownDetailFooter(
          footer: self.$presenter.footer,
          saveDisabled: self.$presenter.saveDisabled,
          onSave: self.presenter.userSave,
          onReset: self.presenter.userReset
        )
      }
      .navigationBarTitle("Edit Countdown")
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
