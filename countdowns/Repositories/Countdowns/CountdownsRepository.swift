import Foundation
import Combine

struct Countdown {
  let countdownId: UUID
  let name: String
  let date: Date
  let createdAt: Date
}

protocol CountdownsRepository {
  func add(countdown: Countdown)
  func remove(countdownId: UUID)
  func countdown(countdownId: UUID) -> Countdown?
  func allCountdowns() -> AnyPublisher<[Countdown], Never>
  func removeAll()
}
