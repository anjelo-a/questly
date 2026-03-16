import SwiftUI

struct HomeView: View {
	@Environment(\.appTheme) private var theme
	@EnvironmentObject private var taskStore: TaskStore
	@EnvironmentObject private var calendarClient: CalendarClient

	@State private var selectedDate: Date = .now
	@State private var showingNewTask: DayPart?

	var body: some View {
		ZStack(alignment: .bottom) {
			theme.background.ignoresSafeArea()

			VStack(spacing: 0) {
				header
					.padding(.horizontal, 16)
					.padding(.top, 16)

				dateStrip
					.padding(.horizontal, 16)
					.padding(.top, 16)

				ScrollView(.vertical, showsIndicators: false) {
					VStack(spacing: 24) {
						ForEach(DayPart.plannerParts) { part in
							dayPartSection(part)
						}
					}
					.padding(.horizontal, 16)
					.padding(.top, 24)
					.padding(.bottom, 140)
				}
			}

			fab
				.padding(.trailing, 24)
				.padding(.bottom, 136)
				.frame(maxWidth: .infinity, alignment: .trailing)

			bottomNav
				.padding(.horizontal, 16)
				.padding(.bottom, 10)
		}
		.onAppear {
			taskStore.seedIfNeeded(for: selectedDate)
			guard !isRunningInPreviews else { return }
			Task { await calendarClient.refresh(for: selectedDate) }
		}
		.onChange(of: selectedDate) { _, newValue in
			guard !isRunningInPreviews else { return }
			Task { await calendarClient.refresh(for: newValue) }
		}
		.sheet(item: $showingNewTask) { part in
			NewTaskSheet(
				defaultDayPart: part,
				date: selectedDate
			) { draft in
				taskStore.addTask(
					title: draft.title,
					details: draft.details,
					date: selectedDate,
					dayPart: draft.dayPart,
					priority: draft.priority,
					rewardPoints: draft.rewardPoints
				)
			}
			.presentationDetents([.medium])
		}
	}

