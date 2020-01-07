import SwiftUI

struct EditCountdownView: View {
  
  let title: String
  
  var body: some View {
    Text(self.title)
      .navigationBarTitle("Edit Countdown")
  }
}

struct EditCountdownView_Previews: PreviewProvider {
  static var previews: some View {
    EditCountdownView(title: "Countdown 1")
  }
}
