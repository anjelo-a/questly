import Foundation

protocol CalendarRepository {
	func refresh(for date: Date) async
	func events(for part: DayPart) -> [PlannerEvent]
}

