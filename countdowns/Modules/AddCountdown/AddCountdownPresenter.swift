import Foundation
import Combine

class AddCountdownPresenter: ObservableObject {
  
  @Published var name = ""
  @Published var date = Date()
  @Published var disabled = true
  
  @Inject private var repository: CountdownsRepository
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    Publishers.CombineLatest($name, $date)
      .sink { (name, date) in
        self.disabled = name.isEmpty
      }
      .store(in: &cancellables)
  }
  
  func userAdd() {
    let countdown = Countdown(name: self.name, date: self.date)
    self.repository.add(countdown: countdown)
  }
  
}
