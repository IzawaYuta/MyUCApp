
import SwiftUI

// MARK: - ボタンを押したときの処理（今は空。後で記録の保存や閉じる処理をつなぐ）

struct StoolSheetActions {
    var close: () -> Void = {}
    var record: (Set<StoolType>) -> Void = { _ in }
}

// MARK: - 排便の種類を選ぶシート

/// ホーム画面の「種類を選ぶ」から、`.sheet` で開く想定です。
/// Theme.swift を使っています。
struct StoolTypeSheet: View {
    @State private var selection: Set<StoolType>
    var actions: StoolSheetActions
    
    init(selection: Set<StoolType> = [.soft, .blood], actions: StoolSheetActions = StoolSheetActions()) {
        _selection = State(initialValue: selection)
        self.actions = actions
    }
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(StoolType.allCases) { type in
                    StoolOptionButton(type: type, isSelected: selection.contains(type)) {
                        toggle(type)
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("便の種類（複数選択可）")
            
            recordButton
        }
        .padding(.horizontal, 18)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Theme.card.ignoresSafeArea())
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: 見出し
    
    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text("排便の種類を選ぶ")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
                Text("当てはまるものをすべて選べます")
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
    
    // MARK: 記録ボタン
    
    private var recordButton: some View {
        let count = selection.count
        return Button {
            actions.record(selection)
        } label: {
            Group {
                if count > 0 {
                    Label("\(count)種類を1回として記録", systemImage: "plus")
                } else {
                    Text("種類を選んでください")
                }
            }
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
    
    private func toggle(_ type: StoolType) {
        if selection.contains(type) {
            selection.remove(type)
        } else {
            selection.insert(type)
        }
    }
}

// MARK: - 種類のボタン（3列×2行）

private struct StoolOptionButton: View {
    let type: StoolType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                StoolIcon(type: type, size: 24)
                    .frame(width: 40, height: 40)
                    .background(type.tintColor, in: Circle())
                Text(type.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 96)
            .background(
                isSelected ? Color.white : Theme.chipGray,
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? Theme.accent : Color.clear, lineWidth: 2)
            )
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                        .background(Theme.accent, in: Circle())
                        .padding(6)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(type.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - プレビュー（ホーム画面の上にシートを出した状態）

struct StoolTypeSheet_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .sheet(isPresented: .constant(true)) {
                StoolTypeSheet()
            }
    }
}
