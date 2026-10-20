
import SwiftUI

// MARK: - ボタンを押したときの処理（今は空。後で記録の保存や閉じる処理をつなぐ）

struct MedicationPickActions {
    var close: () -> Void = {}
    var confirm: (Set<UUID>) -> Void = { _ in }
}

// MARK: - 飲んだお薬を選ぶシート

/// ホーム画面の服用記録（朝・昼・夕・ほか）から、`.sheet` で開く想定です。
/// 使用中のお薬だけを並べ、複数選んで「確定」します。
/// Theme.swift を使っています。
struct MedicationPickSheet: View {
    let medications: [Medication]
    @State private var selection: Set<UUID>
    var actions: MedicationPickActions
    
    /// 初期値は、ダミーの薬A・薬Bを選んだ状態（2つ選択）
    init(
        medications: [Medication] = Medication.activeSamples,
        selection: Set<UUID>? = nil,
        actions: MedicationPickActions = MedicationPickActions()
    ) {
        self.medications = medications
        _selection = State(initialValue: selection ?? Set(medications.prefix(2).map(\.id)))
        self.actions = actions
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(medications.filter(\.isActive)) { medication in
                        MedicationPickRow(
                            medication: medication,
                            isSelected: selection.contains(medication.id)
                        ) {
                            toggle(medication.id)
                        }
                    }
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel("使用中のお薬")
            }
            
            confirmButton
        }
        .padding(.horizontal, 18)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Theme.card.ignoresSafeArea())
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: 見出し
    
    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text("飲んだお薬を選ぶ")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
                Text("使用中のお薬から、複数選べます")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondaryText)
            }
            Spacer()
            Button(action: actions.close) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.secondaryText)
                    .frame(width: 44, height: 44)
                    .background(Theme.chipGray, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("閉じる")
        }
    }
    
    // MARK: 確定ボタン
    
    private var confirmButton: some View {
        let count = selection.count
        return Button {
            actions.confirm(selection)
        } label: {
            Text(count > 0 ? "確定（\(count)）" : "確定")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(count > 0 ? Theme.accent : Color(hex: 0xC9D6D1), in: Capsule())
        }
        .buttonStyle(.plain)
        .disabled(count == 0)
    }
    
    // MARK: 選択の切り替え
    
    private func toggle(_ id: UUID) {
        if selection.contains(id) {
            selection.remove(id)
        } else {
            selection.insert(id)
        }
    }
}

// MARK: - お薬の行（チェックボックス付き）

private struct MedicationPickRow: View {
    let medication: Medication
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                checkbox
                
                // 薬の写真の代わりに、アイコンを置いています
                Image(systemName: "pills")
                    .font(.system(size: 20))
                    .foregroundStyle(Theme.accentDark)
                    .frame(width: 44, height: 44)
                    .background(Theme.accentSoft, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(medication.name)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(Theme.primaryText)
                        Text(medication.dose.text)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Theme.accentDark)
                    }
                    Text(medication.timing.title)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondaryText)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .background(
                isSelected ? Color(hex: 0xF4FAF8) : Theme.chipGray,
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? Theme.accent : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(medication.name) \(medication.dose.text)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    private var checkbox: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isSelected ? Theme.accent : Color.white)
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(isSelected ? Color.clear : Theme.line, lineWidth: 2)
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 28, height: 28)
    }
}

// MARK: - プレビュー（ホーム画面の上にシートを出した状態）

struct MedicationPickSheet_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .sheet(isPresented: .constant(true)) {
                MedicationPickSheet()
            }
    }
}
