import SwiftUI

struct CountdownView: View {
  
  @Binding var name: String
  @Binding var date: Date
  
  var body: some View {
    Group {
      Section {
        TextField("Name", text: $name)
      }
      
      Section {
        DatePicker(selection: $date, displayedComponents: .date) {
          Text("Date:")
        }
      }
    }
  }
}

struct CountdownView_Previews: PreviewProvider {
  static var previews: some View {
    CountdownView(
      name: .constant("Name"),
      date: .constant(Date())
    )
  }
}
