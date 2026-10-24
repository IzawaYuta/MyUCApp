
import SwiftUI

// MARK: - 食事の履歴（今日の分・時間順に上から下へ）

/// NavigationStack の中で push して使う想定です（戻るボタンは標準のもの）。
/// Theme.swift と HomeModels.swift（MealType、HomeFormatters）を使っています。
struct MealHistoryView: View {
    var records: [MealRecord] = MealRecord.samples
    var today: Date = HomeDisplayData.sample.today
    
    /// 時間の早い順（朝 → 夜）
    private var chronological: [MealRecord] {
        records.sorted { $0.eatenAt < $1.eatenAt }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                SummaryCard(records: records, date: today)
                    .padding(.bottom, 4)
                
                ForEach(chronological) { record in
                    MealRecordCard(record: record)
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 24)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("食事の履歴")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - 今日の合計（種類ごとの回数つき）

private struct SummaryCard: View {
    let records: [MealRecord]
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("今日の食事")
                        .font(.system(size: 14, weight: .bold))
                    Text("\(HomeFormatters.monthDay.string(from: date)) \(HomeFormatters.weekday.string(from: date))")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondaryText)
                }
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(records.count)")
                        .font(.system(size: 44, weight: .bold))
                    Text("回")
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .foregroundStyle(Theme.accentDark)
            
            HStack(spacing: 6) {
                ForEach(MealType.allCases) { type in
                    let count = records.filter { $0.mealType == type }.count
                    if count > 0 {
                        Text("\(type.title) \(count)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(type.strongColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 2)
                            .background(type.lightColor, in: Capsule())
                    }
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.accentSoft, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

// MARK: - 1回分のカード

private struct MealRecordCard: View {
    let record: MealRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Text(HomeFormatters.time.string(from: record.eatenAt))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
                Text(record.mealType.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(record.mealType.strongColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 3)
                    .background(record.mealType.lightColor, in: Capsule())
            }
            
            Text(record.content)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Theme.primaryText)
            
            if !record.photos.isEmpty {
                HStack(spacing: 8) {
                    ForEach(record.photos) { photo in
                        MealPhotoThumbnail(photo: photo, size: 64, cornerRadius: 12)
                    }
                }
            }
            
            if !record.memo.isEmpty {
                Label(record.memo, systemImage: "note.text")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.secondaryText)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .accessibilityElement(children: .contain)
    }
}

// MARK: - プレビュー

struct MealHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MealHistoryView()
        }
    }
}
