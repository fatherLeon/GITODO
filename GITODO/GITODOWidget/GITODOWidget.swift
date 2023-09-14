//
//  GITODOWidget.swift
//  GITODOWidget
//
//  Created by 강민수 on 2023/09/11.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todos: [
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "할 일1", memo: "", storedDate: Date(), isComplete: true),
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "할 일2", memo: "", storedDate: Date(), isComplete: true),
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "할 일3", memo: "", storedDate: Date(), isComplete: true)
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), todos: [
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "할 일....", memo: "", storedDate: Date(), isComplete: false)
        ])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let (year, month, day) = currentDate.convertDateToYearMonthDay()!
        let todos = CoreDataManager.shared.search("\(year)-\(month)-\(day)", type: TodoObject.self) as! [TodoObject]
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let nonCompletedTodos = todos.filter { !$0.isComplete }
            let entry = SimpleEntry(date: entryDate, todos: nonCompletedTodos)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todos: [TodoObject]
}

struct GITODOWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("\(entry.todos.first!.title)")
    }
}

struct GITODOWidget: Widget {
    let kind: String = "GITODOWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GITODOWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("GITODO 위젯")
        .description("보여질 위젯의 예제입니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct GITODOWidget_Previews: PreviewProvider {
    static var previews: some View {
        GITODOWidgetEntryView(entry: SimpleEntry(date: Date(), todos: [
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "타이틀 1", memo: "", storedDate: Date(), isComplete: true),
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "타이틀 2", memo: "", storedDate: Date(), isComplete: false),
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "타이틀 2", memo: "", storedDate: Date(), isComplete: true),
        ]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
