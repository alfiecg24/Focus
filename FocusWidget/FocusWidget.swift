//
//  FocusWidget.swift
//  FocusWidget
//
//  Created by Alfie on 03/10/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: UserDefaults(suiteName: "group.com.Alfie.Pomodoro")!.object(forKey: "saveTime") as? Date ?? Date.now, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let saveTime = UserDefaults(suiteName: "group.com.Alfie.Pomodoro")!.object(forKey: "saveTime") as? Date ?? nil
        
        let newEntry = SimpleEntry(date: saveTime!, configuration: ConfigurationIntent())
        
        entries.append(newEntry)
        
        let timeline = Timeline(entries: entries, policy: .after(Date.now))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct FocusWidgetEntryView : View {
    var entry: Provider.Entry
    @State private var saveTime = UserDefaults(suiteName: "group.com.Alfie.Pomodoro")!.object(forKey: "saveTime") as? Date ?? nil
    var body: some View {
        ZStack {
            Color("WidgetBackground")
                .ignoresSafeArea()
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Text(entry.date, style: .time)
                    if entry.date > Date.now {
                        Text(entry.date > Date.now ? entry.date : Date.now+600, style: .relative)
                            .font(.system(.body, design: .monospaced))
                    } else {
                        Text("Start a Focus session now!")
                    }
                    Spacer()
                }
                .foregroundColor(.white)
            }
            .padding()
        }
    }
}

@main
struct FocusWidget: Widget {
    let kind: String = "FocusWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FocusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Focus")
        .description("This is an example widget.")
    }
}

struct FocusWidget_Previews: PreviewProvider {
    static var previews: some View {
        FocusWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
