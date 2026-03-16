import EventKit
import Foundation

@MainActor
final class CalendarClient: ObservableObject {
	enum AuthorizationState: Equatable {
		case unknown
		case denied
		case authorized
	}

	@Published private(set) var authorizationState: AuthorizationState = .unknown
	@Published private(set) var eventsByDayPart: [DayPart: [PlannerEvent]] = [:]

	private let store = EKEventStore()

	func refresh(for date: Date) async {
		let status = EKEventStore.authorizationStatus(for: .event)
		switch status {
		case .fullAccess, .authorized:
			authorizationState = .authorized
			loadEvents(for: date)
		case .writeOnly:
			authorizationState = .denied
			eventsByDayPart = [:]
		case .denied, .restricted:
			authorizationState = .denied
			eventsByDayPart = [:]
		case .notDetermined:
			authorizationState = .unknown
			do {
				let ok = try await store.requestFullAccessToEvents()
				authorizationState = ok ? .authorized : .denied
				if ok { loadEvents(for: date) }
			} catch {
				authorizationState = .denied
				eventsByDayPart = [:]
			}
		@unknown default:
			authorizationState = .unknown
			eventsByDayPart = [:]
		}
	}

	private func loadEvents(for date: Date) {
		let cal = Calendar.current
		let start = cal.startOfDay(for: date)
		let end = cal.date(byAdding: .day, value: 1, to: start) ?? date.addingTimeInterval(60 * 60 * 24)

		let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
		let events = store.events(matching: predicate)

		let mapped: [PlannerEvent] = events.map {
			PlannerEvent(
				id: $0.eventIdentifier ?? UUID().uuidString,
				title: $0.title ?? "Event",
				startDate: $0.startDate,
				endDate: $0.endDate,
				isAllDay: $0.isAllDay
			)
		}

		var dict: [DayPart: [PlannerEvent]] = [.morning: [], .midday: [], .evening: []]
		for e in mapped {
			let hour = cal.component(.hour, from: e.startDate)
			let part: DayPart
			if DayPart.morning.hours.contains(hour) {
				part = .morning
			} else if DayPart.midday.hours.contains(hour) {
				part = .midday
			} else {
				part = .evening
			}
			dict[part, default: []].append(e)
		}

		for key in dict.keys {
			dict[key] = (dict[key] ?? []).sorted { $0.startDate < $1.startDate }
		}

		eventsByDayPart = dict
	}
}

