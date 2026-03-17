import Foundation

@MainActor
final class CalendarRepositoryImpl: CalendarRepository {
	private let client: CalendarClient

	init(client: CalendarClient) {
		self.client = client
	}

	func refresh(for date: Date) async {
		await client.refresh(for: date)
	}

	func events(for part: DayPart) -> [PlannerEvent] {
		client.eventsByDayPart[part] ?? []
	}
}

