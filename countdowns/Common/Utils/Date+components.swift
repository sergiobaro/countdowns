import Foundation

extension Date {

  static var today: Date { Date() }

  static func from(year: Int, month: Int, day: Int) -> Date? {
    let components = DateComponents(year: year, month: month, day: day)
    return Calendar.current.date(from: components)
  }

  func minus(year: Int? = nil, month: Int? = nil, day: Int? = nil) -> Date? {
    let components = DateComponents(year: year.map(-), month: month.map(-), day: day.map(-))
    return Calendar.current.date(byAdding: components, to: self)
  }

  func diff(component: Calendar.Component, from date: Date) -> Int? {
    let components = Calendar.current.dateComponents([component], from: date, to: self)
    return components.value(for: component)
  }

  func component(_ component: Calendar.Component) -> Int {
    Calendar.current.component(component, from: self)
  }
  
  func equalTo(_ date: Date, granularity: Calendar.Component) -> Bool {
    Calendar.current.compare(self, to: date, toGranularity: granularity) == .orderedSame
  }
  
  func keepingComponents(_ components: Set<Calendar.Component>) -> Date? {
    let components = Calendar.current.dateComponents(components, from: self)
    return Calendar.current.date(from: components)
  }
}
