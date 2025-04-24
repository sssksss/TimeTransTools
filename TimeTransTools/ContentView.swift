//
//  ContentView.swift
//  TimeTransTools
//
//  Created by XWW on 2025/4/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State private var currentTime = Date()
    @State private var dateString: String = ""
    @State private var timestamp: String = ""
    @State private var showingTimestampResult: Bool = false
    @State private var useCustomReferenceDate: Bool = false
    @State private var referenceDateString: String = "1970-01-01T00:00:00"
    @State private var inputTimestamp: String = ""
    @State private var convertedDateString: String = ""
    @State private var isDateToTimestamp: Bool = true
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sss"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 25) {
            // 标题居中显示
            Text("时间转换工具")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
            
            // 分段控制器加宽
            Picker("", selection: $isDateToTimestamp) {
                Text("日期→时间戳").tag(true)
                Text("时间戳→日期").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 80)
            .onChange(of: isDateToTimestamp) {
                if isDateToTimestamp {
                    // 切换到日期→时间戳模式
                    dateString = dateFormatter.string(from: currentTime)
                    convertDateToTimestamp()
                    showingTimestampResult = true
                } else {
                    // 切换到时间戳→日期模式
                    inputTimestamp = "\(DateTimeConverter.currentTimestamp())"
                    convertTimestampToDate()
                }
                
                // 保持一致的自定义起始时间状态
                // 不重置useCustomReferenceDate，保持用户的选择
            }
            
            // 内容区域更加平衡
            HStack(alignment: .top, spacing: 50) {
                // 左侧：输入
                VStack(alignment: .leading, spacing: 15) {
                    if isDateToTimestamp {
                        Text("输入日期时间:")
                            .font(.headline)
                        
                        TextField("YYYY-MM-DDᵀHH:mm:sss", text: $dateString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                            .frame(width: 250)
                            .onAppear {
                                dateString = dateFormatter.string(from: currentTime)
                                // 初始时自动转换
                                convertDateToTimestamp()
                                showingTimestampResult = true
                            }
                            .onChange(of: dateString) {
                                // 当日期字符串变化时自动转换
                                convertDateToTimestamp()
                                showingTimestampResult = true
                            }
                        
                        Toggle("自定义起始时间", isOn: $useCustomReferenceDate)
                            .font(.subheadline)
                            .onChange(of: useCustomReferenceDate) {
                                // 当切换自定义起始时间选项时自动转换
                                convertDateToTimestamp()
                            }
                        
                        if useCustomReferenceDate {
                            TextField("起始日期 (YYYY-MM-DDᵀHH:mm:sss)", text: $referenceDateString)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.body)
                                .frame(width: 250)
                                .onChange(of: referenceDateString) {
                                    // 当参考日期变化时自动转换
                                    convertDateToTimestamp()
                                }
                        }
                        
                        HStack {
                            Button("转换为时间戳") {
                                convertDateToTimestamp()
                                showingTimestampResult = true
                            }
                            .buttonStyle(.bordered)
                            
                            Button("使用当前时间") {
                                dateString = dateFormatter.string(from: Date())
                            }
                            .buttonStyle(.bordered)
                        }
                    } else {
                        Text("输入时间戳:")
                            .font(.headline)
                        
                        TextField("Unix时间戳 (秒)", text: $inputTimestamp)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                            .frame(width: 250)
                            .onChange(of: inputTimestamp) { 
                                // 只保留数字字符
                                let filtered = inputTimestamp.filter { $0.isNumber }
                                if filtered != inputTimestamp {
                                    inputTimestamp = filtered
                                } else {
                                    // 当输入合法的时间戳时自动转换
                                    convertTimestampToDate()
                                }
                            }
                        
                        Toggle("自定义起始时间", isOn: $useCustomReferenceDate)
                            .font(.subheadline)
                            .onChange(of: useCustomReferenceDate) {
                                // 当切换自定义起始时间选项时自动转换
                                convertTimestampToDate()
                            }
                        
                        if useCustomReferenceDate {
                            TextField("起始日期 (YYYY-MM-DDᵀHH:mm:sss)", text: $referenceDateString)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.body)
                                .frame(width: 250)
                                .onChange(of: referenceDateString) {
                                    // 当参考日期变化时自动转换
                                    convertTimestampToDate()
                                }
                        }
                        
                        Button("转换为日期时间") {
                            convertTimestampToDate()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(20)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .frame(minHeight: 200)
                
                // 右侧：结果显示
                VStack(alignment: .center, spacing: 20) {
                    if isDateToTimestamp {
                        if showingTimestampResult {
                            Text("Unix时间戳:")
                                .font(.headline)
                            
                            Text(timestamp)
                                .font(.title)
                                .padding(20)
                                .frame(minWidth: 200)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        } else {
                            Text("请在左侧输入日期时间，然后点击转换按钮")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(minWidth: 200)
                                .padding()
                        }
                    } else {
                        if !convertedDateString.isEmpty {
                            Text("转换结果:")
                                .font(.headline)
                            
                            Text(convertedDateString)
                                .font(.title)
                                .padding(20)
                                .frame(minWidth: 200)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        } else {
                            Text("请在左侧输入时间戳，然后点击转换按钮")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(minWidth: 200)
                                .padding()
                        }
                    }
                }
                .padding(20)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .frame(minHeight: 200)
                .frame(minWidth: 250)
            }
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 600, minHeight: 350)
        .navigationTitle("时间转换工具")
    }
    
    func convertDateToTimestamp() {
        if useCustomReferenceDate {
            guard let referenceDate = dateFormatter.date(from: referenceDateString) else {
                timestamp = "参考日期格式错误"
                return
            }
            
            if let result = DateTimeConverter.dateStringToCustomTimestamp(
                dateString,
                referenceDate: referenceDate
            ) {
                timestamp = "\(result)"
            } else {
                timestamp = "日期格式错误"
            }
        } else {
            if let result = DateTimeConverter.dateStringToTimestamp(dateString) {
                timestamp = "\(result)"
            } else {
                timestamp = "日期格式错误"
            }
        }
    }
    
    func convertTimestampToDate() {
        if inputTimestamp.isEmpty {
            convertedDateString = "请输入时间戳"
            return
        }
        
        guard let timestampInt = Int(inputTimestamp) else {
            convertedDateString = "时间戳格式错误"
            return
        }
        
        if useCustomReferenceDate {
            guard let referenceDate = dateFormatter.date(from: referenceDateString) else {
                convertedDateString = "参考日期格式错误"
                return
            }
            
            // 使用自定义起始时间的转换方法
            convertedDateString = DateTimeConverter.timestampToDateStringWithCustomReference(
                timestampInt,
                referenceDate: referenceDate
            )
        } else {
            // 检查时间戳范围，避免太大或太小的值
            if timestampInt < -62135596800 || timestampInt > 253402300799 { // 大约 2000 BC 到 9999 AD
                convertedDateString = "时间戳超出合理范围"
                return
            }
            
            convertedDateString = DateTimeConverter.timestampToDateString(timestampInt)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
