import XCTest
import Nimble
@testable import countdowns

class RelativeDateFormatterTests: XCTestCase {

  let formatter = RelativeDateFormatter()

  func test_today() {
    let date = Date.today

    let result = formatter.string(date: date)
    expect(result) == "today"
  }

  func test_yesterday() {
    let date = Date.today.minus(day: 1)!

    let result = formatter.string(date: date)
    expect(result) == "yesterday"
  }

  func test_twoDaysAgo() {
    let date = Date.today.minus(day: 2)!

    let result = formatter.string(date: date)
    expect(result) == "2 days ago"
  }

  func test_lastWeek() {
    let date = Date.today.minus(day: 7)!

    let result = formatter.string(date: date)
    expect(result) == "last week"
  }

  func test_twoMonthsAgo() {
    let date = Date.today.minus(day: 64)!

    let result = formatter.string(date: date)
    expect(result) == "2 months ago"
  }

  func test_twoWeeksAgo() {
    let date = Date.today.minus(day: 14)!

    let result = formatter.string(date: date)
    expect(result) == "2 weeks ago"
  }
}
