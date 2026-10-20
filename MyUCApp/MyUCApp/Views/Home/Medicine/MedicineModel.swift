
import Foundation

// MARK: - 服用のタイミング

enum MedicationTiming: CaseIterable, Identifiable {
    case afterWakingUp, beforeMeal, rightBeforeMeal, rightAfterMeal, afterMeal, beforeBed, asNeeded
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .afterWakingUp:   return "起床後"
        case .beforeMeal:      return "食前"
        case .rightBeforeMeal: return "食直前"
        case .rightAfterMeal:  return "食直後"
        case .afterMeal:       return "食後"
        case .beforeBed:       return "就寝前"
        case .asNeeded:        return "頓服"
        }
    }
}

// MARK: - 服用量（数字＋単位）

struct Dose: Hashable {
    var amount: Double
    var unit: String            // 錠、包、ml など
    
    /// 1 → "1錠"、0.5 → "0.5錠"
    var text: String {
        let isWhole = amount.rounded() == amount
        let number = isWhole ? String(Int(amount)) : String(amount)
        return number + unit
    }
}

// MARK: - 登録しているお薬

struct Medication: Identifiable, Hashable {
    let id: UUID
    var name: String
    var dose: Dose
    var timing: MedicationTiming
    var isActive: Bool          // 使用中かどうか
    
    init(id: UUID = UUID(), name: String, dose: Dose, timing: MedicationTiming, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.dose = dose
        self.timing = timing
        self.isActive = isActive
    }
}

// MARK: - 服用の記録（1回分）

struct MedicationLogItem: Identifiable {
    let id: UUID
    var name: String
    var dose: Dose
    
    init(id: UUID = UUID(), name: String, dose: Dose) {
        self.id = id
        self.name = name
        self.dose = dose
    }
}

struct MedicationLog: Identifiable {
    let id: UUID
    var takenAt: Date
    var timing: MedicationTiming
    var items: [MedicationLogItem]   // 同じ時間に飲んだお薬
    
    init(id: UUID = UUID(), takenAt: Date, timing: MedicationTiming, items: [MedicationLogItem]) {
        self.id = id
        self.takenAt = takenAt
        self.timing = timing
        self.items = items
    }
}

// MARK: - ダミーデータ（後で実データに差し替える）

extension Medication {
    /// 使用中のお薬（「飲んだお薬を選ぶ」シートに並べる）
    static let activeSamples: [Medication] = [
        Medication(name: "薬A", dose: Dose(amount: 1, unit: "錠"), timing: .afterMeal),
        Medication(name: "薬B", dose: Dose(amount: 1, unit: "包"), timing: .afterWakingUp),
        Medication(name: "薬C", dose: Dose(amount: 1, unit: "錠"), timing: .beforeBed),
        Medication(name: "薬D", dose: Dose(amount: 1, unit: "錠"), timing: .asNeeded)
    ]
}

extension MedicationLog {
    /// 今日（2026年10月12日）の5回分。古い順。
    static let samples: [MedicationLog] = {
        let calendar = Calendar(identifier: .gregorian)
        func at(_ hour: Int, _ minute: Int) -> Date {
            calendar.date(from: DateComponents(year: 2026, month: 10, day: 12, hour: hour, minute: minute))!
        }
        func dose(_ amount: Double, _ unit: String) -> Dose { Dose(amount: amount, unit: unit) }
        
        return [
            MedicationLog(takenAt: at(6, 50), timing: .afterWakingUp,
                          items: [MedicationLogItem(name: "薬E", dose: dose(1, "錠"))]),
            MedicationLog(takenAt: at(8, 10), timing: .afterMeal,
                          items: [MedicationLogItem(name: "薬A", dose: dose(2, "錠")),
                                  MedicationLogItem(name: "薬B", dose: dose(1, "包"))]),
            MedicationLog(takenAt: at(15, 20), timing: .asNeeded,
                          items: [MedicationLogItem(name: "薬D", dose: dose(1, "錠"))]),
            MedicationLog(takenAt: at(19, 0), timing: .afterMeal,
                          items: [MedicationLogItem(name: "薬A", dose: dose(1, "錠"))]),
            MedicationLog(takenAt: at(22, 30), timing: .beforeBed,
                          items: [MedicationLogItem(name: "薬C", dose: dose(1, "錠"))])
        ]
    }()
}
