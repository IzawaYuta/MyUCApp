
import SwiftUI

let customOrange: Color = Color(
    red: 224 / 255,
    green: 146 / 255,
    blue: 0 / 255
)

let customBlue: Color = Color(
    red: 47 / 255,
    green: 169 / 255,
    blue: 188 / 255
)

let customPurple: Color = Color(
    red: 108 / 255,
    green: 92 / 255,
    blue: 231 / 255
)

let customRed: Color = Color(
    red: 193 / 255,
    green: 6 / 255,
    blue: 6 / 255
)

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
        case .breakfast:
            return Color.clear
        case .lunch:
            return Color.clear
        case .dinner:
            return Color.clear
        case .snack:
            return Color.clear
        }
    }
    
    /// 記録済みの背景色・文字色
    var strongColor: Color {
        switch self {
        case .breakfast:
            return Color(
                red: 224 / 255,
                green: 146 / 255,
                blue: 0 / 255
            )
        case .lunch:
            return Color(
                red: 47 / 255,
                green: 169 / 255,
                blue: 188 / 255
            )
        case .dinner:
            return Color(
                red: 108 / 255,
                green: 92 / 255,
                blue: 231 / 255
            )
        case .snack:
            return Color(
                red: 193 / 255,
                green: 6 / 255,
                blue: 6 / 255
            )
        }
    }
    
    /// 未記録のときの枠線の色
    var borderColor: Color {
        switch self {
        case .breakfast:
            return Color(
                red: 224 / 255,
                green: 146 / 255,
                blue: 0 / 255
            )
        case .lunch:
            return Color(
                red: 47 / 255,
                green: 169 / 255,
                blue: 188 / 255
            )
        case .dinner:
            return Color(
                red: 108 / 255,
                green: 92 / 255,
                blue: 231 / 255
            )
        case .snack:
            return Color(
                red: 193 / 255,
                green: 6 / 255,
                blue: 6 / 255
            )
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
    
    /// 未記録のときの背景色
    var lightColor: Color {
        switch self {
        case .morning:
            return Color.clear
        case .noon:
            return Color.clear
        case .evening:
            return Color.clear
        case .other:
            return Color.clear
        }
    }
    
    /// 記録済みの背景色・文字色
    var strongColor: Color {
        switch self {
        case .morning:
            return Color(
                red: 224 / 255,
                green: 146 / 255,
                blue: 0 / 255
            )
        case .noon:
            return Color(
                red: 47 / 255,
                green: 169 / 255,
                blue: 188 / 255
            )
        case .evening:
            return Color(
                red: 108 / 255,
                green: 92 / 255,
                blue: 231 / 255
            )
        case .other:
            return Color(
                red: 193 / 255,
                green: 6 / 255,
                blue: 6 / 255
            )
        }
    }
    
    /// 未記録のときの枠線の色
    var borderColor: Color {
        switch self {
        case .morning:
            return Color(
                red: 224 / 255,
                green: 146 / 255,
                blue: 0 / 255
            )
        case .noon:
            return Color(
                red: 47 / 255,
                green: 169 / 255,
                blue: 188 / 255
            )
        case .evening:
            return Color(
                red: 108 / 255,
                green: 92 / 255,
                blue: 231 / 255
            )
        case .other:
            return Color(
                red: 193 / 255,
                green: 6 / 255,
                blue: 6 / 255
            )
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
            takenMedicationSlots: [],
            recordedMeals: [.breakfast, .lunch, .dinner, .snack],
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
