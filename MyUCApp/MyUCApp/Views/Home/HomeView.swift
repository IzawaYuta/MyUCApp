
import SwiftUI

// MARK: - ボタンを押したときの処理（今は空。後でデータ操作や画面遷移をつなぐ）

struct HomeActions {
    var openCondition: () -> Void = {}
    var addBowelQuickly: () -> Void = {}
    var openBowelTypePicker: () -> Void = {}
    var openBowelHistory: () -> Void = {}
    var tapMedication: (MedicationSlot) -> Void = { _ in }
    var openMedicationHistory: () -> Void = {}
    var tapMeal: (MealType) -> Void = { _ in }
    var openMealHistory: () -> Void = {}
}

// MARK: - ホーム画面

struct HomeView: View {
    var data: HomeDisplayData = .sample
    var actions: HomeActions = HomeActions()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                DateHeader(date: data.today)
                ConditionButton(action: actions.openCondition)
                BowelCard(
                    count: data.bowelCount,
                    onQuickAdd: actions.addBowelQuickly,
                    onPickType: actions.openBowelTypePicker,
                    onHistory: actions.openBowelHistory
                )
                MedicationCard(
                    taken: data.takenMedicationSlots,
                    onTap: actions.tapMedication,
                    onHistory: actions.openMedicationHistory
                )
                MealCard(
                    recorded: data.recordedMeals,
                    onTap: actions.tapMeal,
                    onHistory: actions.openMealHistory
                )
                NextVisitCard(visit: data.nextVisit, today: data.today)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Theme.background.ignoresSafeArea())
    }
}

// MARK: - 日付

private struct DateHeader: View {
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(HomeFormatters.year.string(from: date))
                .font(.system(size: 13))
                .foregroundStyle(Theme.secondaryText)
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(HomeFormatters.monthDay.string(from: date))
                    .font(.system(size: 30, weight: .bold))
                Text(HomeFormatters.weekday.string(from: date))
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Theme.secondaryText)
            }
            .foregroundStyle(Theme.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - 今日の体調ボタン

private struct ConditionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.accentDark)
                    .frame(width: 44, height: 44)
                    .background(Theme.accentSoft, in: Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("今日の体調を記録")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.primaryText)
                    Text("病期・症状を入力する")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondaryText)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.secondaryText)
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 64)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("今日の体調を記録する")
    }
}

// MARK: - カードの見出し

private struct CardHeader: View {
    let title: String
    var systemImage: String? = nil
    var historyLabel: String = "履歴を見る"
    var onHistory: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Theme.secondaryText)
            
            Spacer()
            
            if let onHistory {
                Button(action: onHistory) {
                    HStack(spacing: 2) {
                        Text("履歴")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.accentDark)
                    .frame(minHeight: 44)
                    .padding(.leading, 12)
                }
                .accessibilityLabel(historyLabel)
            }
        }
        .frame(minHeight: 34)
    }
}

// MARK: - 排便

private struct BowelCard: View {
    let count: Int
    let onQuickAdd: () -> Void
    let onPickType: () -> Void
    let onHistory: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(title: "今日の排便", historyLabel: "排便の履歴を見る", onHistory: onHistory)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(count)")
                    .font(.system(size: 44, weight: .bold))
                Text("回")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(Theme.primaryText)
            .accessibilityElement(children: .combine)
            
            // 左：すぐ記録 ／ 右：種類を選ぶ（分割ボタン）
            HStack(spacing: 2) {
                Button(action: onQuickAdd) {
                    Label("すぐ記録", systemImage: "plus")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Theme.accent)
                }
                
                Button(action: onPickType) {
                    HStack(spacing: 4) {
                        Text("種類を選ぶ")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.accentDark)
                    .frame(width: 140)
                    .frame(maxHeight: .infinity)
                    .background(Theme.accentSoft)
                }
            }
            .buttonStyle(.plain)
            .frame(height: 56)
            .clipShape(Capsule())
        }
        .cardStyle()
    }
}

// MARK: - 4つの正方形ボタン（服用・食事で共通）

