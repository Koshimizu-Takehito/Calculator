
//  PlusMinus.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/09/10.
//

import SwiftUI
import UIKit
import CoreGraphics

struct PlusMinusView: View {
    @State
    var size: CGFloat = CGFloat(40+380)/2
    @State
    var ratio: Double = 0.5

    var body: some View {
        ZStack {
            Text("%")
                .font(.system(size: size))
                .frame(width: size, height: size)
                .foregroundColor(Color(ratio: ratio))
                .opacity(min(1, max(0, abs(1-ratio))))
            PlusMinusShape()
                .fill(Color(ratio: ratio))
                .frame(width: size, height: size)
                .opacity(min(1, max(0, abs(ratio))))
            VStack(spacing: 24) {
                Spacer()
                Slider(value: $size, in: 40...380)
                    .accentColor(.green)
                Slider(value: $ratio, in: 0...1)
                    .accentColor(Color(ratio: ratio))
            }
            .padding(24)
        }
    }
}

private extension Color {
    init(ratio: Double) {
        let (r, s) = (ratio, 1-ratio)
        let component = (red: CGFloat.zero, green: CGFloat.zero, blue: CGFloat.zero, alpha: CGFloat.zero)
        var pink = component
        var blue = component
        UIColor.systemPink.getRed(&pink.0, green: &pink.1, blue: &pink.2, alpha: &pink.3)
        UIColor.systemBlue.getRed(&blue.0, green: &blue.1, blue: &blue.2, alpha: &blue.3)
        self.init(
            red: 1-(1-r*pink.red)*(1-s*blue.red),
            green: 1-(1-r*pink.green)*(1-s*blue.green),
            blue: 1-(1-r*pink.blue)*(1-s*blue.blue)
        )
    }
}

struct PlusMinusShape: Shape {
    func path(in rect: CGRect) -> Path {
        var rect = rect
        let width = min(rect.width, rect.height)
        rect.size = CGSize(width: width, height: width)
        rect.origin = CGPoint(x: max(0, rect.width-width)/2, y: max(0, rect.height-width)/2)

        let lineWidth = width * 0.076
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let t: CGFloat = -(.pi / 180) * 57.3
        var point = CGPoint()
        var radius = 0.83 * width/2
        point = CGPoint(x: center.x + lineWidth/2 + radius * cos(t), y: center.y + radius * sin(t))
        // 『/』
        let p1 = point
        point.x -= lineWidth
        let p2 = point
        radius = 1.02 * radius
        point = CGPoint(x: center.x - lineWidth/2 + radius * cos(t + .pi), y: center.y + radius * sin(t + .pi))
        let p3 = point
        point.x += lineWidth * 1.08
        let p4 = point
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.closeSubpath()
        // 『+』
        let w1: CGFloat = width * 0.25
        let h1: CGFloat = w1 * 0.25
        let c1: CGPoint = CGPoint(x: (center.x * 1.133)/2, y: (center.y+p1.y)/2)
        let p5 = CGRect(x: c1.x - w1/2, y: c1.y - h1/2, width: w1, height: h1)
        let p6 = CGRect(x: p5.midX - h1/2, y: p5.midY - w1/2, width: h1, height: w1)
        path.addRect(p5)
        path.addRect(p6)
        path.closeSubpath()
        // 『-』
        let c2: CGPoint = CGPoint(x: 0, y: (center.y+p3.y)/2)
        let p7 = CGRect(x: width-(c1.x - w1/2)-w1, y: c2.y - h1/2, width: w1, height: h1)
        path.addRect(p7)
        path.closeSubpath()

        return path
    }
}







struct PlusMinus_____Previews: PreviewProvider {
    static var previews: some View {
        PlusMinusView()
            .previewDevice("iPhone 13")
    }
}
