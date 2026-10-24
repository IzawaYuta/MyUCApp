
import SwiftUI

// MARK: - 便の種類の絵（24×24 の座標で描いて、大きさに合わせて拡大）

struct StoolIconShape: Shape {
    let type: StoolType
    
    func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 24
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + x * s, y: rect.minY + y * s)
        }
        func circle(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat) -> CGRect {
            CGRect(x: rect.minX + (cx - r) * s, y: rect.minY + (cy - r) * s, width: 2 * r * s, height: 2 * r * s)
        }
        
        var path = Path()
        switch type {
        case .normal:
            // なめらかな棒状
            path.addRoundedRect(
                in: CGRect(x: rect.minX + 3 * s, y: rect.minY + 8.5 * s, width: 18 * s, height: 7 * s),
                cornerSize: CGSize(width: 3.5 * s, height: 3.5 * s)
            )
            
        case .hard:
            // コロコロした3つの粒
            path.addEllipse(in: circle(5.5, 12, 2.4))
            path.addEllipse(in: circle(12, 12, 2.4))
            path.addEllipse(in: circle(18.5, 12, 2.4))
            
        case .soft:
            // 形がくずれたかたまり
            path.move(to: p(4, 16))
            path.addCurve(to: p(9, 11),  control1: p(3, 13),  control2: p(6, 11))
            path.addCurve(to: p(15, 9),  control1: p(11, 11), control2: p(12, 9))
            path.addCurve(to: p(20, 14), control1: p(18, 9),  control2: p(20, 11))
            path.addCurve(to: p(14, 18), control1: p(20, 17), control2: p(17, 18))
            path.addLine(to: p(8, 18))
            path.addCurve(to: p(4, 16),  control1: p(6, 18),  control2: p(4.5, 17.5))
            path.closeSubpath()
            
        case .constipation:
            // 小さな粒と、出ない線
            path.addEllipse(in: circle(8, 12, 2.6))
            path.move(to: p(14, 12))
            path.addLine(to: p(20, 12))
            
        case .diarrhea, .blood:
            // しずく（半円は2本の曲線で近似）
            path.move(to: p(12, 3.5))
            path.addCurve(to: p(18, 14),   control1: p(12, 3.5),     control2: p(18, 10))
            path.addCurve(to: p(12, 20),   control1: p(18, 17.31),   control2: p(15.31, 20))
            path.addCurve(to: p(6, 14),    control1: p(8.69, 20),    control2: p(6, 17.31))
            path.addCurve(to: p(12, 3.5),  control1: p(6, 10),       control2: p(12, 3.5))
            path.closeSubpath()
        }
        return path
    }
}

struct StoolIcon: View {
    let type: StoolType
    var size: CGFloat = 24
    var color: Color? = nil
    
    var body: some View {
        let tint = color ?? type.foregroundColor
        ZStack {
            if type.isFilledIcon {
                StoolIconShape(type: type).fill(tint)
            }
            StoolIconShape(type: type)
                .stroke(tint, style: StrokeStyle(lineWidth: 2 * size / 24, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
