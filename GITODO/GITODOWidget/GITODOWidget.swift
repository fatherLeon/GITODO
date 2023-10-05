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
        SimpleEntry(date: Date(), month: 1, day: 1, todos: [
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "할 일1", memo: "", storedDate: Date(), isComplete: true),
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "할 일2", memo: "", storedDate: Date(), isComplete: true),
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "할 일3", memo: "", storedDate: Date(), isComplete: true)
        ], commitedNum: 9, commitColor: .systemGreen)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), month: 1, day: 1, todos: [
            TodoObject(year: 1, month: 1, day: 1, hour: 13, minute: 10, second: 1, title: "할 일~~...", memo: "", storedDate: Date(), isComplete: false),
            TodoObject(year: 1, month: 1, day: 1, hour: 14, minute: 10, second: 1, title: "다음 할 일", memo: "", storedDate: Date().addingTimeInterval(10), isComplete: false),
            TodoObject(year: 1, month: 1, day: 1, hour: 14, minute: 15, second: 1, title: "다다음 할 일", memo: "", storedDate: Date(), isComplete: false)
        ], commitedNum: 11, commitColor: .systemGreen)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        let (year, month, day) = currentDate.convertDateToYearMonthDay()!
        let todos = CoreDataManager.shared.search("\(year)-\(month)-\(day)", type: TodoObject.self) as! [TodoObject]
        
        var commitedNum = 0
        
        for dayByMonth in 1...day {
            let num = CoreDataManager.shared.search("\(year)-\(month)-\(dayByMonth)", type: CommitByDateObject.self).count
            commitedNum += num
        }
        
        let colorKey = UserDefaultManager().fetchColorKey(by: UserDefaultManager.themeKey)
        let colorSet = CustomColor.pickCustomColorSet(by: colorKey)
        let color = colorSet[safe: 1]!
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let nonCompletedTodos = todos.filter { !$0.isComplete }
            let sortedTodos = TodoObject.getTodosNearest(by: currentDate, todos: nonCompletedTodos)
            let entry = SimpleEntry(date: entryDate, month: month, day: day, todos: sortedTodos, commitedNum: commitedNum, commitColor: color!)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let month: Int
    let day: Int
    let todos: [TodoObject]
    let commitedNum: Int
    let commitColor: UIColor
}

struct GITODOWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State private var date: Date = Date()
    
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                HStack {
                    Text("\(entry.month)월 \(entry.day)일")
                        .font(.title2)
                        .bold()
                }
                .padding(.top, 20)
                
                ZStack {
                    Color(uiColor: entry.commitColor)
                        .opacity(0.3)
                }
                .clipShape(.rect(cornerRadius: 5))
                .overlay {
                    if let todo = entry.todos.first {
                        VStack(spacing: 5) {
                            Text("\(todo.title)")
                                .lineLimit(2)
                                .font(.body)
                            Text("⏰\(todo.hour)시 \(todo.minute)분")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("오늘 할일이 등록되지 않았습니다.")
                            .font(.callout)
                            .lineLimit(4)
                    }
                }
            }
            .widgetBacground(Color(UIColor.systemBackground))
        case .systemMedium:
            HStack(spacing: 0) {
                ZStack {
                    Color(uiColor: entry.commitColor)
                    Text("🎉\(entry.commitedNum)")
                        .font(.title3)
                }
                .clipShape(.rect(cornerRadius: 10))
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Spacer()

                VStack(alignment: .leading, spacing: 5) {
                    ForEach(0..<5) { index in
                        HStack {
                            if let todo = entry.todos[safe: index] {
                                Text("\(todo.title)")
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .widgetBacground(Color(UIColor.systemBackground))
        default:
            Text("Error😭😭")
                .widgetBacground(Color(UIColor.systemBackground))
        }
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
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct GITODOWidget_Previews: PreviewProvider {
    static var previews: some View {
        GITODOWidgetEntryView(entry: SimpleEntry(date: Date(), month: 1, day: 1, todos: [
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "집에가서 골프존 자기소개서 쓰기", memo: "", storedDate: Date(), isComplete: true),
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "타이틀 2", memo: "", storedDate: Date(), isComplete: false),
            TodoObject(year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, title: "타이틀 2", memo: "", storedDate: Date(), isComplete: true),
        ], commitedNum: 10, commitColor: .systemGreen))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension View {
    func widgetBacground(_ backgroundView: some View) -> some View {
        if #available(iOS 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
