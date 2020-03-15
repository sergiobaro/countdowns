import Foundation

extension Date {
  
  func equalTo(_ date: Date, granularity: Calendar.Component) -> Bool {
    Calendar.current.compare(self, to: date, toGranularity: granularity) == .orderedSame
  }
  
  func keepingComponents(_ components: Set<Calendar.Component>) -> Date? {
    let components = Calendar.current.dateComponents(components, from: self)
    return Calendar.current.date(from: components)
  }
}
