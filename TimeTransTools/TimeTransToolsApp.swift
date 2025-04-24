//
//  TimeTransToolsApp.swift
//  TimeTransTools
//
//  Created by XWW on 2025/4/23.
//

import SwiftUI

@main
struct TimeTransToolsApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.appTheme.colorScheme())
        }
        .commands {
            CommandMenu("主题") {
                Button("跟随系统") {
                    themeManager.setTheme(.system)
                }
                .keyboardShortcut("1", modifiers: [.command, .option])
                .disabled(themeManager.appTheme == .system)
                
                Button("浅色模式") {
                    themeManager.setTheme(.light)
                }
                .keyboardShortcut("2", modifiers: [.command, .option])
                .disabled(themeManager.appTheme == .light)
                
                Button("深色模式") {
                    themeManager.setTheme(.dark)
                }
                .keyboardShortcut("3", modifiers: [.command, .option])
                .disabled(themeManager.appTheme == .dark)
            }
        }
    }
}
