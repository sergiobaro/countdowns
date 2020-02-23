import Foundation
import Combine

class AddCountdownPresenter: ObservableObject {
  
  @Published var name = ""
  @Published var date = Date()
  @Published var addDisabled = true
  
  @Inject private var repository: CountdownsRepository
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    self.date = Calendar.current.date(from: components)!
    
    Publishers.CombineLatest($name, $date)
      .sink { (name, _) in
        self.addDisabled = name.isEmpty
      }
      .store(in: &cancellables)
  }
  
  func userAdd() {
    let countdown = Countdown(
      countdownId: UUID(),
      name: self.name,
      date: self.date,
      createdAt: Date(),
      updatedAt: nil
    )
    self.repository.add(countdown: countdown)
  }
  
}
