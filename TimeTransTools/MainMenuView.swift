//
//  MainMenuView.swift
//  TimeTransTools
//
//  Created by XWW on 2025/4/23.
//

import SwiftUI

struct MainMenuView: View {
    @State private var path = NavigationPath()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    
    // 按钮尺寸和间距的常量
    private let buttonWidth: CGFloat = 350
    private let buttonHeight: CGFloat = 70
    private let buttonSpacing: CGFloat = 25
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                // 标题区域
                Text("工具箱")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                
                // 按钮区域 - 使用更多的垂直空间
                VStack(spacing: buttonSpacing) {
                    // 时间戳转换工具按钮
                    ToolButton(
                        title: "时间戳转换工具",
                        icon: "clock.arrow.2.circlepath",
                        color: .blue,
                        width: buttonWidth,
                        height: buttonHeight
                    ) {
                        path.append("timeConverter")
                    }
                    
                    // 天计数/毫秒计数转换工具按钮
                    ToolButton(
                        title: "天/毫秒计数转换",
                        icon: "calendar.badge.clock",
                        color: .blue,
                        width: buttonWidth,
                        height: buttonHeight
                    ) {
                        path.append("dayMillisecondConverter")
                    }
                    
                    // 这里可以添加其他工具按钮
                }
                .padding(.horizontal)
                
                // 添加版本信息
                Spacer()
                
                Text("TimeTransTools v1.0")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 25)

            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
            .navigationTitle("TimeTransTools")
            .navigationDestination(for: String.self) { destination in
                if destination == "timeConverter" {
                    ContentView()
                } else if destination == "dayMillisecondConverter" {
                    DayMillisecondConverterView()
                }
            }
        }
    }
}

// 提取出按钮组件，方便重用和统一风格
struct ToolButton: View {
    let title: String
    let icon: String
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .frame(width: 40)
                    .symbolRenderingMode(.hierarchical)
                
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .opacity(0.7)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .frame(width: width, height: height)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [color, color.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: color.opacity(0.4), radius: 5, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.vertical, 5)
    }
}

// 添加缩放效果的按钮样式
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    MainMenuView()
        .environmentObject(ThemeManager())
} 
