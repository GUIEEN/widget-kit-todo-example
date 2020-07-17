//
//  StupidWidget.swift
//  StupidWidget
//
//  Created by Seungyong Kwak on 2020/07/17.
//

import WidgetKit
import SwiftUI
import Intents


struct TaskListEntry: TimelineEntry, Identifiable {
    var id: UUID = UUID()
    let date: Date = Date()
    var tasks: [TaskContainer]
}

struct Provider: TimelineProvider {
    
    @AppStorage(DataHandler.shared.storageKey, store: DataHandler.shared.userDefaults)
    var data: Data = Data()
    
    func snapshot(with context: Context, completion: @escaping (TaskListEntry) -> ()) {
        let tasks = DataHandler.retrieve(from: data)
        if tasks.isEmpty { return }
        let entry = TaskListEntry(tasks: tasks)
        completion(entry)
    }
    
    func timeline(with context: Context, completion: @escaping (Timeline<TaskListEntry>) -> ()) {
        let tasks = DataHandler.retrieve(from: data)
        if tasks.isEmpty { return }
        let entry = TaskListEntry(tasks: tasks)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}


struct PlaceholderView : View {
    var body: some View {
        ZStack {
            Constant.gradient
                .opacity(0.6)
                .brightness(0.3)
            Text("DO NOT REST AND WORK 🔥")
                .font(.subheadline)
        }
    }
}

struct StupidWidgetEntryView : View {
    var entry: Provider.Entry

    let placeholderTitle = "🔥 WORK HARD 🔥"
    let placeholder = "DO NOT REST AND WORK 🔥"
    @Environment(\.widgetFamily) var family
    
    func showMessage(of idx: Int) -> some View {
        let isInvalid = entry.tasks.count <= idx
        return Group {
            if isInvalid {
                EmptyView()
            } else {
                HStack {
                    Text("👉")
                    Spacer()
                    Text(entry.tasks[idx].message)
                        .font( family == .systemLarge ? .title : family == .systemMedium ? .headline : .body)
                }.padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    var body: some View {
        switch family {
            case .systemLarge:
                ZStack {
                    Constant.gradient
                        .opacity(0.6)
                        .brightness(0.3)
                    
                    VStack {
                        Text(self.placeholderTitle)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        
                        ZStack {
                            Color.white
                                .cornerRadius(20)
                            VStack {
                                self.showMessage(of: 0)
                                self.showMessage(of: 1)
                                self.showMessage(of: 2)
                                self.showMessage(of: 3)
                                self.showMessage(of: 4)
                                self.showMessage(of: 5)
                                self.showMessage(of: 6)
                                Spacer()
                            }
                            .padding(.top, 40)
                            .padding(.horizontal, 20)
                        }
                    }
                }
            case .systemMedium:
                ZStack {
                    Constant.gradient
                        .opacity(0.6)
                        .brightness(0.3)
                    
                    
                    GeometryReader { proxy in
                        HStack(spacing: 0) {
                            Text("🔥\nW\nO\nR\nK")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.leading, 20)
                                .frame(width: proxy.size.width / 8)
                            Text("H\nA\nR\nD\n🔥")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.trailing, 20)
                                .frame(width: proxy.size.width / 8)
                            
                            ZStack {
                                Color.white
                                    .cornerRadius(20)
                                VStack {
                                    self.showMessage(of: 0)
                                    self.showMessage(of: 1)
                                    self.showMessage(of: 2)
                                    self.showMessage(of: 3)
                                    self.showMessage(of: 4)
                                    self.showMessage(of: 5)
                                    Spacer()
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 10)
                            }
                        }
                        
                    }
                }
                
            default:
                
                ZStack {
                    Constant.gradient
                        .opacity(0.6)
                        .brightness(0.3)
                    
                    VStack {
                        Text(self.placeholderTitle)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        ZStack {
                            Color.white
                                .cornerRadius(20)
                            VStack {
                                self.showMessage(of: 0)
                                self.showMessage(of: 1)
                                self.showMessage(of: 2)
                                self.showMessage(of: 3)
                                Spacer()
                            }.padding(.top, 20)
                        }
                    }
                    
                }
                
            
        }
    }
}


@main
struct StupidWidget: Widget {
    private let kind: String = "StupidWidget-HasNoName"

    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider(),
            placeholder: PlaceholderView(),
            content: { (entry) in
                StupidWidgetEntryView(entry: entry)
            })
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct StupidWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StupidWidgetEntryView(entry: TaskListEntry(tasks: [
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf")
            ]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            StupidWidgetEntryView(entry: TaskListEntry(tasks: [
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf")
            ]))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            StupidWidgetEntryView(entry: TaskListEntry(tasks: [
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf"),
                TaskContainer(message: "asdfsdf")
            ]))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
