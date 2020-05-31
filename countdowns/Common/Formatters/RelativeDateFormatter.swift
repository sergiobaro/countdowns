import Foundation

struct RelativeDateFormatter {
  
  let components: Set<Calendar.Component>
  
  init() {
    self.init(components: [.year, .month, .day])
  }
  
  init(components: Set<Calendar.Component>) {
    self.components = components
  }
  
  func string(date: Date) -> String {
    return self.string(date: date, relativeTo: Date())
  }
  
  func string(date: Date, relativeTo: Date) -> String {
    if Calendar.current.compare(date, to: relativeTo, toGranularity: .day) == .orderedSame {
      return "today"
    }
    
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    formatter.dateTimeStyle = .named
    
    let result = formatter.localizedString(
      for: date.keepingComponents(self.components)!,
      relativeTo: relativeTo.keepingComponents(self.components)!
    )
    
    return result
  }
}
