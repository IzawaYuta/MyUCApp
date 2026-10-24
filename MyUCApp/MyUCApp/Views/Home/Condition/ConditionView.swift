
import SwiftUI

// MARK: - ボタンを押したときの処理（今は空。後で保存や画面遷移をつなぐ）

struct ConditionActions {
    var cancel: () -> Void = {}
    var save: (ConditionForm) -> Void = { _ in }
    var openSleepDurationPicker: () -> Void = {}
}

// MARK: - 今日の体調

/// Theme.swift と HomeModels.swift（HomeFormatters）を使っています。
struct ConditionView: View {
    var date: Date = HomeDisplayData.sample.today
    var actions: ConditionActions = ConditionActions()
    
    let customRed: Color = Color(red: 226 / 255, green: 50 / 255, blue: 50 / 255)
    
    @State private var form: ConditionForm
    
    init(
        form: ConditionForm = .sample,
        date: Date = HomeDisplayData.sample.today,
        actions: ConditionActions = ConditionActions()
    ) {
        _form = State(initialValue: form)
        self.date = date
        self.actions = actions
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    header
                    stageRow
                    levelCard
                    painCard
                    sleepCard
                    bodyNumbersCard
                    periodRow
                    noteCard
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
    
    // MARK: 見出し
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("今日の体調")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.primaryText)
            Text("\(HomeFormatters.monthDay.string(from: date)) \(HomeFormatters.weekday.string(from: date))")
                .font(.system(size: 14))
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }
    
    // MARK: 病期（プルダウン）
    
    private var stageRow: some View {
        HStack {
            Text("病期")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Theme.primaryText)
            Spacer()
            Menu {
                ForEach(DiseaseStage.allCases) { stage in
                    Button(stage.title) { form.stage = stage }
                }
            } label: {
                PillLabel(
                    text: form.stage?.title,
                    isWarning: form.stage == .active
                )
            }
            .accessibilityLabel("病期を選ぶ")
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 64)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    // MARK: 全体の調子（顔の絵）
    
    // MARK: - 全体の調子（5段階）
    
    private var levelCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle("全体の調子")
            
            // 左から「悪い → 普通 → 良い」の順に並べる
            let levels: [ConditionLevel] = [
                .bad,
                .poor,
                .normal,
                .good,
                .excellent
            ]
            
            VStack(spacing: 1) {
                // 5つの点と、点どうしをつなぐ線
                HStack(spacing: 0) {
                    ForEach(Array(levels.enumerated()), id: \.element.id) { index, level in
                        let isSelected = form.level == level
                        
                        ZStack {
                            // 線は「点ごとのマス」に左半分・右半分を描く。
                            // 最初のマスの左側と、最後のマスの右側は描かないので、
                            // 線が両端の点からはみ出ない。
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(index == 0 ? Color.clear : Theme.line)
                                Rectangle()
                                    .fill(index == levels.count - 1 ? Color.clear : Theme.line)
                            }
                            .frame(height: 2)
                            
                            // 点
                            Button {
                                form.level = level
                            } label: {
                                Circle()
                                    .fill(isSelected ? Theme.accent : Color.white)
                                    .frame(width: 20, height: 20)
                                    .overlay {
                                        Circle()
                                            .strokeBorder(
                                                isSelected ? Theme.accent : Theme.line,
                                                lineWidth: 2
                                            )
                                    }
                                    .frame(width: 44, height: 44)   // タップしやすい大きさ
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(level.title)
                            .accessibilityAddTraits(isSelected ? .isSelected : [])
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    }
                }
                
                // 点の下にラベルを表示（1・3・5番目の点の真下）
                HStack(spacing: 0) {
                    Text("悪い")
                        .frame(maxWidth: .infinity)
                    
                    Color.clear
                        .frame(maxWidth: .infinity)
                    
                    Text("普通")
                        .frame(maxWidth: .infinity)
                    
                    Color.clear
                        .frame(maxWidth: .infinity)
                    
                    Text("良い")
                        .frame(maxWidth: .infinity)
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.secondaryText)
            }
        }
        .cardStyle(verticalPadding: 18)
    }
    
    // MARK: 腹痛の強さ
    
    private var painCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("腹痛の強さ")
            SegmentedChoice(
                options: PainLevel.allCases,
                title: \.title,
                selection: $form.pain,
                accessibilityLabel: "腹痛の強さ"
            )
        }
        .cardStyle(verticalPadding: 14)
    }
    
    // MARK: 睡眠
    
    private var sleepCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("睡眠時間")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
                Spacer()
                Button(action: actions.openSleepDurationPicker) {
                    PillLabel(text: form.sleepMinutes?.sleepDurationText, placeholder: "選ぶ")
                }
                .buttonStyle(.plain)
                .accessibilityLabel("睡眠時間を選ぶ")
            }
            .frame(minHeight: 44)
            
            SectionTitle("睡眠の質")
            SegmentedChoice(
                options: SleepQuality.allCases,
                title: \.title,
                selection: $form.sleepQuality,
                accessibilityLabel: "睡眠の質"
            )
        }
        .cardStyle(verticalPadding: 14)
    }
    
    // MARK: 体重・体温・発熱
    
    private var bodyNumbersCard: some View {
        VStack(spacing: 0) {
            NumberRow(title: "体重", text: $form.weightText, unit: "kg", placeholder: "0.0")
            Divider()
            NumberRow(title: "体温", text: $form.temperatureText, unit: "℃", placeholder: "36.0")
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("発熱")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.primaryText)
                    Text("37.5℃以上など")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondaryText)
                }
                Spacer()
                Toggle("発熱", isOn: $form.hasFever)
                    .labelsHidden()
                    .tint(Theme.accent)
            }
            .frame(minHeight: 60)
        }
        .padding(.horizontal, 16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    // MARK: 生理（任意）
    
    private var periodRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("生理（任意）")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
                Text("設定でオン・オフできます")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondaryText)
            }
            Spacer()
            Menu {
                ForEach(PeriodStatus.allCases) { status in
                    Button(status.title) { form.period = status }
                }
            } label: {
                PillLabel(
                    text: form.period?.title,
                    isWarning: form.period == .yes
                )
            }
            .accessibilityLabel("生理の有無を選ぶ")
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 64)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    // MARK: 体調・症状（自由入力）
    
    private var noteCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                SectionTitle("体調・症状（自由入力）")
                Text("その日の様子や気になることを、自由に書けます")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondaryText)
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $form.note)
                    .font(.system(size: 16))
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                if form.note.isEmpty {
                    Text("例：朝から腹痛が少しある。夜はよく眠れた。")
                        .font(.system(size: 16))
                        .foregroundStyle(Color(hex: 0x8A9892))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Theme.line, lineWidth: 1.5)
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

