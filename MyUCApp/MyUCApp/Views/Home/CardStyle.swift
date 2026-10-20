
import SwiftUI

// MARK: - Color(hex:)

extension Color {
    /// 例: Color(hex: 0x1F7A6D)
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

// MARK: - デザイントークン（デザイン案の配色）

enum Theme {
    static let background    = Color(hex: 0xF2F6F4)
    static let card          = Color.white
    static let primaryText   = Color(hex: 0x1F2D2A)
    static let secondaryText = Color(hex: 0x566763)
    
    static let accent        = Color(hex: 0x1F7A6D)   // 緑（主ボタン・記録済み）
    static let accentDark    = Color(hex: 0x1F6B60)   // 緑（文字・アイコン）
    static let accentSoft    = Color(hex: 0xE3F0EC)   // 薄い緑（背景）
    static let line          = Color(hex: 0xBFD3CD)   // 枠線
    static let chipGray      = Color(hex: 0xF2F6F4)   // タグの背景
}

// MARK: - カードの見た目

struct CardStyle: ViewModifier {
    var verticalPadding: CGFloat = 12
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.top, verticalPadding)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

extension View {
    func cardStyle(verticalPadding: CGFloat = 12) -> some View {
        modifier(CardStyle(verticalPadding: verticalPadding))
    }
}
