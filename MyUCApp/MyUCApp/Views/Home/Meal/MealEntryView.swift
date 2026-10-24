
import SwiftUI

// MARK: - ボタンを押したときの処理（今は空。後で保存や画面遷移をつなぐ）

struct MealEntryActions {
    var cancel: () -> Void = {}
    var save: (MealEntryForm) -> Void = { _ in }
    var addPhoto: () -> Void = {}
    var openPhoto: (MealPhoto) -> Void = { _ in }
    var pickDate: () -> Void = {}
    var pickTime: () -> Void = {}
}

// MARK: - 食事を記録

/// ホームの食事のボタン（朝食・昼食・夕食・間食）から開く想定です。
/// Theme.swift と HomeModels.swift（MealType、HomeFormatters）を使っています。
struct MealEntryView: View {
    var today: Date = HomeDisplayData.sample.today
    var actions: MealEntryActions
    
    @State private var form: MealEntryForm
    
    init(
        form: MealEntryForm = .sample,
        today: Date = HomeDisplayData.sample.today,
        actions: MealEntryActions = MealEntryActions()
    ) {
        _form = State(initialValue: form)
        self.today = today
        self.actions = actions
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    header
                    photosCard
                    contentCard
                    timeRow
                    memoCard
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 24)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル", action: actions.cancel)
                        .foregroundStyle(Theme.secondaryText)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { actions.save(form) }
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.accentDark)
                }
            }
        }
    }
    
    // MARK: 見出し（食事の種類の色と絵つき）
    
    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: form.mealType.symbol)
                .font(.system(size: 22))
                .foregroundStyle(form.mealType.strongColor)
                .frame(width: 44, height: 44)
                .background(form.mealType.lightColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            Text("\(form.mealType.title)を記録")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.primaryText)
            Spacer(minLength: 0)
        }
        .padding(.top, 4)
        .accessibilityElement(children: .combine)
    }
    
    // MARK: 写真（複数枚）
    
    private var photosCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                SectionTitle("写真")
                Spacer()
                Text(form.photos.isEmpty ? "複数枚追加できます" : "\(form.photos.count)枚")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondaryText)
            }
            
            if form.photos.isEmpty {
                // 入力前：大きな「写真を追加」ボタン
                Button(action: actions.addPhoto) {
                    Label("写真を追加", systemImage: "camera")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Theme.accentDark)
                        .frame(maxWidth: .infinity)
                        .frame(height: 96)
                        .overlay(dashedBorder(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(form.photos) { photo in
                            Button { actions.openPhoto(photo) } label: {
                                MealPhotoThumbnail(photo: photo, size: 96, cornerRadius: 16)
                            }
                            .buttonStyle(.plain)
                        }
                        addTile
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, -16)   // カードの端までスクロールできるように
            }
        }
        .cardStyle(verticalPadding: 14)
    }
    
    private var addTile: some View {
        Button(action: actions.addPhoto) {
            VStack(spacing: 4) {
                Image(systemName: "camera")
                    .font(.system(size: 22))
                Text("追加")
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundStyle(Theme.accentDark)
            .frame(width: 96, height: 96)
            .overlay(dashedBorder(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("写真を追加")
    }
    
    private func dashedBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .strokeBorder(Theme.line, style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
    }
    
    // MARK: 食べたもの
    
    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle("食べたもの")
            PlaceholderEditor(
                text: $form.content,
                placeholder: "例：ごはん、味噌汁、焼き魚",
                height: 84,
                bordered: true
            )
        }
        .cardStyle(verticalPadding: 14)
    }
    
    // MARK: 時間（日付と時刻のボタン）
    
    private var timeRow: some View {
        HStack {
            Text("時間")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Theme.primaryText)
            Spacer()
            HStack(spacing: 8) {
                Button(action: actions.pickDate) {
                    TimePill(text: dateText)
                }
                .accessibilityLabel("日付を選ぶ 現在 \(dateText)")
                
                Button(action: actions.pickTime) {
                    TimePill(text: HomeFormatters.time.string(from: form.eatenAt), systemImage: "clock")
                }
                .accessibilityLabel("時刻を選ぶ 現在 \(HomeFormatters.time.string(from: form.eatenAt))")
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 64)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    private var dateText: String {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(form.eatenAt, inSameDayAs: today)
        ? "今日"
        : HomeFormatters.monthDay.string(from: form.eatenAt)
    }
    
    // MARK: メモ
    
    private var memoCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            SectionTitle("メモ")
            PlaceholderEditor(
                text: $form.memo,
                placeholder: "例：食欲があまりなかった、食後におなかが張った",
                height: 80,
                bordered: false
            )
        }
        .cardStyle(verticalPadding: 14)
    }
}

// MARK: - 部品

private struct SectionTitle: View {
    let text: String
    init(_ text: String) { self.text = text }
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Theme.secondaryText)
    }
}

/// 「今日」「8:10」の薄い緑の丸いボタンの見た目
private struct TimePill: View {
    let text: String
    var systemImage: String? = nil
    
    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))
            }
            Text(text)
        }
        .font(.system(size: 16, weight: .bold))
        .foregroundStyle(Theme.accentDark)
        .padding(.horizontal, 14)
        .frame(height: 44)
        .background(Theme.accentSoft, in: Capsule())
    }
}

/// 例文（プレースホルダー）つきの複数行入力欄
private struct PlaceholderEditor: View {
    @Binding var text: String
    let placeholder: String
    let height: CGFloat
    let bordered: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.system(size: bordered ? 16 : 15))
                .scrollContentBackground(.hidden)
                .padding(.horizontal, bordered ? 9 : -5)
                .padding(.vertical, bordered ? 6 : 0)
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: bordered ? 16 : 15))
                    .foregroundStyle(Color(hex: 0x8A9892))
                    .padding(.horizontal, bordered ? 14 : 0)
                    .padding(.vertical, bordered ? 14 : 8)
                    .allowsHitTesting(false)
            }
        }
        .frame(height: height)
        .overlay {
            if bordered {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Theme.line, lineWidth: 1.5)
            }
        }
    }
}

// MARK: - プレビュー

struct MealEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MealEntryView(form: .sample)
                .previewDisplayName("入力例")
            MealEntryView(form: .empty)
                .previewDisplayName("入力前")
        }
    }
}
