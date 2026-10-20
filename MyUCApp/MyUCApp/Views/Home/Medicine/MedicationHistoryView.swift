
import SwiftUI

// MARK: - 服用の履歴（今日の分）

/// NavigationStack の中で push して使う想定です（戻るボタンは標準のもの）。
/// Theme.swift と HomeModels.swift（HomeFormatters）を使っています。
struct MedicationHistoryView: View {
    var logs: [MedicationLog] = MedicationLog.samples
    var today: Date = HomeDisplayData.sample.today
    
    /// 新しい記録を上にする
    private var newestFirst: [MedicationLog] {
        logs.sorted { $0.takenAt > $1.takenAt }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                SummaryCard(count: logs.count, date: today)
                    .padding(.bottom, 4)
                
                ForEach(newestFirst) { log in
                    MedicationLogCard(log: log)
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 24)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("服用の履歴")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - 今日の合計

private struct SummaryCard: View {
    let count: Int
    let date: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("今日の服用")
                    .font(.system(size: 14, weight: .bold))
                Text("\(HomeFormatters.monthDay.string(from: date)) \(HomeFormatters.weekday.string(from: date))")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondaryText)
            }
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(count)")
                    .font(.system(size: 44, weight: .bold))
                Text("回")
                    .font(.system(size: 18, weight: .bold))
            }
        }
        .foregroundStyle(Theme.accentDark)
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Theme.accentSoft, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

// MARK: - 1回分のカード

private struct MedicationLogCard: View {
    let log: MedicationLog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Text(HomeFormatters.time.string(from: log.takenAt))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
                Text(log.timing.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.accentDark)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 3)
                    .background(Theme.accentSoft, in: Capsule())
            }
            
            VStack(spacing: 0) {
                ForEach(Array(log.items.enumerated()), id: \.element.id) { index, item in
                    if index > 0 {
                        Divider()
                    }
                    MedicationLogRow(item: item)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .accessibilityElement(children: .contain)
    }
}

private struct MedicationLogRow: View {
    let item: MedicationLogItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "pills")
                .font(.system(size: 16))
                .foregroundStyle(Theme.accentDark)
                .frame(width: 36, height: 36)
                .background(Theme.accentSoft, in: Circle())
            Text(item.name)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Theme.primaryText)
            Spacer()
            Text(item.dose.text)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Theme.accentDark)
        }
        .frame(minHeight: 48)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - プレビュー

struct MedicationHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MedicationHistoryView()
        }
    }
}
