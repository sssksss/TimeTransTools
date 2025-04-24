import SwiftUI

struct DayMillisecondConverterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    
    enum ConversionType: Int, CaseIterable {
        case dateToCounters = 0  // 日期转为天计数与毫秒计数
        case countersToDate = 1  // 天计数与毫秒计数转日期
        
        var title: String {
            switch self {
            case .dateToCounters: return "日期→天计数+毫秒"
            case .countersToDate: return "天计数+毫秒→日期"
            }
        }
    }
    
    @State private var conversionType: ConversionType = .dateToCounters
    @State private var dateString: String = ""
    @State private var dayCount: String = ""
    @State private var millisInDay: String = ""
    @State private var resultDayCount: String = ""
    @State private var resultMilliseconds: String = ""
    @State private var resultDateString: String = ""
    @State private var useCustomReferenceDate: Bool = false
    @State private var referenceDateString: String = "1970-01-01T00:00:00"
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }
    
    // 添加错误处理的日期解析方法
    private func parseDate(from string: String) -> Date? {
        // 首先使用标准格式解析
        if let date = dateFormatter.date(from: string) {
            return date
        }
        
        // 尝试其他可能的格式
        let alternateFormatter = DateFormatter()
        // 尝试不同的日期格式
        let formats = [
            "yyyy-MM-dd HH:mm:ss",
            "yyyy/MM/dd'T'HH:mm:ss",
            "yyyy/MM/dd HH:mm:ss",
            "yyyy-MM-dd"
        ]
        
        for format in formats {
            alternateFormatter.dateFormat = format
            if let date = alternateFormatter.date(from: string) {
                return date
            }
        }
        
        return nil
    }
    
    var body: some View {
        VStack {
            // 标题
            Text("天计数/毫秒计数转换工具")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 30)
                .padding(.bottom, 20)
            
            // 转换类型选择器
            HStack {
                Text("转换类型")
                    .font(.headline)
                    .padding(.leading, 30)
                
                Spacer()
            }
            .padding(.bottom, 5)
            
            SegmentedPickerWithCustomStyle(selection: $conversionType)
                .onChange(of: conversionType) { _, _ in
                    clearResults()
                    // 切换类型后自动更新结果
                    performConversion()
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            
            // 主要内容区域
            HStack(alignment: .top, spacing: 40) {
                // 左侧：输入区域
                VStack(alignment: .leading) {
                    inputBoxView
                    
                    Spacer()
                }
                .frame(width: 350)
                .padding(.leading, 30)
                
                // 右侧：结果显示
                VStack(alignment: .leading) {
                    Text("转换结果:")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    if conversionType == .dateToCounters {
                        if resultDayCount.isEmpty && resultMilliseconds.isEmpty {
                            Text("请在左侧输入数据，然后等待自动转换")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else {
                            // 天计数结果框
                            ResultBoxView(
                                title: "天计数:",
                                value: resultDayCount.isEmpty ? "等待输入" : "\(resultDayCount)",
                                accentColor: .red
                            )
                            .padding(.bottom, 15)
                            
                            // 毫秒数结果框
                            ResultBoxView(
                                title: "一天中的毫秒数:",
                                value: resultMilliseconds.isEmpty ? "等待输入" : "\(resultMilliseconds)", 
                                accentColor: .red
                            )
                        }
                    } else {
                        if resultDateString.isEmpty {
                            Text("请在左侧输入数据，然后等待自动转换")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else {
                            ResultBoxView(
                                title: "日期时间结果:",
                                value: resultDateString,
                                accentColor: .red
                            )
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: 350)
                .padding(.trailing, 30)
            }
            .frame(height: 300)
            
            Spacer()
        }
        .frame(minWidth: 800, minHeight: 500)
        .padding(.bottom, 20)
        .navigationTitle("天计数/毫秒计数转换")
        .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
        .onAppear {
            dateString = dateFormatter.string(from: Date())
            // 初始化时自动计算结果
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                performConversion()
            }
        }
    }
    
    // MARK: - 结果框视图
    struct ResultBoxView: View {
        let title: String
        let value: String
        let accentColor: Color
        
        @Environment(\.colorScheme) private var colorScheme
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                // 标题部分
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(accentColor)
                
                // 内容部分
                Text(value)
                    .font(.title2)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(backgroundColor)
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(accentColor, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        
        // 根据当前主题自动选择背景色
        private var backgroundColor: Color {
            colorScheme == .dark ? Color(.darkGray) : Color.white
        }
        
        // 根据当前主题自动选择文本色
        private var textColor: Color {
            colorScheme == .dark ? Color.white : Color.black
        }
    }
    
    // MARK: - 自定义分段选择器
    struct SegmentedPickerWithCustomStyle: View {
        @Binding var selection: ConversionType
        @Environment(\.colorScheme) private var colorScheme
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(ConversionType.allCases, id: \.self) { type in
                    Button(action: {
                        selection = type
                    }) {
                        Text(type.title)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selection == type ? Color.blue : (colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1)))
                            .foregroundColor(selection == type ? .white : (colorScheme == .dark ? .white : .primary))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.gray.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // MARK: - 输入框区域
    @ViewBuilder
    private var inputBoxView: some View {
        VStack(alignment: .leading, spacing: 15) {
            switch conversionType {
            case .dateToCounters:
                Text("输入日期时间:")
                    .font(.headline)
                
                TextField("YYYY-MM-DDᵀHH:mm:ss", text: $dateString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 5)
                    .onChange(of: dateString) { _, _ in
                        performConversion()
                    }
                
                Button("使用当前时间") {
                    dateString = dateFormatter.string(from: Date())
                    performConversion()
                }
                .buttonStyle(.bordered)
                
            case .countersToDate:
                Text("输入天计数:")
                    .font(.headline)
                
                TextField("天数", text: $dayCount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: dayCount) { _, newValue in
                        let filtered = newValue.filter { $0.isNumber || $0 == "-" }
                        if filtered != newValue {
                            dayCount = filtered
                        }
                        performConversion()
                    }
                    .padding(.bottom, 5)
                
                Text("输入一天中的毫秒数:")
                    .font(.headline)
                
                TextField("一天中的毫秒数 (0-86399999)", text: $millisInDay)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: millisInDay) { _, newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            millisInDay = filtered
                        }
                        performConversion()
                    }
            }
            
            // 自定义起始时间选项
            Toggle(isOn: $useCustomReferenceDate) {
                Text("自定义起始时间")
                    .font(.subheadline)
            }
            .padding(.top, 10)
            .onChange(of: useCustomReferenceDate) { _, _ in
                performConversion()
            }
            
            if useCustomReferenceDate {
                TextField("起始日期 (YYYY-MM-DDᵀHH:mm:ss)", text: $referenceDateString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: referenceDateString) { _, _ in
                        performConversion()
                    }
            }
            
            // 转换按钮
            Button("开始转换") {
                performConversion()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 10)
        }
        .padding(colorScheme == .dark ? 15 : 0)
        .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.gray.opacity(0.05))
        .cornerRadius(colorScheme == .dark ? 10 : 0)
    }
    
    // MARK: - 功能方法
    private func clearResults() {
        resultDayCount = ""
        resultMilliseconds = ""
        resultDateString = ""
    }
    
    private func performConversion() {
        // 在计算前清除旧的结果，防止显示过时数据
        if conversionType == .dateToCounters {
            resultDayCount = ""
            resultMilliseconds = ""
        } else {
            resultDateString = ""
        }
        
        // 对于空输入，仅在必要字段填写完整时才计算
        switch conversionType {
        case .dateToCounters:
            if dateString.isEmpty { return }
        case .countersToDate:
            if dayCount.isEmpty || millisInDay.isEmpty { return }
        }
        
        // 获取自定义参考日期（如果有）
        var referenceDate: Date? = nil
        if useCustomReferenceDate {
            referenceDate = parseDate(from: referenceDateString)
            if referenceDate == nil && !referenceDateString.isEmpty {
                // 错误处理
                if conversionType == .dateToCounters {
                    resultDayCount = "参考日期格式错误"
                    resultMilliseconds = "参考日期格式错误"
                } else {
                    resultDateString = "参考日期格式错误"
                }
                return
            }
        }
        
        // 使用 do-catch 包裹转换逻辑，捕获可能的错误
        do {
            switch conversionType {
            case .dateToCounters:
                try convertDateToCounters(referenceDate: referenceDate)
            case .countersToDate:
                try convertCountersToDate(referenceDate: referenceDate)
            }
        } catch {
            print("转换错误: \(error)")
            if conversionType == .dateToCounters {
                resultDayCount = "转换出错"
                resultMilliseconds = "转换出错"
            } else {
                resultDateString = "转换出错"
            }
        }
    }
    
    private func convertDateToCounters(referenceDate: Date?) throws {
        guard let date = parseDate(from: dateString) else {
            resultDayCount = "日期格式错误"
            resultMilliseconds = "日期格式错误"
            return
        }
        
        // 计算天数部分 - 使用安全的方式
        let calendar = Calendar.current
        let refDate = referenceDate ?? Date(timeIntervalSince1970: 0)
        
        // 确保我们能获取到一天的开始
        guard let startOfRefDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: refDate) else {
            resultDayCount = "计算参考日期错误"
            resultMilliseconds = "计算参考日期错误"
            return
        }
        
        // 计算天数差 - 更可靠的方法
        let components = calendar.dateComponents([.day], from: startOfRefDay, to: date)
        
        guard let days = components.day else {
            resultDayCount = "计算天数错误"
            resultMilliseconds = "计算错误"
            return
        }
        
        // 计算当天内的毫秒数 - 更可靠的方法
        let timeComponents = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        
        let hours = timeComponents.hour ?? 0
        let minutes = timeComponents.minute ?? 0
        let seconds = timeComponents.second ?? 0
        let nanoseconds = timeComponents.nanosecond ?? 0
        
        let millisInDay = hours * 3600000 + minutes * 60000 + seconds * 1000 + nanoseconds / 1000000
        
        // 更新结果 - 确保不为空
        resultDayCount = String(days)
        resultMilliseconds = String(millisInDay)
        
        // 打印调试信息
        print("转换成功: 天数=\(days), 毫秒=\(millisInDay)")
    }
    
    private func convertCountersToDate(referenceDate: Date?) throws {
        guard let days = Int(dayCount) else {
            if !dayCount.isEmpty {
                resultDateString = "天数格式错误"
            }
            return
        }
        
        guard let millis = Int(millisInDay) else {
            if !millisInDay.isEmpty {
                resultDateString = "毫秒数格式错误"
            }
            return
        }
        
        if millis < 0 || millis >= 86400000 {
            resultDateString = "一天中的毫秒数必须在0到86399999之间"
            return
        }
        
        let calendar = Calendar.current
        let refDate = referenceDate ?? Date(timeIntervalSince1970: 0)
        
        // 确保我们能获取到一天的开始
        guard let startOfRefDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: refDate) else {
            resultDateString = "计算参考日期错误"
            return
        }
        
        // 先加上天数 - 使用更可靠的方法
        var dateComponents = DateComponents()
        dateComponents.day = days
        
        guard let datePart = calendar.date(byAdding: dateComponents, to: startOfRefDay) else {
            resultDateString = "日期计算错误"
            return
        }
        
        // 计算时间部分
        let hours = millis / 3600000
        let minutes = (millis % 3600000) / 60000
        let seconds = (millis % 60000) / 1000
        let milliseconds = millis % 1000
        
        var timeComponents = DateComponents()
        timeComponents.hour = hours
        timeComponents.minute = minutes
        timeComponents.second = seconds
        timeComponents.nanosecond = milliseconds * 1000000
        
        guard let resultDate = calendar.date(byAdding: timeComponents, to: datePart) else {
            resultDateString = "时间计算错误"
            return
        }
        
        resultDateString = dateFormatter.string(from: resultDate)
        
        // 打印调试信息
        print("转换成功: 日期=\(resultDateString)")
    }
}

#Preview {
    DayMillisecondConverterView()
        .environmentObject(ThemeManager())
} 