	private var header: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading, spacing: 4) {
				Text(selectedDate.formatted(.dateTime.weekday(.wide)))
					.font(theme.titleFont)
					.foregroundStyle(theme.textPrimary)

				Text(selectedDate.formatted(.dateTime.month(.wide).day().year()))
					.font(.system(size: 16, weight: .regular))
					.foregroundStyle(theme.textSecondary)
			}

			Spacer(minLength: 12)

			HStack(spacing: 8) {
				Text("⚡")
					.font(.system(size: 14))
					.baselineOffset(1)
				Text("1,834")
					.font(.system(size: 16, weight: .semibold))
			}
			.foregroundStyle(theme.warning)
			.padding(.horizontal, 12)
			.frame(height: 36)
			.background(theme.surfaceAlt)
			.clipShape(Capsule())
		}
		.frame(height: 60)
	}

	private var dateStrip: some View {
		let days = weekFor(date: selectedDate)
		return ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				ForEach(days, id: \.self) { day in
					let isSelected = Calendar.current.isDate(day, inSameDayAs: selectedDate)
					VStack(spacing: 4) {
						Text(day.formatted(.dateTime.weekday(.abbreviated)).uppercased())
							.font(.system(size: 12, weight: .regular))
							.foregroundStyle(isSelected ? .white : theme.textSecondary)

						Text(day.formatted(.dateTime.day()))
							.font(.system(size: 18, weight: .semibold))
							.foregroundStyle(isSelected ? .white : theme.textPrimary)
					}
					.frame(width: 50, height: 64)
					.background(isSelected ? theme.accent : Color.clear)
					.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
					.contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
					.onTapGesture { selectedDate = day }
				}
			}
			.padding(.vertical, 4)
		}
	}

	private func dayPartSection(_ part: DayPart) -> some View {
		VStack(spacing: 12) {
			HStack {
				HStack(spacing: 8) {
					RemoteIcon(url: iconURL(for: part))
						.frame(width: 20, height: 20)
					Text(part.title)
						.font(theme.subtitleFont)
						.foregroundStyle(theme.textPrimary)
				}

				Spacer()

				Text(part.timeRangeText)
					.font(.system(size: 14, weight: .regular))
					.foregroundStyle(theme.textSecondary)
			}

			VStack(spacing: 10) {
				let tasks = taskStore.tasks(for: selectedDate, dayPart: part)
				let events = calendarClient.eventsByDayPart[part] ?? []

				if !tasks.isEmpty || !events.isEmpty {
					ForEach(tasks) { item in
						TaskRow(item: item) {
							taskStore.toggleDone(item.id)
						}
					}

					ForEach(events.prefix(2), id: \.id) { event in
						EventRow(event: event)
					}
				}

				Button {
					showingNewTask = part
				} label: {
					HStack(spacing: 8) {
						RemoteIcon(url: plusIconURL)
							.frame(width: 20, height: 20)
						Text("Add task")
							.font(.system(size: 16, weight: .medium))
							.foregroundStyle(theme.textSecondary)
					}
					.frame(maxWidth: .infinity)
					.frame(height: 76)
					.background(theme.surface)
					.overlay(
						RoundedRectangle(cornerRadius: theme.cornerRadiusMedium, style: .continuous)
							.stroke(theme.divider, style: StrokeStyle(lineWidth: 1.8, dash: [5, 4]))
					)
					.clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusMedium, style: .continuous))
				}
				.buttonStyle(.plain)
			}
		}
	}

	private var fab: some View {
		Button {
			showingNewTask = .morning
		} label: {
			ZStack {
				Circle().fill(theme.accent)
				RemoteIcon(url: fabIconURL)
					.frame(width: 24, height: 24)
			}
			.frame(width: 56, height: 56)
			.shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
		}
		.buttonStyle(.plain)
	}

	private var bottomNav: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				navSelectedItem
				Spacer()
				navIconButton(url: navIcon2URL)
				Spacer()
				navIconButton(url: navIcon3URL)
				Spacer()
				navIconButton(url: navIcon4URL)
				Spacer()
				navIconButton(url: navIcon5URL)
			}
			.frame(height: 56)
			.padding(.horizontal, 16)
			.padding(.top, 12)
		}
		.frame(height: 80)
		.frame(maxWidth: .infinity)
		.background(theme.surface)
		.clipShape(Capsule())
		.shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 10)
	}

	private var navSelectedItem: some View {
		VStack(spacing: 4) {
			RemoteIcon(url: navSelectedIconURL)
				.frame(width: 20, height: 20)
			Text("Planner")
				.font(.system(size: 12, weight: .medium))
				.foregroundStyle(.white)
		}
		.frame(width: 68, height: 56)
		.background(theme.accent)
		.clipShape(Capsule())
	}

	private func navIconButton(url: URL) -> some View {
		Button {} label: {
			RemoteIcon(url: url)
				.frame(width: 20, height: 20)
				.frame(width: 44, height: 36)
		}
		.buttonStyle(.plain)
	}

	private func weekFor(date: Date) -> [Date] {
		let cal = Calendar.current
		let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
		return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: start) }
	}

	private var isRunningInPreviews: Bool {
		ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
	}
}

private struct TaskRow: View {
	@Environment(\.appTheme) private var theme
	let item: TodoItem
	let onToggle: () -> Void

	var body: some View {
		Button(action: onToggle) {
			HStack(spacing: 10) {
				Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
					.foregroundStyle(item.isDone ? theme.accent : theme.textSecondary)
				Text(item.title)
					.font(theme.bodyFont)
					.foregroundStyle(theme.textPrimary)
				Spacer()
			}
			.padding(.horizontal, 12)
			.padding(.vertical, 10)
			.background(theme.surface)
			.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
		}
		.buttonStyle(.plain)
	}
}

private struct EventRow: View {
	@Environment(\.appTheme) private var theme
	let event: PlannerEvent

	var body: some View {
		HStack(spacing: 10) {
			Image(systemName: "calendar")
				.foregroundStyle(theme.textSecondary)
			VStack(alignment: .leading, spacing: 2) {
				Text(event.title)
					.font(theme.bodyFont)
					.foregroundStyle(theme.textPrimary)
					.lineLimit(1)
				Text(timeText)
					.font(.system(size: 12, weight: .regular))
					.foregroundStyle(theme.textSecondary)
			}
			Spacer()
		}
		.padding(.horizontal, 12)
		.padding(.vertical, 10)
		.background(theme.surface)
		.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
	}

	private var timeText: String {
		guard !event.isAllDay else { return "All day" }
		return "\(event.startDate.formatted(.dateTime.hour().minute())) – \(event.endDate.formatted(.dateTime.hour().minute()))"
	}
}

