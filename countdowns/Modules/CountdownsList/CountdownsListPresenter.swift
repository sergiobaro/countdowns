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
    return countdowns.map {
      CountdownViewModel(
        countdownId: $0.countdownId,
        name: $0.name,
        date: self.map(date: $0.date)
      )
    }
  }
  
  func map(date: Date) -> String {
    let dateComponents: [Calendar.Component] = [.month, .day]
    let components = self.components(dateComponents, from: date)
    
    let isNegative = dateComponents.reduce(false) { partial, component in
      let value = components.value(for: component) ?? 0
      return partial || value < 0
    }
    
    let localized = dateComponents.compactMap { component in
      self.localize(component: component, value: components.value(for: component))
    }
    
    if localized.isEmpty {
      return Localized.today
    }
    
    return localized
      .joined(separator: Localized.and)
      .appending(isNegative ? " " + Localized.since : " " + Localized.until)
  }
  
  func localize(component: Calendar.Component, value: Int?) -> String? {
    guard let value = value,
      value != 0,
      let localizedKey = self.localizeKey(component: component)
    else {
      return nil
    }
    
    let formatString = NSLocalizedString(localizedKey, comment: "")
    return String(format: formatString, abs(value))
  }
  
  func localizeKey(component: Calendar.Component) -> String? {
    switch component {
    case .month: return "month"
    case .day: return "day"
    default: return nil
    }
  }
  
  func components(_ components: [Calendar.Component],from  date: Date) -> DateComponents {
    Calendar.current.dateComponents(Set(components), from: self.trim(date: Date()), to: date)
  }
  
  func trim(date: Date) -> Date {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    return Calendar.current.date(from: components)!
  }
}
