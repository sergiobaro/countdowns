import Foundation
import Combine

struct CountdownViewModel {
  let countdowndId: UUID
  let name: String
  let date: String
}

class CountdownsListPresenter: ObservableObject {
  
  @Published var countdowns = [CountdownViewModel]()
  
  @Inject private var repository: CountdownsRepository
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    repository.allCountdowns()
      .map(self.map(countdowns:))
      .sink(receiveValue: { [weak self] countdowns in
        self?.countdowns = countdowns
      })
      .store(in: &cancellables)
  }
  
  func removeCountdown(at index: Int) {
    let countdown = self.countdowns[index]
    self.repository.remove(countdownId: countdown.countdowndId)
  }
}

private extension CountdownsListPresenter {
  
  func map(countdowns: [Countdown]) -> [CountdownViewModel] {
    return countdowns.map {
      CountdownViewModel(
        countdowndId: $0.countdownId,
        name: $0.name,
        date: "Days: \(self.days(from: $0.date))"
      )
    }
  }
  
  func days(from date: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
  }
}
