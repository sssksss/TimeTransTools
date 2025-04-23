//
//  MainMenuView.swift
//  TimeTransTools
//
//  Created by XWW on 2025/4/23.
//

import SwiftUI

struct MainMenuView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 30) {
                Text("工具集")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                
                Button(action: {
                    path.append("timeConverter")
                }) {
                    HStack {
                        Image(systemName: "clock")
                            .font(.largeTitle)
                        Text("时间转换工具")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(width: 250, height: 60)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                }
                .buttonStyle(PlainButtonStyle())
                
                // 这里可以添加其他工具按钮
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("TimeTransTools")
            .navigationDestination(for: String.self) { destination in
                if destination == "timeConverter" {
                    ContentView()
                }
            }
        }
    }
}

#Preview {
    MainMenuView()
} 