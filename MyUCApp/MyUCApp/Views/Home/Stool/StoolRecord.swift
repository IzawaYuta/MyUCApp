
import SwiftUI

// MARK: - 便の種類

enum StoolType: CaseIterable, Identifiable, Hashable {
    case normal, hard, soft, constipation, diarrhea, blood
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .normal:       return "普通"
        case .hard:         return "硬便"
        case .soft:         return "軟便"
        case .constipation: return "便秘"
        case .diarrhea:     return "下痢"
        case .blood:        return "血便"
        }
    }
    
    /// 丸い背景の色
    var tintColor: Color {
        switch self {
        case .normal:       return Color(hex: 0xE3F0EC)
        case .hard:         return Color(hex: 0xF3E9DA)
        case .soft:         return Color(hex: 0xFFF1D6)
        case .constipation: return Color(hex: 0xE6E8EE)
        case .diarrhea:     return Color(hex: 0xDFF0FB)
        case .blood:        return Color(hex: 0xFBE4E6)
        }
    }
    
    /// 絵と文字の色
    var foregroundColor: Color {
        switch self {
        case .normal:       return Color(hex: 0x1F6B60)
        case .hard:         return Color(hex: 0x7A5320)
        case .soft:         return Color(hex: 0x9A5B00)
        case .constipation: return Color(hex: 0x3F4A5C)
        case .diarrhea:     return Color(hex: 0x0B6A9C)
        case .blood:        return Color(hex: 0xA8344A)
        }
    }
    
    /// 血便だけ、絵を塗りつぶす
    var isFilledIcon: Bool { self == .blood }
}

// MARK: - 排便の記録（1回分）

struct StoolRecord: Identifiable {
    let id: UUID
    var recordedAt: Date
    var types: [StoolType]      // 複数の種類を選べる
    
    init(id: UUID = UUID(), recordedAt: Date, types: [StoolType]) {
        self.id = id
        self.recordedAt = recordedAt
        self.types = types
    }
}

// MARK: - ダミーデータ（後で実データに差し替える）

extension StoolRecord {
    /// 今日（2026年10月12日）の6回分。古い順。
    static let samples: [StoolRecord] = {
        let calendar = Calendar(identifier: .gregorian)
        func at(_ hour: Int, _ minute: Int) -> Date {
            calendar.date(from: DateComponents(year: 2026, month: 10, day: 12, hour: hour, minute: minute))!
        }
        return [
            StoolRecord(recordedAt: at(6, 45),  types: [.soft]),
            StoolRecord(recordedAt: at(8, 20),  types: [.normal]),
            StoolRecord(recordedAt: at(11, 40), types: [.diarrhea, .blood]),
            StoolRecord(recordedAt: at(15, 10), types: [.soft]),
            StoolRecord(recordedAt: at(19, 30), types: [.diarrhea]),
            StoolRecord(recordedAt: at(22, 5),  types: StoolType.allCases)   // 6種類すべて
        ]
    }()
}
