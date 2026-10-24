
import SwiftUI

struct SleepTimePickerSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    /// 確定した時間を呼び出し元に返す
    let onComplete: (Date) -> Void
    
    /// 選択中の時間
    @State private var selectedTime: Date
    
    /// 初期値を指定
    init(
        initialTime: Date = Date(),
        onComplete: @escaping (Date) -> Void
    ) {
        self.onComplete = onComplete
        _selectedTime = State(initialValue: initialTime)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                DatePicker(
                    "時間",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .clipped()
            }
            .padding(.top, 24)
            .padding(.horizontal, 20)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") {
                        onComplete(selectedTime)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.visible)
    }
}


#Preview {
    SleepTimePickerSheetView(onComplete: { _ in })
}
