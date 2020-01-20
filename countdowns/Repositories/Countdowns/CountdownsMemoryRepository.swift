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
  
  func update(countdown: Countdown) {
    guard let index = self.countdowns.firstIndex(where: { $0.countdownId == countdown.countdownId }) else {
      return
    }
    
    self.countdowns.remove(at: index)
    self.countdowns.append(countdown)
    
    self.sendCountdowns()
  }
  
  func countdown(countdownId: UUID) -> Countdown? {
    self.countdowns.first(where: { $0.countdownId == countdownId })
  }
  
  func allCountdowns() -> AnyPublisher<[Countdown], Never> {
    self.subject.eraseToAnyPublisher()
  }
  
  func removeAll() {
    self.countdowns.removeAll()
    self.sendCountdowns()
  }
  
}

private extension CountdownsMemoryRepository {
  
  func sendCountdowns() {
    self.countdowns.sort(by: { $0.createdAt > $1.createdAt })
    self.subject.send(self.countdowns)
  }
  
  func removeCountdown(at index: Int) {
    if self.countdowns.indices.contains(index) {
      self.countdowns.remove(at: index)
    }
  }
  
}