/// 病期・生理などで使う、▲▼付きの丸いボタンの見た目
private struct PillLabel: View {
    let text: String?
    var placeholder: String = "選択してください"
    var isWarning: Bool = false
    
    private var isSet: Bool {
        text != nil
    }
    
    private var foregroundColor: Color {
        guard isSet else {
            return Theme.secondaryText
        }
        
        return isWarning ? StatusColor.warning : StatusColor.normal
    }
    
    private var dotColor: Color {
        isWarning ? StatusColor.warning : StatusColor.normalDot
    }
    
    private var backgroundColor: Color {
        guard isSet else {
            return .white
        }
        
        return isWarning
        ? StatusColor.warningBackground
        : StatusColor.normalBackground
    }
    
    private var borderColor: Color {
        guard isSet else {
            return Theme.line
        }
        
        return isWarning ? StatusColor.warning : Theme.accent
    }
    
    var body: some View {
        HStack(spacing: 8) {
            if let text {
                Circle()
                    .fill(dotColor)
                    .frame(width: 8, height: 8)
                Text(text)
            } else {
                Text(placeholder)
            }
            Image(systemName: "chevron.up.chevron.down")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black)
        }
        .font(.system(size: 16, weight: .bold))
        .foregroundStyle(foregroundColor)
        .padding(.horizontal, 14)
        .frame(height: 44)
        .background(backgroundColor, in: Capsule())
        .overlay {
            Capsule()
                .strokeBorder(
                    borderColor,
                    style: StrokeStyle(
                        lineWidth: isSet ? 1 : 1.5,
                        dash: isSet ? [] : [4, 3]
                    )
                )
        }
    }
}

