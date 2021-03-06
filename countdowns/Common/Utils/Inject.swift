import Foundation
import Swinject

class MainContainer {
  
  static let shared = MainContainer()
  
  private let container = Container()
  
  init() {
    self.container.register(CountdownsRepository.self) { _ in
      CountdownsCoreDataRepository()
    }
    .inObjectScope(.container)
  }
  
  func resolve<T>(_ type: T.Type) -> T? {
    return self.container.resolve(T.self)
  }
  
}

@propertyWrapper
struct Inject<Value> {
  
  var wrappedValue: Value {
    MainContainer.shared.resolve(Value.self)!
  }
  
}
