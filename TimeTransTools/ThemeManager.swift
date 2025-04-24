import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("appTheme") private var appThemeValue: Int = 0
    
    enum AppTheme: Int {
        case system = 0
        case light = 1
        case dark = 2
        
        func colorScheme() -> ColorScheme? {
            switch self {
            case .system:
                return nil
            case .light:
                return .light
            case .dark:
                return .dark
            }
        }
    }
    
    @Published var appTheme: AppTheme = .system
    
    init() {
        // 先完成初始化，然后在init中单独设置appTheme
        if let theme = AppTheme(rawValue: appThemeValue) {
            appTheme = theme
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        self.appTheme = theme
        self.appThemeValue = theme.rawValue
    }
} 