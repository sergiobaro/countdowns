import Foundation
import Combine

class CountdownsMemoryRepository {
  
  private var countdowns = [Countdown]()
  
  private let subject = CurrentValueSubject<[Countdown], Never>([])
  
}

extension CountdownsMemoryRepository: CountdownsRepository {
  
  func add(countdown: Countdown) {
    self.countdowns.append(countdown)
    self.sendCountdowns()
  }
  
  func remove(countdownId: UUID) {
    guard let index = self.countdowns.firstIndex(where: { $0.countdownId == countdownId }) else {
      return
    }
    
    self.removeCountdown(at: index)
    self.sendCountdowns()
  }
  
  func allCountdowns() -> AnyPublisher<[Countdown], Never> {
    return self.subject.eraseToAnyPublisher()
  }
  
  func removeAll() {
    self.countdowns.removeAll()
    self.sendCountdowns()
  }
  
}

private extension CountdownsMemoryRepository {
  
  func sendCountdowns() {
    self.subject.send(self.countdowns.sorted(by: {
      $0.createdAt > $1.createdAt
    }))
  }
  
  func removeCountdown(at index: Int) {
    if self.countdowns.indices.contains(index) {
      self.countdowns.remove(at: index)
    }
  }
  
}
