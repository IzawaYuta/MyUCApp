
import SwiftUI

/// 食事の写真の四角。画像がないあいだは、色付きの四角＋お皿の絵で代用します。
struct MealPhotoThumbnail: View {
    let photo: MealPhoto
    var size: CGFloat = 64
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        ZStack {
            if let name = photo.assetName {
                Image(name)
                    .resizable()
                    .scaledToFill()
            } else {
                photo.placeholderColor
                Image(systemName: "fork.knife")
                    .font(.system(size: size * 0.4))
                    .foregroundStyle(Theme.accentDark)
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .accessibilityLabel("食事の写真")
    }
}
