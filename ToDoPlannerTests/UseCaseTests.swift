import XCTest
@testable import ToDoPlanner

final class UseCaseTests: XCTestCase {
	func testGetWeekDates_returnsSevenDays() {
		let useCase = DefaultGetWeekDatesUseCase()
		let dates = useCase.execute(selectedDate: Date(timeIntervalSince1970: 0))
		XCTAssertEqual(dates.count, 7)
	}

	func testGetPlannerSections_composesTasksAndEvents() {
		let taskRepo = MockTaskRepository()
		let calRepo = MockCalendarRepository()
		let useCase = DefaultGetPlannerSectionsUseCase(taskRepository: taskRepo, calendarRepository: calRepo)

		let date = Date()
		let sections = useCase.execute(date: date)

		XCTAssertEqual(sections.count, DayPart.plannerParts.count)
		XCTAssertEqual(sections.first?.tasks.count, 1)
		XCTAssertEqual(sections.first?.events.count, 1)
	}
}

private final class MockTaskRepository: TaskRepository {
	func tasks(for date: Date, dayPart: DayPart) -> [TodoItem] {
		[TodoItem(title: "A", details: nil, dueDate: date, dayPart: dayPart, priority: .medium, rewardPoints: .p25)]
	}

	func addTask(_ draft: NewTaskDraft, for date: Date) {}
	func toggleDone(_ id: UUID) {}
	func seedIfNeeded(for date: Date) {}
}

private final class MockCalendarRepository: CalendarRepository {
	func refresh(for date: Date) async {}
	func events(for part: DayPart) -> [PlannerEvent] {
		[PlannerEvent(id: "1", title: "Event", startDate: .now, endDate: .now, isAllDay: false)]
	}
}

