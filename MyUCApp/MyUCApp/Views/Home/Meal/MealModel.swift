
import SwiftUI

// MARK: - 食事の写真

struct MealPhoto: Identifiable {
    let id: UUID
    /// 実際の画像（Assets の名前）。nil のあいだは、色付きの四角で代用する
    var assetName: String?
    var placeholderColor: Color
    
    init(id: UUID = UUID(), assetName: String? = nil, placeholderColor: Color = Theme.accentSoft) {
        self.id = id
        self.assetName = assetName
        self.placeholderColor = placeholderColor
    }
}

// MARK: - 食事の記録（1回分）

struct MealRecord: Identifiable {
    let id: UUID
    var mealType: MealType
    var eatenAt: Date
    var content: String         // 食べたもの
    var memo: String
    var photos: [MealPhoto]
    
    init(
        id: UUID = UUID(),
        mealType: MealType,
        eatenAt: Date,
        content: String,
        memo: String = "",
        photos: [MealPhoto] = []
    ) {
        self.id = id
        self.mealType = mealType
        self.eatenAt = eatenAt
        self.content = content
        self.memo = memo
        self.photos = photos
    }
}

// MARK: - 「食事を記録」画面の入力内容

struct MealEntryForm {
    var mealType: MealType
    var photos: [MealPhoto]
    var content: String
    var eatenAt: Date
    var memo: String
}

// MARK: - ダミーデータ（後で実データに差し替える）

private let dummyPhotoColors: [Color] = [
    Color(hex: 0xE3F0EC),
    Color(hex: 0xFFF1D6),
    Color(hex: 0xDFF0FB)
]

private func dummyPhotos(_ count: Int) -> [MealPhoto] {
    (0..<count).map { MealPhoto(placeholderColor: dummyPhotoColors[$0 % dummyPhotoColors.count]) }
}

private func todayAt(_ hour: Int, _ minute: Int) -> Date {
    Calendar(identifier: .gregorian)
        .date(from: DateComponents(year: 2026, month: 10, day: 12, hour: hour, minute: minute))!
}

extension MealEntryForm {
    /// 入力例（朝食）
    static let sample = MealEntryForm(
        mealType: .breakfast,
        photos: dummyPhotos(3),
        content: "おかゆ、卵焼き、味噌汁",
        eatenAt: todayAt(8, 10),
        memo: "食欲はふつう"
    )
    
    /// 入力前
    static let empty = MealEntryForm(
        mealType: .breakfast,
        photos: [],
        content: "",
        eatenAt: todayAt(8, 10),
        memo: ""
    )
}

extension MealRecord {
    /// 今日（2026年10月12日）の5回分。古い順。
    static let samples: [MealRecord] = [
        MealRecord(mealType: .breakfast, eatenAt: todayAt(8, 10),
                   content: "おかゆ、卵焼き、味噌汁", memo: "食欲はふつう", photos: dummyPhotos(3)),
        MealRecord(mealType: .lunch, eatenAt: todayAt(12, 30),
                   content: "うどん、バナナ", photos: dummyPhotos(1)),
        MealRecord(mealType: .snack, eatenAt: todayAt(15, 20),
                   content: "ヨーグルト"),
        MealRecord(mealType: .snack, eatenAt: todayAt(17, 0),
                   content: "クッキー"),
        MealRecord(mealType: .dinner, eatenAt: todayAt(19, 0),
                   content: "ごはん、焼き魚、野菜スープ", memo: "少し残した", photos: dummyPhotos(2))
    ]
}
