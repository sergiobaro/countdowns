import Foundation
import CoreData
import Combine

class CountdownsCoreDataRepository {
  
  private let subject = CurrentValueSubject<[Countdown], Never>([])
  
  let persistantContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Countdowns")
    container.loadPersistentStores { store, error in
      if let error = error {
        print(error)
      }
    }
    return container
  }()
  
  init() {
    self.sendCountdowns()
  }
  
}

extension CountdownsCoreDataRepository: CountdownsRepository {
  
  func add(countdown: Countdown) {
    let _ = self.map(countdown: countdown)
    self.sendCountdowns()
    self.save()
  }
  
  func remove(countdownId: UUID) {
    guard let countdown = self.fetch(countdownId: countdownId) else {
      return
    }
    
    self.persistantContainer.viewContext.delete(countdown)
    self.sendCountdowns()
    self.save()
  }
  
  func update(countdown: Countdown) {
    guard let countdownObject = self.fetch(countdownId: countdown.countdownId) else {
      return
    }
    
    countdownObject.name = countdown.name
    countdownObject.date = countdown.date
    countdownObject.updatedAt = countdown.updatedAt
    
    self.sendCountdowns()
    self.save()
  }
  
  func countdown(countdownId: UUID) -> Countdown? {
    self.fetch(countdownId: countdownId)
      .map(self.map(countdownObject:))
  }
  
  func allCountdowns() -> AnyPublisher<[Countdown], Never> {
    self.subject.eraseToAnyPublisher()
  }
  
  func removeAll() {
    self.fetchAll().forEach {
      self.persistantContainer.viewContext.delete($0)
    }
    self.sendCountdowns()
    self.save()
  }
  
}

private extension CountdownsCoreDataRepository {
  
  func sendCountdowns() {
    self.subject.send(self.fetchAll().map(self.map(countdownObject:)))
  }
  
  func fetchAll() -> [CountdownObject] {
    do {
      let request = self.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(keyPath: \CountdownObject.createdAt, ascending: false)]
      return try self.persistantContainer.viewContext.fetch(request)
    } catch {
      print(error)
      return []
    }
  }
  
  func fetchRequest() -> NSFetchRequest<CountdownObject> {
    CountdownObject.fetchRequest()
  }
  
  func fetch(countdownId: UUID) -> CountdownObject? {
    do {
      let request = self.fetchRequest()
      request.predicate = NSPredicate(format: "countdownId == %@", countdownId as CVarArg)
      return try self.persistantContainer.viewContext.fetch(request).first
    } catch {
      print(error)
      return nil
    }
  }
  
  func map(countdownObject: CountdownObject) -> Countdown {
    Countdown(countdownId: countdownObject.countdownId ?? UUID(),
              name: countdownObject.name ?? "",
              date: countdownObject.date ?? Date(),
              createdAt: countdownObject.createdAt ?? Date(),
              updatedAt: countdownObject.updatedAt ?? Date())
  }
  
  func map(countdown: Countdown) -> CountdownObject {
    let countdownObject = CountdownObject(context: self.persistantContainer.viewContext)
    countdownObject.countdownId = countdown.countdownId
    countdownObject.name = countdown.name
    countdownObject.date = countdown.date
    countdownObject.createdAt = countdown.createdAt
    
    return countdownObject
  }
  
  func save() {
    do {
      try self.persistantContainer.viewContext.save()
    } catch {
      print(error)
    }
  }
}
