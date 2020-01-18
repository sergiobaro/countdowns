import Foundation

class CountdownDetailPresenter: ObservableObject {
  
  @Published var name = ""
  @Published var date = Date()
  @Published var disabled = true
  
  @Inject var repository: CountdownsRepository
  
  init(countdownId: UUID) {
    if let countdown = self.repository.countdown(countdownId: countdownId) {
      self.name = countdown.name
      self.date = countdown.date
    }
  }
  
  func userSave() {
    
  }
  
}
