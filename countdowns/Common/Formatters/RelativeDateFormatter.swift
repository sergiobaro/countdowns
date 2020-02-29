import Foundation

struct RelativeDateFormatter {
  
  func string(date: Date) -> String {
    let nowComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
    let now = Calendar.current.date(from: nowComponents)!
    
    return self.string(date: date, relativeTo: now)
  }
  
  func string(date: Date, relativeTo: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    formatter.dateTimeStyle = .named
    
    return formatter.localizedString(for: date, relativeTo: relativeTo)
  }
  
}
