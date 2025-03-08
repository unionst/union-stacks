//
//  iCenteredStack.swift
//  iCenteredStack
//
//  Created by Benjamin Sage on 3/8/25.
//  Requires iOS 16+, macOS 13+, tvOS 16+, watchOS 9+
//

import SwiftUI

public struct iCenteredStack: Layout {
    public var spacing: CGFloat = 0
    
    public init(spacing: CGFloat = 0) {
        self.spacing = spacing
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let maxHeight = subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
        let width = proposal.width ?? 0
        
        return CGSize(width: width, height: maxHeight)
    }
    
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        guard !subviews.isEmpty else { return }
        
        let centerIndex = subviews.count / 2
        let totalSpacing = spacing * CGFloat(subviews.count - 1)
        
        let centerSize = subviews[centerIndex].sizeThatFits(.unspecified)
        let centerX = bounds.midX - centerSize.width / 2
        
        let sideItemsSpace = bounds.width - centerSize.width - totalSpacing
        let spacePerSide = sideItemsSpace / 2
        
        var xPosition = bounds.minX
        
        for (index, subview) in subviews.enumerated() {
            let subviewSize: CGSize
            
            if index == centerIndex {
                subviewSize = centerSize
                xPosition = centerX
            } else if index < centerIndex {
                let availableWidth = spacePerSide / CGFloat(centerIndex)
                subviewSize = subview
                    .sizeThatFits(ProposedViewSize(width: availableWidth, height: bounds.height))
            } else {
                let availableWidth = spacePerSide / CGFloat(subviews.count - centerIndex - 1)
                subviewSize = subview
                    .sizeThatFits(ProposedViewSize(width: availableWidth, height: bounds.height))
            }
            
            let yPosition = bounds.midY - subviewSize.height / 2
            let point = CGPoint(x: xPosition, y: yPosition)
            
            subview.place(
                at: point,
                anchor: .topLeading,
                proposal: ProposedViewSize(width: subviewSize.width, height: subviewSize.height)
            )
            
            xPosition += subviewSize.width + spacing
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        iCenteredStack(spacing: 0) {
            Text("Short")
                .padding(.horizontal, 10)
                .background(Color.red.opacity(0.3))

            Text("Center")
                .padding()
                .background(Color.blue.opacity(0.3))

            Text("Longer text on right side")
                .padding(.horizontal, 10)
                .background(Color.green.opacity(0.3))
        }
        .border(Color.gray)

        iCenteredStack(spacing: 10) {
            Text("Left with a lot more content")
                .padding(.horizontal, 10)
                .background(Color.purple.opacity(0.3))

            Text("Center")
                .padding()
                .background(Color.blue.opacity(0.3))

            Text("Right")
                .padding(.horizontal, 10)
                .background(Color.orange.opacity(0.3))
        }
        .border(Color.gray)
    }
    .padding()
}
