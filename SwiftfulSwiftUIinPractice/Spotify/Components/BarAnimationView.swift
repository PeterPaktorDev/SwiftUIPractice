//
//  BarAnimationView.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/19.
//

import Foundation
import SwiftUI

struct BarAnimationView: View {
    @State private var barHeights: [CGFloat] = [5, 10, 15]
    @State private var animate = false

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                BarView(height: barHeights[index])
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                            withAnimation(Animation.linear(duration: 0.3).repeatForever(autoreverses: true)) {
                                barHeights = (0..<3).map { _ in CGFloat.random(in: 1...15) }
                            }
                        }
        }
        .frame(height: 15, alignment: .bottom)
    }
}

struct BarView: View {
    var height: CGFloat

    var body: some View {
        Rectangle()
            .fill(Color.spotifyGreen)
            .frame(width: 2, height: height)
    }
}

struct BarAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        BarAnimationView()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}
