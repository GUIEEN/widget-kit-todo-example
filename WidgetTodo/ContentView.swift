//
//  ContentView.swift
//  WidgetTodo
//
//  Created by Seungyong Kwak on 2020/07/17.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @State private var editting = false
    @State var newTask: String = ""
    
    @State var taskList: [TaskContainer] = [] {
        didSet {
            guard let data = DataHandler.encode(tasks: self.taskList) else { return }
            self.data = data
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    @AppStorage(DataHandler.shared.storageKey, store: DataHandler.shared.userDefaults)
    var data: Data = Data()
    
    var statusbarHeight: CGFloat {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    var body: some View {
        
        ZStack {
            Constant.gradient
                .opacity(0.6)
                .brightness(0.5)
            
            VStack {
                
                TextField("Your new task", text: $newTask) { (onChanged) in
                    self.editting = onChanged
                } onCommit: {
                    self.taskList.append(TaskContainer(message: self.newTask))
                    self.newTask = ""
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                // 編集フラグがONの時に枠に影を付ける
                .shadow(color: editting ? .blue : .clear, radius: 3)
                
                ZStack {
                    Color.white
                        .cornerRadius(50)
                    
                    VStack {
                        Text("Do you even work ?")
                            .fontWeight(.black)
                            .padding(.top, 25)
                            .padding(.horizontal, 30)
                            .multilineTextAlignment(.center)
                            .font(.title)
                        
                        Spacer()
                    }
                    
                    List {
                        ForEach(taskList) { (task) in
                            HStack {
                                Text(task.message)
                                Spacer()
                                Text("❌")
                                    .onTapGesture {
                                        if let idx = self.taskList.firstIndex(where: { $0.id == task.id }) {
                                            self.taskList.remove(at: idx)
                                        }
                                    }
                            }
                        }
                    }.padding(.top, 80)
                }.onAppear {
                    self.taskList = DataHandler.retrieve(from: self.data)
                }
                
            }
            .padding(.top, self.statusbarHeight)
//            .onDisappear {
//
//            }
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
