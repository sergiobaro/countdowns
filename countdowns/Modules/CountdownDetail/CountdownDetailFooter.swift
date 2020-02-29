import SwiftUI

struct CountdownDetailFooter: View {
  
  @Binding var footer: String
  @Binding var saveDisabled: Bool
  var onSave: () -> Void
  var onReset: () -> Void
  
  var body: some View {
    Section(footer: Text(footer)) {
      HStack {
        Spacer()
        Button(action: onSave) {
          Text("Save")
        }
        .disabled(saveDisabled)
        Spacer()
      }
      HStack {
        Spacer()
        Button(action: onReset) {
          Text("Reset to now")
        }
        Spacer()
      }
    }
  }
}

struct CountdownDetailFooter_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      CountdownDetailFooter(
        footer: .constant("This is the footer\nThis is even more footer"),
        saveDisabled: .constant(false),
        onSave: { },
        onReset: { }
      )
    }
  }
}
