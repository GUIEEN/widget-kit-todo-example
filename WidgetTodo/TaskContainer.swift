//
//  TaskContainer.swift
//  WidgetTodo
//
//  Created by Seungyong Kwak on 2020/07/18.
//

import Foundation
import SwiftUI

struct TaskContainer: Identifiable, Codable {
    var id = Date()
    var message: String
}

struct Constant {
    private static let colors = Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red])
    static var gradient: AngularGradient { AngularGradient(gradient: colors, center: .center, startAngle: .zero, endAngle: .degrees(360)) }
}

struct DataHandler {
    static var shared = DataHandler()
    let storageKey = "SOME_KEY_VALUE"
    let appGroupName = "group.com.guieen.Sexy-Widget"
    var userDefaults: UserDefaults {
        return UserDefaults(suiteName: appGroupName)!
    }
    static func retrieve(from data: Data) -> [TaskContainer] {
        guard let tasks = try? JSONDecoder().decode(Array<TaskContainer>.self, from: data) else { return [] }
        return tasks
    }
    static func encode(tasks: [TaskContainer]) -> Data? {
        guard let data = try? JSONEncoder().encode(tasks) else { return nil }
        return data
    }
}

