import Foundation
import Combine

class CountdownDetailPresenter: ObservableObject {
  
  @Published var name = ""
  @Published var date = Date()
  @Published var dateOption = 0
  @Published var numberOfDays = 1
  @Published var footer = ""
  @Published var disabled = true
  
  @Inject private var repository: CountdownsRepository
  private var countdown: Countdown? {
    didSet {
      self.updatedCountdown()
    }
  }
  private var cancellables = Set<AnyCancellable>()
  
  init(countdownId: UUID) {
    self.countdown = self.repository.countdown(countdownId: countdownId)
    self.updatedCountdown()
    self.numberOfDays = self.daysFromDate(self.countdown?.date)
    
    Publishers.CombineLatest($name, $date)
      .sink { [weak self] (name, date) in
        guard let self = self else { return }
        self.disabled = self.isDisabled(name: name, date: date)
      }
      .store(in: &cancellables)
    
    $numberOfDays
      .sink { [weak self] numberOfDays in
        guard let self = self else { return }
        self.date = self.dateFromNumberOfDays(numberOfDays)
      }
      .store(in: &cancellables)
  }
  
  func userSave() {
    guard var countdown = self.countdown else {
      return
    }
    
    countdown.name = self.name
    countdown.date = self.date
    countdown.updatedAt = Date()
    
    self.countdown = countdown
    self.updatedCountdown()
    
    self.repository.update(countdown: countdown)
  }
  
  func userReset() {
    guard var countdown = self.countdown else {
      return
    }
    
    countdown.name = self.name
    countdown.date = Date()
    countdown.updatedAt = Date()
    
    self.countdown = countdown
    self.updatedCountdown()
    
    self.repository.update(countdown: countdown)
  }
}

private extension CountdownDetailPresenter {
  
  func dateFromNumberOfDays(_ numberOfDays: Int) -> Date {
    let today = Date()
    let components = DateComponents(day: numberOfDays)
    
    return Calendar.current.date(byAdding: components, to: today, wrappingComponents: true)!
  }
  
  func daysFromDate(_ date: Date?) -> Int {
    guard let date = date else {
      return 1
    }
    
    let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
    return components.day ?? 1
  }
  
  func isDisabled(name: String, date: Date) -> Bool {
    if name.isEmpty {
      return true
    }
    guard let countdown = self.countdown else {
      return true
    }
    if name == countdown.name && self.equal(date: date, to: countdown.date) {
      return true
    }
    
    return false
  }
  
  func equal(date: Date, to toDate: Date) -> Bool {
    Calendar.current.compare(date, to: toDate, toGranularity: .day) == .orderedSame
  }
  
  func footer(for countdown: Countdown) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    dateFormatter.dateStyle = .short
    
    var result = "Created At: " + dateFormatter.string(from: countdown.createdAt)
    
    if let updatedAt = countdown.updatedAt {
      result += "\nUpdated At: " + dateFormatter.string(from: updatedAt)
    }
    
    return result
  }
  
  func updatedCountdown() {
    if let countdown = self.countdown {
      self.name = countdown.name
      self.date = countdown.date
      self.footer = self.footer(for: countdown)
    }
  }
}
