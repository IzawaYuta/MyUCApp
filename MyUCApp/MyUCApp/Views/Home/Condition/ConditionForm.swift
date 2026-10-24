
import Foundation
import SwiftUI

// MARK: - 病期

enum DiseaseStage: CaseIterable, Identifiable {
    case remission, active
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .remission: return "寛解期"
        case .active:    return "活動期"
        }
    }
    
    var textColor: Color {
        switch self {
        case .remission:
            return Color(
                red: 7 / 255,
                green: 7 / 255,
                blue: 187 / 255
            )
        case .active:
            return Color(
                red: 187 / 255,
                green: 7 / 255,
                blue: 7 / 255
            )
            
        }
    }
}

// MARK: - 全体の調子（顔の絵の5段階）

enum ConditionLevel: CaseIterable, Identifiable {
    case excellent, good, normal, poor, bad
    
    var id: Self { self }
    
    /// 画面には出さず、VoiceOver（読み上げ）用に使う
    var title: String {
        switch self {
        case .excellent: return "絶好調"
        case .good:      return "良い"
        case .normal:    return "ふつう"
        case .poor:      return "悪い"
        case .bad:       return "不調"
        }
    }
}

// MARK: - 腹痛の強さ

enum PainLevel: CaseIterable, Identifiable {
    case none, mild, moderate, severe
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .none:     return "なし"
        case .mild:     return "軽い"
        case .moderate: return "中くらい"
        case .severe:   return "強い"
        }
    }
}

// MARK: - 睡眠の質

enum SleepQuality: CaseIterable, Identifiable {
    case good, normal, poor
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .good:   return "良い"
        case .normal: return "ふつう"
        case .poor:   return "悪い"
        }
    }
}

// MARK: - 生理の有無

enum PeriodStatus: CaseIterable, Identifiable {
    case yes, no
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .yes: return "あり"
        case .no:  return "なし"
        }
    }
}

// MARK: - 今日の体調の入力内容

struct ConditionForm {
    var stage: DiseaseStage?
    var level: ConditionLevel?
    var pain: PainLevel?
    var sleepMinutes: Int?          // 睡眠時間（分）
    var sleepQuality: SleepQuality?
    var weightText: String          // kg
    var temperatureText: String     // ℃
    var hasFever: Bool
    var period: PeriodStatus?       // 生理（任意）
    var note: String                // 体調・症状（自由入力）
}

// MARK: - ダミーデータ（後で実データに差し替える）

extension ConditionForm {
    /// 入力前
    static let empty = ConditionForm(
        stage: nil,
        level: nil,
        pain: nil,
        sleepMinutes: nil,
        sleepQuality: nil,
        weightText: "",
        temperatureText: "",
        hasFever: false,
        period: nil,
        note: ""
    )
    
    /// 入力例
    static let sample = ConditionForm(
        stage: .remission,
        level: .normal,
        pain: .mild,
        sleepMinutes: 7 * 60 + 30,
        sleepQuality: .normal,
        weightText: "58.5",
        temperatureText: "36.6",
        hasFever: false,
        period: .no,
        note: "朝から腹痛が少しある。食欲は普通。\n夜はよく眠れた。"
    )
}

// MARK: - 表示用

extension Int {
    /// 450 → "7時間30分"
    var sleepDurationText: String {
        let hours = self / 60
        let minutes = self % 60
        return minutes == 0 ? "\(hours)時間" : "\(hours)時間\(minutes)分"
    }
}
