import Foundation
import Combine

struct CountdownViewModel {
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
    self.repository.removeCountdown(at: index)
  }
}

private extension CountdownsListPresenter {
  
  func map(countdowns: [Countdown]) -> [CountdownViewModel] {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .short
    
    return countdowns.map {
      CountdownViewModel(name: $0.name, date: df.string(from: $0.date))
    }
  }
}