/// 顔の絵のボタン（文字なし。読み上げ用の名前だけ付ける）
private struct FaceButton: View {
    let level: ConditionLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            FaceShape(level: level)
                .stroke(
                    isSelected ? Color.white : Theme.accentDark,
                    style: StrokeStyle(lineWidth: 1.8 * 38 / 24, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 38, height: 38)
                .frame(width: 58, height: 58)
                .background(isSelected ? Theme.accent : Color.white, in: Circle())
                .overlay {
                    if !isSelected {
                        Circle().strokeBorder(Theme.line, lineWidth: 1.5)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(level.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// 顔（輪郭・目・口）。24×24 の座標で描いて、大きさに合わせて拡大します。
private struct FaceShape: Shape {
    let level: ConditionLevel
    
    func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 24
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + x * s, y: rect.minY + y * s)
        }
        
        var path = Path()
        // 輪郭
        path.addEllipse(in: CGRect(x: rect.minX + 2 * s, y: rect.minY + 2 * s, width: 20 * s, height: 20 * s))
        // 目（丸い線の端で点にする）
        path.move(to: p(9, 10));  path.addLine(to: p(9.01, 10))
        path.move(to: p(15, 10)); path.addLine(to: p(15.01, 10))
        
        // 口
        switch level {
        case .excellent:
            path.move(to: p(8, 14))
            path.addCurve(to: p(16, 14), control1: p(9, 17), control2: p(15, 17))
        case .good:
            path.move(to: p(8.5, 14.5))
            path.addCurve(to: p(15.5, 14.5), control1: p(10, 16.3), control2: p(14, 16.3))
        case .normal:
            path.move(to: p(9, 15.5))
            path.addLine(to: p(15, 15.5))
        case .poor:
            path.move(to: p(8.5, 16.5))
            path.addCurve(to: p(15.5, 16.5), control1: p(10, 14.7), control2: p(14, 14.7))
        case .bad:
            path.move(to: p(8, 17.5))
            path.addCurve(to: p(16, 17.5), control1: p(9, 14.5), control2: p(15, 14.5))
        }
        return path
    }
}

/// 灰色の台に、選んだ項目だけ白く浮かぶ切り替え
private struct SegmentedChoice<Value: Hashable & Identifiable>: View {
    let options: [Value]
    let title: KeyPath<Value, String>
    @Binding var selection: Value?
    let accessibilityLabel: String
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(options) { option in
                let isSelected = selection == option
                Button {
                    selection = option
                } label: {
                    Text(option[keyPath: title])
                        .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                        .foregroundStyle(isSelected ? Theme.accentDark : Theme.secondaryText)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(
                            isSelected ? Color.white : Color.clear,
                            in: RoundedRectangle(cornerRadius: 9, style: .continuous)
                        )
                        .shadow(color: isSelected ? Color.black.opacity(0.12) : .clear, radius: 1.5, y: 1)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(3)
        .background(Color(hex: 0xE6EEEB), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
    }
}

/// 体重・体温の行（右にキーボードで入力）
private struct NumberRow: View {
    let title: String
    @Binding var text: String
    let unit: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Theme.primaryText)
            Spacer()
            HStack(spacing: 6) {
                TextField(placeholder, text: $text)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.horizontal, 10)
                    .frame(width: 84, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Theme.line, lineWidth: 1.5)
                    )
                    .accessibilityLabel(title)
                Text(unit)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.secondaryText)
                    .frame(width: 24, alignment: .leading)
            }
        }
        .frame(minHeight: 60)
    }
}

// MARK: - プレビュー

struct ConditionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ConditionView(form: .sample)
                .previewDisplayName("入力例")
            ConditionView(form: .empty)
                .previewDisplayName("入力前")
        }
    }
}
