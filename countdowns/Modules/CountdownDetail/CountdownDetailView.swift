import SwiftUI

struct CountdownDetailView: View {
  @ObservedObject var presenter: CountdownDetailPresenter
  
  @State var option = 0
  
  var body: some View {
    Form {
      Section {
        TextField("Name", text: $presenter.name)
      }
      
      Section {
        Picker(selection: $presenter.dateOption, label: Text("")) {
          Text("By date").tag(0)
          Text("By number").tag(1)
        }.pickerStyle(SegmentedPickerStyle())
        
        if presenter.dateOption == 0 {
          DatePicker(selection: $presenter.date, displayedComponents: .date) {
            Text("Date:")
          }
        } else {
          Stepper(onIncrement: {
            self.presenter.numberOfDays += 1
          }, onDecrement: {
            self.presenter.numberOfDays -= 1
          }) {
            Text("\(presenter.numberOfDays) days")
          }
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
