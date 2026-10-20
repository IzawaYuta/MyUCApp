
import SwiftUI

// MARK: - 食事の種類

enum MealType: CaseIterable, Identifiable {
    case breakfast, lunch, dinner, snack
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .breakfast: return "朝食"
        case .lunch:     return "昼食"
        case .dinner:    return "夕食"
        case .snack:     return "間食"
        }
    }
    
    var symbol: String {
        switch self {
        case .breakfast: return "sunrise"
        case .lunch:     return "sun.max"
        case .dinner:    return "moon"
        case .snack:     return "cup.and.saucer"
        }
    }
    
    /// 未記録のときの背景色
    var lightColor: Color {
        switch self {
        case .breakfast: return Color(hex: 0xFFF1D6)
        case .lunch:     return Color(hex: 0xDFF0FB)
        case .dinner:    return Color(hex: 0xE6E3F8)
        case .snack:     return Color(hex: 0xFBE4E6)
        }
    }
    
    /// 記録済みの背景色・文字色
    var strongColor: Color {
        switch self {
        case .breakfast: return Color(hex: 0x9A5B00)
        case .lunch:     return Color(hex: 0x0B6A9C)
        case .dinner:    return Color(hex: 0x4B3FA8)
        case .snack:     return Color(hex: 0xA8344A)
        }
    }
    
    /// 未記録のときの枠線の色
    var borderColor: Color {
        switch self {
        case .breakfast: return Color(hex: 0xF2C879)
        case .lunch:     return Color(hex: 0x9CCBE8)
        case .dinner:    return Color(hex: 0xB5AEE6)
        case .snack:     return Color(hex: 0xEDB0B8)
        }
    }
}

// MARK: - 服用のタイミング

enum MedicationSlot: CaseIterable, Identifiable {
    case morning, noon, evening, other
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .morning: return "朝"
        case .noon:    return "昼"
        case .evening: return "夕"
        case .other:   return "ほか"
        }
    }
    
    var symbol: String {
        switch self {
        case .morning: return "sunrise"
        case .noon:    return "sun.max"
        case .evening: return "moon"
        case .other:   return "ellipsis"
        }
    }
}

// MARK: - 次の通院

struct NextVisit {
    var hospitalName: String
    var department: String
    var date: Date            // 日付と時刻
    var items: [String]       // 診察、検査などの予定
}

// MARK: - ホーム画面に表示するデータ

struct HomeDisplayData {
    var today: Date
    var bowelCount: Int
    var takenMedicationSlots: Set<MedicationSlot>
    var recordedMeals: Set<MealType>
    var nextVisit: NextVisit
}

// MARK: - ダミーデータ（後で実データに差し替える）

extension HomeDisplayData {
    static let sample: HomeDisplayData = {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.date(from: DateComponents(year: 2026, month: 10, day: 12))!
        let visit = calendar.date(from: DateComponents(year: 2026, month: 11, day: 5, hour: 10, minute: 30))!
        
        return HomeDisplayData(
            today: today,
            bowelCount: 2,
            takenMedicationSlots: [.morning],
            recordedMeals: [.breakfast, .snack],
            nextVisit: NextVisit(
                hospitalName: "○○総合病院",
                department: "消化器内科",
                date: visit,
                items: ["診察", "大腸内視鏡検査"]
            )
        )
    }()
}

// MARK: - 日付の表示用

enum HomeFormatters {
    private static func make(_ format: String) -> DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = format
        return f
    }
    
    static let year      = make("yyyy年")
    static let monthDay  = make("M月d日")
    static let weekday   = make("EEEE")     // 月曜日
    static let time      = make("H:mm")
}
