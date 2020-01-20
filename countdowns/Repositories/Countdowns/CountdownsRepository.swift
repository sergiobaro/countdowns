import Foundation
import Combine

struct Countdown {
  let countdownId: UUID
  var name: String
  var date: Date
  let createdAt: Date
  var updatedAt: Date
}

protocol CountdownsRepository {
  func add(countdown: Countdown)
  func remove(countdownId: UUID)
  func update(countdown: Countdown)
  func countdown(countdownId: UUID) -> Countdown?
  func allCountdowns() -> AnyPublisher<[Countdown], Never>
  func removeAll()
}