private struct NewTaskDraft {
	var title: String
	var details: String
	var dayPart: DayPart
	var priority: TaskPriority
	var rewardPoints: TaskRewardPoints
}

private struct NewTaskSheet: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.appTheme) private var theme

	let defaultDayPart: DayPart
	let date: Date
	let onAdd: (NewTaskDraft) -> Void

	@State private var title: String = ""
	@State private var details: String = ""
	@State private var dayPart: DayPart
	@State private var priority: TaskPriority = .medium
	@State private var rewardPoints: TaskRewardPoints = .p25

	init(defaultDayPart: DayPart, date: Date, onAdd: @escaping (NewTaskDraft) -> Void) {
		self.defaultDayPart = defaultDayPart
		self.date = date
		self.onAdd = onAdd
		_dayPart = State(initialValue: defaultDayPart)
	}

	var body: some View {
		ZStack(alignment: .top) {
			theme.surface.ignoresSafeArea()
			VStack(alignment: .leading, spacing: 18) {
				Capsule()
					.fill(Color(red: 0xD1 / 255, green: 0xD5 / 255, blue: 0xDC / 255))
					.frame(width: 48, height: 4)
					.frame(maxWidth: .infinity)
					.padding(.top, 10)

				Text("New Task")
					.font(.system(size: 24, weight: .bold))
					.foregroundStyle(theme.textPrimary)
					.padding(.top, 2)

				field(label: "TITLE") {
					TextField("What do you need to do?", text: $title)
				}

				field(label: "DESCRIPTION (OPTIONAL)") {
					TextField("Add details...", text: $details, axis: .vertical)
						.lineLimit(3, reservesSpace: true)
				}

				sectionLabel("WHEN")
				whenGrid

				sectionLabel("PRIORITY")
				pillRow(items: TaskPriority.allCases, selection: $priority) { $0.title }

				sectionLabel("POINTS REWARD")
				pillRow(items: TaskRewardPoints.allCases, selection: $rewardPoints) { $0.title }

				Spacer(minLength: 0)

				Button {
					let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
					guard !trimmed.isEmpty else { return }
					onAdd(
						NewTaskDraft(
							title: trimmed,
							details: details.trimmingCharacters(in: .whitespacesAndNewlines),
							dayPart: dayPart,
							priority: priority,
							rewardPoints: rewardPoints
						)
					)
					dismiss()
				} label: {
					HStack(spacing: 10) {
						Text("+")
							.font(.system(size: 20, weight: .semibold))
						Text("Add Task")
							.font(.system(size: 18, weight: .semibold))
					}
					.foregroundStyle(.white)
					.frame(maxWidth: .infinity)
					.frame(height: 60)
					.background(theme.accent)
					.clipShape(Capsule())
				}
				.buttonStyle(.plain)
				.padding(.bottom, 6)
			}
			.padding(.horizontal, 24)
			.padding(.top, 8)
		}
	}

	private func sectionLabel(_ text: String) -> some View {
		Text(text)
			.font(.system(size: 12, weight: .semibold))
			.foregroundStyle(theme.textSecondary)
			.tracking(0.3)
	}

	private func field<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
		VStack(alignment: .leading, spacing: 8) {
			sectionLabel(label)
			content()
				.font(.system(size: 16, weight: .regular))
				.padding(.horizontal, 16)
				.padding(.vertical, 12)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(Color(red: 0xF8 / 255, green: 0xF9 / 255, blue: 0xFB / 255))
				.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
		}
	}

	private var whenGrid: some View {
		VStack(spacing: 8) {
			HStack(spacing: 8) {
				whenPill(.morning, iconURL: whenIconMorningURL)
				whenPill(.midday, iconURL: whenIconMiddayURL)
				Spacer(minLength: 0)
			}
			HStack(spacing: 8) {
				whenPill(.evening, iconURL: whenIconEveningURL)
				whenPill(.inbox, iconURL: whenIconInboxURL)
				Spacer(minLength: 0)
			}
		}
	}

	private func whenPill(_ part: DayPart, iconURL: URL) -> some View {
		let selected = (dayPart == part)
		return Button {
			dayPart = part
		} label: {
			HStack(spacing: 8) {
				RemoteIcon(url: iconURL)
					.frame(width: 16, height: 16)
				Text(part.title)
					.font(.system(size: 16, weight: .medium))
			}
			.foregroundStyle(selected ? .white : theme.textSecondary)
			.padding(.horizontal, 16)
			.frame(height: 40)
			.background(selected ? theme.accent : Color(red: 0xF0 / 255, green: 0xF2 / 255, blue: 0xF8 / 255))
			.clipShape(Capsule())
		}
		.buttonStyle(.plain)
	}

	private func pillRow<Item: Identifiable & Hashable>(
		items: [Item],
		selection: Binding<Item>,
		title: @escaping (Item) -> String
	) -> some View {
		HStack(spacing: 8) {
			ForEach(items, id: \.self) { item in
				let selected = selection.wrappedValue == item
				Button {
					selection.wrappedValue = item
				} label: {
					Text(title(item))
						.font(.system(size: 16, weight: .medium))
						.foregroundStyle(selected ? .white : theme.textSecondary)
						.frame(maxWidth: .infinity)
						.frame(height: 40)
						.background(selected ? theme.warning : Color(red: 0xF0 / 255, green: 0xF2 / 255, blue: 0xF8 / 255))
						.clipShape(Capsule())
				}
				.buttonStyle(.plain)
			}
		}
	}
}