private struct SquareRecordButton: View {
    let title: String
    let symbol: String
    let isDone: Bool
    let lightColor: Color
    let strongColor: Color
    let borderColor: Color
    let titleColor: Color
    let accessibilityText: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            Button(action: action) {
                VStack(spacing: 4) {
                    Image(systemName: symbol)
                        .font(.system(size: 22))
                    Image(systemName: isDone ? "checkmark" : "plus")
                        .font(.system(size: 20, weight: .bold))
                }
                .foregroundStyle(isDone ? Color.white : strongColor)
                .frame(width: 74, height: 74)
                .background(
                    isDone ? strongColor : lightColor,
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .overlay {
                    if !isDone {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(borderColor, lineWidth: 1.5)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(accessibilityText)
            
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(titleColor)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 服用記録

private struct MedicationCard: View {
    let taken: Set<MedicationSlot>
    let onTap: (MedicationSlot) -> Void
    let onHistory: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(
                title: "服用記録",
                systemImage: "pills",
                historyLabel: "服用の履歴を見る",
                onHistory: onHistory
            )
            
            HStack(spacing: 0) {
                ForEach(MedicationSlot.allCases) { slot in
                    let isDone = taken.contains(slot)
                    SquareRecordButton(
                        title: slot.title,
                        symbol: slot.symbol,
                        isDone: isDone,
                        lightColor: Theme.accentSoft,
                        strongColor: Theme.accent,
                        borderColor: Theme.line,
                        titleColor: Theme.primaryText,
                        accessibilityText: isDone ? "\(slot.title)の薬 服用済み" : "\(slot.title)の薬を服用した",
                        action: { onTap(slot) }
                    )
                }
            }
        }
        .cardStyle()
    }
}

// MARK: - 食事記録

private struct MealCard: View {
    let recorded: Set<MealType>
    let onTap: (MealType) -> Void
    let onHistory: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(title: "食事", historyLabel: "食事の履歴を見る", onHistory: onHistory)
            
            HStack(spacing: 0) {
                ForEach(MealType.allCases) { meal in
                    let isDone = recorded.contains(meal)
                    SquareRecordButton(
                        title: meal.title,
                        symbol: meal.symbol,
                        isDone: isDone,
                        lightColor: meal.lightColor,
                        strongColor: meal.strongColor,
                        borderColor: meal.borderColor,
                        titleColor: meal.strongColor,
                        accessibilityText: isDone ? "\(meal.title) 記録済み" : "\(meal.title)を追加",
                        action: { onTap(meal) }
                    )
                }
            }
        }
        .cardStyle()
    }
}

// MARK: - 次の通院

private struct NextVisitCard: View {
    let visit: NextVisit
    let today: Date
    
    private var daysLeft: Int {
        let calendar = Calendar(identifier: .gregorian)
        let start = calendar.startOfDay(for: today)
        let end = calendar.startOfDay(for: visit.date)
        return calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("次の通院")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.secondaryText)
                Spacer()
                Text("あと\(daysLeft)日")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.accentDark)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Theme.accentSoft, in: Capsule())
            }
            .frame(minHeight: 34)
            
            HStack(spacing: 8) {
                Image(systemName: "building.2")
                    .font(.system(size: 18))
                    .foregroundStyle(Theme.secondaryText)
                Text("\(visit.hospitalName) \(visit.department)")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
            }
            .accessibilityElement(children: .combine)
            
            HStack(spacing: 8) {
                InfoTile(symbol: "calendar", caption: "日付") {
                    Text(HomeFormatters.monthDay.string(from: visit.date))
                        .font(.system(size: 17, weight: .bold))
                    + Text(" " + HomeFormatters.weekday.string(from: visit.date))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.secondaryText)
                }
                InfoTile(symbol: "clock", caption: "診察時間") {
                    Text(HomeFormatters.time.string(from: visit.date))
                        .font(.system(size: 17, weight: .bold))
                }
            }
            
            HStack(spacing: 6) {
                ForEach(visit.items, id: \.self) { item in
                    Text(item)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondaryText)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Theme.chipGray, in: Capsule())
                }
            }
        }
        .cardStyle()
    }
}

private struct InfoTile<Value: View>: View {
    let symbol: String
    let caption: String
    @ViewBuilder var value: () -> Value
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 18))
                .foregroundStyle(Theme.accentDark)
            VStack(alignment: .leading, spacing: 0) {
                Text(caption)
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.secondaryText)
                value()
                    .foregroundStyle(Theme.primaryText)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Theme.accentSoft, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

// MARK: - プレビュー

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
