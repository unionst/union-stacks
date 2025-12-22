//
//  WrappingHStack.swift
//  UnionStacks
//
//  Created by Ben Sage on 12/22/24.
//

import SwiftUI

public struct WrappingHStack: Layout {
    var horizontalSpacing: CGFloat = 8
    var verticalSpacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let totalHeight = rows.reduce(0) { $0 + $1.height } + CGFloat(max(0, rows.count - 1)) * verticalSpacing
        return CGSize(width: proposal.width ?? 0, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        
        for row in rows {
            var x = bounds.minX
            
            for index in row.indices {
                let subview = subviews[index]
                let size = subview.sizeThatFits(.unspecified)
                subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + horizontalSpacing
            }
            
            y += row.height + verticalSpacing
        }
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [(indices: [Int], height: CGFloat)] {
        var rows: [(indices: [Int], height: CGFloat)] = []
        var currentRow: [Int] = []
        var currentWidth: CGFloat = 0
        var currentHeight: CGFloat = 0
        
        let maxWidth = proposal.width ?? .infinity
        
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            let requiredWidth = currentRow.isEmpty ? size.width : currentWidth + horizontalSpacing + size.width
            
            if requiredWidth <= maxWidth || currentRow.isEmpty {
                currentRow.append(index)
                currentWidth = requiredWidth
                currentHeight = max(currentHeight, size.height)
            } else {
                rows.append((indices: currentRow, height: currentHeight))
                currentRow = [index]
                currentWidth = size.width
                currentHeight = size.height
            }
        }
        
        if !currentRow.isEmpty {
            rows.append((indices: currentRow, height: currentHeight))
        }
        
        return rows
    }
}

