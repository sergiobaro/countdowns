import Foundation
import Combine

class CountdownDetailPresenter: ObservableObject {
  
  @Published var name = ""
  @Published var date = Date()
  @Published var disabled = true
  
  @Inject private var repository: CountdownsRepository
  private var countdown: Countdown?
  private var cancellables = Set<AnyCancellable>()
  
  init(countdownId: UUID) {
    self.countdown = self.repository.countdown(countdownId: countdownId)
    
    if let countdown = self.countdown {
      self.name = countdown.name
      self.date = countdown.date
    }
    
    Publishers.CombineLatest($name, $date)
      .sink { [weak self] (name, date) in
        guard let self = self else { return }
        self.disabled = self.isDisabled(name: name, date: date)
      }
      .store(in: &cancellables)
  }
  
  func userSave() {
    guard var countdown = self.countdown else {
      return
    }
    
    countdown.name = self.name
    countdown.date = self.date
    countdown.updatedAt = Date()
    
    self.repository.update(countdown: countdown)
  }
}

private extension CountdownDetailPresenter {
  
  func isDisabled(name: String, date: Date) -> Bool {
    if name.isEmpty {
      return true
    }
    guard let countdown = self.countdown else {
      return true
    }
    if name == countdown.name && date == countdown.date {
      return true
    }
    
    return false
  }
}
