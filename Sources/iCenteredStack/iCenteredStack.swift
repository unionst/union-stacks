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
        
        let centerSize = subviews[centerIndex].sizeThatFits(.unspecified)
        let centerX = bounds.midX - centerSize.width / 2
        
        let leftSideWidth = (bounds.width - centerSize.width) / 2 - spacing
        let rightSideWidth = leftSideWidth
        
        subviews[centerIndex].place(
            at: CGPoint(x: centerX, y: bounds.midY - centerSize.height / 2),
            anchor: .topLeading,
            proposal: ProposedViewSize(width: centerSize.width, height: centerSize.height)
        )
        
        let leftItems = subviews.prefix(centerIndex)
        if !leftItems.isEmpty {
            let widthPerLeftItem = leftSideWidth / CGFloat(leftItems.count)
            
            var leftXPosition = bounds.minX
            for (i, subview) in leftItems.enumerated() {
                let subviewSize = subview.sizeThatFits(ProposedViewSize(width: widthPerLeftItem, height: bounds.height))
                let yPosition = bounds.midY - subviewSize.height / 2
                
                subview.place(
                    at: CGPoint(x: leftXPosition, y: yPosition),
                    anchor: .topLeading,
                    proposal: ProposedViewSize(width: subviewSize.width, height: subviewSize.height)
                )
                
                leftXPosition += subviewSize.width + spacing
            }
        }
        
        let rightItems = subviews.suffix(subviews.count - centerIndex - 1)
        if !rightItems.isEmpty {
            let widthPerRightItem = rightSideWidth / CGFloat(rightItems.count)
            
            var rightXPosition = bounds.maxX
            for (i, subview) in rightItems.enumerated().reversed() {
                let subviewSize = subview.sizeThatFits(ProposedViewSize(width: widthPerRightItem, height: bounds.height))
                let yPosition = bounds.midY - subviewSize.height / 2
                
                rightXPosition -= subviewSize.width
                
                subview.place(
                    at: CGPoint(x: rightXPosition, y: yPosition),
                    anchor: .topLeading,
                    proposal: ProposedViewSize(width: subviewSize.width, height: subviewSize.height)
                )
                
                rightXPosition -= spacing
            }
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
