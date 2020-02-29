import Foundation
import Combine

struct CountdownViewModel: Identifiable {
  
  let countdownId: UUID
  let name: String
  let date: String
  
  var id: UUID { countdownId }
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
    self.repository.remove(countdownId: countdown.countdownId)
  }
}

private extension CountdownsListPresenter {
  
  func map(countdowns: [Countdown]) -> [CountdownViewModel] {
    countdowns.map {
      CountdownViewModel(
        countdownId: $0.countdownId,
        name: $0.name,
        date: self.map(date: $0.date)
      )
    }
  }
  
  func map(date: Date) -> String {
    let formatter = RelativeDateFormatter()
    return formatter.string(date: date)
    
//    let formatter = DateComponentsFormatter()
//    formatter.unitsStyle = .full
//    formatter.allowedUnits = [.year, .month, .weekOfMonth, .day]
//
//    return formatter.string(from: Date(), to: date)!
  }
}
