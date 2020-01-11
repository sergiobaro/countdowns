import Foundation
import Combine

struct Countdown {
  let name: String
  let date: Date
}

protocol CountdownsRepository {
  func add(countdown: Countdown)
  func removeCountdown(at index: Int)
  func remove(countdown: Countdown)
  func allCountdowns() -> AnyPublisher<[Countdown], Never>
}


class CountdownsMemoryRepository: CountdownsRepository {
  
  private var countdowns = [Countdown]()
  
  private let subject = CurrentValueSubject<[Countdown], Never>([])
  
  func add(countdown: Countdown) {
    self.countdowns.append(countdown)
    self.subject.send(self.countdowns)
  }
  
  func remove(countdown: Countdown) {
    guard let index = self.countdowns.firstIndex(where: { $0.name == countdown.name }) else {
      return
    }
    
    self.removeCountdown(at: index)
  }
  
  func removeCountdown(at index: Int) {
    if self.countdowns.indices.contains(index) {
      self.countdowns.remove(at: index)
    }
  }
  
  func allCountdowns() -> AnyPublisher<[Countdown], Never> {
    return self.subject.eraseToAnyPublisher()
  }
}
