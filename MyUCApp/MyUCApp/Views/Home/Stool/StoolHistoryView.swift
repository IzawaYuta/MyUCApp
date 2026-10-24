
import SwiftUI

// MARK: - 排便の履歴（今日の分）

/// NavigationStack の中で push して使う想定です（戻るボタンは標準のもの）。
/// Theme.swift と HomeModels.swift（HomeFormatters）を使っています。
struct StoolHistoryView: View {
    var records: [StoolRecord] = StoolRecord.samples
    var today: Date = HomeDisplayData.sample.today
    
    /// 新しい記録を上にして、古い順の番号（1回目、2回目…）を付ける
    private var numbered: [(number: Int, record: StoolRecord)] {
        let ascending = records.sorted { $0.recordedAt < $1.recordedAt }
        return ascending.enumerated().map { (index, record) in
            (number: index + 1, record: record)
        }
        .reversed()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                SummaryCard(count: records.count, date: today)
                    .padding(.bottom, 4)
                
                ForEach(numbered, id: \.record.id) { item in
                    StoolRecordCard(number: item.number, record: item.record)
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 24)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("排便の履歴")
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
                Text("今日の排便")
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

private struct StoolRecordCard: View {
    let number: Int
    let record: StoolRecord
    
    /// 5種類以上のときは、1行に収まるよう小さいタイルにする
    private var isCompact: Bool { record.types.count > 4 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text("\(number)")
                        .font(.system(size: 22, weight: .bold))
                    Text("回目")
                        .font(.system(size: 13, weight: .bold))
                }
                .foregroundStyle(.white)
                .padding(.leading, 12)
                .padding(.trailing, 14)
                .padding(.vertical, 3)
                .background(Theme.accent, in: Capsule())
                
                Spacer()
                
                Text(HomeFormatters.time.string(from: record.recordedAt))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
            }
            
            if isCompact {
                HStack(spacing: 6) {
                    ForEach(record.types) { type in
                        StoolTile(type: type, compact: true)
                            .frame(maxWidth: .infinity)
                    }
                }
            } else {
                HStack(spacing: 8) {
                    ForEach(record.types) { type in
                        StoolTile(type: type, compact: false)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(number)回目 \(HomeFormatters.time.string(from: record.recordedAt)) "
            + record.types.map(\.title).joined(separator: "、")
        )
    }
}

// MARK: - 種類のタイル（丸い絵＋名前）

private struct StoolTile: View {
    let type: StoolType
    let compact: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            StoolIcon(type: type, size: compact ? 22 : 26)
                .frame(width: compact ? 36 : 44, height: compact ? 36 : 44)
                .background(type.tintColor, in: Circle())
            Text(type.title)
                .font(.system(size: compact ? 11 : 12, weight: .bold))
                .foregroundStyle(type.foregroundColor)
        }
        .frame(width: compact ? nil : 64)
    }
}

// MARK: - プレビュー

struct StoolHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StoolHistoryView()
        }
    }
}