private struct RemoteIcon: View {
	let url: URL

	var body: some View {
		AsyncImage(url: url) { phase in
			switch phase {
			case .empty:
				Color.clear
			case .success(let image):
				image
					.resizable()
					.scaledToFit()
			case .failure:
				Color.clear
			@unknown default:
				Color.clear
			}
		}
	}
}

private func iconURL(for part: DayPart) -> URL {
	switch part {
	case .morning: URL(string: "https://www.figma.com/api/mcp/asset/b7f43aeb-86da-4f6d-abc2-889bf25e0d22")!
	case .midday: URL(string: "https://www.figma.com/api/mcp/asset/ea240abf-4157-4a2e-ada7-8e8aaf60c689")!
	case .evening: URL(string: "https://www.figma.com/api/mcp/asset/c14557a5-283a-4e78-8771-4ae7f9c154f5")!
	case .inbox: URL(string: "https://www.figma.com/api/mcp/asset/90131a9e-37e6-4d41-a19c-ec59ab7c4047")!
	}
}

private let plusIconURL = URL(string: "https://www.figma.com/api/mcp/asset/a212cdb6-b229-4f56-82bd-34d26f1eec93")!
private let fabIconURL = URL(string: "https://www.figma.com/api/mcp/asset/db5a8435-7758-40f9-a630-8d5ea97a2158")!

private let navSelectedIconURL = URL(string: "https://www.figma.com/api/mcp/asset/ce660ce1-7d4d-43a0-af5d-b7d1959485bf")!
private let navIcon2URL = URL(string: "https://www.figma.com/api/mcp/asset/7de8d47c-cfb7-445f-8469-bfc20119998b")!
private let navIcon3URL = URL(string: "https://www.figma.com/api/mcp/asset/1e17dc44-04e9-474a-b3b9-884011a4dd3c")!
private let navIcon4URL = URL(string: "https://www.figma.com/api/mcp/asset/833b7830-cf68-4c9f-baae-1d31594d75c8")!
private let navIcon5URL = URL(string: "https://www.figma.com/api/mcp/asset/953466cf-230e-4ec2-977f-0441635d1db6")!

private let whenIconMorningURL = URL(string: "https://www.figma.com/api/mcp/asset/e5544835-578d-43cb-a150-c9664727a984")!
private let whenIconMiddayURL = URL(string: "https://www.figma.com/api/mcp/asset/bdd8c1df-09c7-4c74-981a-0a3d6e2cb4de")!
private let whenIconEveningURL = URL(string: "https://www.figma.com/api/mcp/asset/358ae451-3bd8-4f72-bd37-59cee23ffd21")!
private let whenIconInboxURL = URL(string: "https://www.figma.com/api/mcp/asset/90131a9e-37e6-4d41-a19c-ec59ab7c4047")!

#if DEBUG
#Preview("Planner") {
	let store = TaskStore()
	let cal = CalendarClient()
	return HomeView()
		.environmentObject(store)
		.environmentObject(cal)
		.environment(\.appTheme, .default)
}
#endif

#Preview {
    let taskStore = TaskStore()
    taskStore.seedIfNeeded(for: .now)
    let calendarClient = CalendarClient()

    return HomeView()
        .environmentObject(taskStore)
        .environmentObject(calendarClient)
        .environment(\.appTheme, .default)
}
