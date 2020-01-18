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
        date: self.map(date: $0.date)
      )
    }
  }
  
  func map(date: Date) -> String {
    let components = Calendar.current.dateComponents([.month, .day], from: self.trim(date: Date()), to: date)
    
    let months = components.month ?? 0
    let days = components.day ?? 0
    
    return self.map(months: months, days: days)
  }
  
  func map(months: Int, days: Int) -> String {
    var result = [String]()
    
    if months != 0 {
      result.append("\(months) months")
    }
    if days != 0 {
      result.append("\(days) days")
    }
    
    return result.joined(separator: " ")
  }
  
  func trim(date: Date) -> Date {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    return Calendar.current.date(from: components)!
  }
}
