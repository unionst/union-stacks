//
//  CStack.swift
//  union-stacks
//
//  Created by Ben Sage on 3/8/25.
//

import SwiftUI

/// A layout that centers the middle child and distributes remaining children equally on left and right sides.
///
/// `CStack` divides its children into three sections: left items, a center item, and right items.
/// The center child (at index `count / 2`) takes its ideal size and is positioned at the horizontal
/// center. All items to the left share the available left space equally, and all items to the right
/// share the available right space equally.
///
/// ## Basic Usage
///
/// ```swift
/// struct NavigationBarView: View {
///     var body: some View {
///         CStack(spacing: 10) {
///             Button("Cancel") { }
///             Text("Title").font(.headline)
///             Button("Save") { }
///         }
///         .frame(height: 44)
///     }
/// }
/// ```
///
/// ## How It Works
///
/// Given 5 children `[A, B, C, D, E]`:
/// - Items `[A, B]` go on the left side, sharing available left space equally
/// - Item `C` (at index 2) becomes the center, taking its ideal size
/// - Items `[D, E]` go on the right side, sharing available right space equally
///
/// The center element is positioned at the horizontal midpoint, and the left/right sides
/// fill the remaining space on each side, minus the specified spacing.
///
/// ## Common Patterns
///
/// **Navigation bar layout:**
///
/// ```swift
/// struct CustomNavBar: View {
///     var body: some View {
///         CStack {
///             Button("Back") { }
///             Text("Settings")
///             Spacer().frame(width: 0)
///         }
///         .padding()
///     }
/// }
/// ```
///
/// **Symmetric action layout:**
///
/// ```swift
/// struct ActionBar: View {
///     var body: some View {
///         CStack(spacing: 20) {
///             Button("Delete") { }
///             Text("3 items selected")
///             Button("Share") { }
///         }
///     }
/// }
/// ```
///
/// **When to use CStack vs HStack:**
///
/// | Layout | Behavior | Best For |
/// |--------|----------|----------|
/// | `CStack` | Guarantees center alignment for middle child | Navigation bars, symmetric toolbars |
/// | `HStack` with `Spacer` | Flexible spacing, no guaranteed center | Most horizontal layouts |
///
/// **Important:** The center child is always the element at index `count / 2`. For even counts,
/// this uses integer division (e.g., with 4 children, index 2 is the center). Plan your child
/// order accordingly to ensure the correct element ends up centered.
public struct CStack: Layout {
    
    /// The spacing between adjacent children.
    ///
    /// This spacing applies between left-side items, between the leftmost item and center,
    /// between the center and rightmost item, and between right-side items.
    ///
    /// ```swift
    /// CStack(spacing: 10) {
    ///     Text("Left")
    ///     Text("Center")
    ///     Text("Right")
    /// }
    /// ```
    ///
    /// Setting spacing to `0` places children directly adjacent to each other.
    public var spacing: CGFloat = 0
    
    /// Creates a CStack with the specified spacing between children.
    ///
    /// The spacing is applied uniformly between all adjacent children, including between
    /// the left section and center, and between the center and right section.
    ///
    /// - Parameter spacing: The horizontal spacing between adjacent children. Defaults to `0`.
    ///
    /// ```swift
    /// struct ToolbarView: View {
    ///     var body: some View {
    ///         CStack(spacing: 16) {
    ///             Button("Edit") { }
    ///             Text("Document Title")
    ///             Button("Done") { }
    ///         }
    ///     }
    /// }
    /// ```
    public init(spacing: CGFloat = 0) {
        self.spacing = spacing
    }
    
    /// Calculates the size that fits the proposed size.
    ///
    /// CStack calculates its height as the maximum height of all children, ensuring all
    /// children fit within the same vertical space. The width is taken from the proposal.
    ///
    /// This method is called by SwiftUI's layout system to determine how much space the
    /// layout needs. You rarely call this directly - SwiftUI handles it automatically
    /// when sizing views.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size from the parent container.
    ///   - subviews: The child views to measure.
    ///   - cache: Storage for computed layout values (unused by CStack).
    ///
    /// - Returns: A size with the proposed width and the maximum child height.
    ///
    /// ```swift
    /// let layout = CStack()
    /// let size = layout.sizeThatFits(
    ///     proposal: ProposedViewSize(width: 300, height: 50),
    ///     subviews: subviews,
    ///     cache: &cache
    /// )
    /// print(size)
    /// ```
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let maxHeight = subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
        let width = proposal.width ?? 0
        
        return CGSize(width: width, height: maxHeight)
    }
    
    /// Positions the subviews within the given bounds.
    ///
    /// This method performs the core CStack layout algorithm:
    /// 1. Identifies the center child (at index `count / 2`)
    /// 2. Places the center child at the horizontal midpoint
    /// 3. Distributes left children equally in the left side
    /// 4. Distributes right children equally in the right side
    ///
    /// All children are vertically centered within the bounds.
    ///
    /// This method is called by SwiftUI's layout system during the layout pass.
    /// You don't call this directly - SwiftUI manages the layout cycle automatically.
    ///
    /// - Parameters:
    ///   - bounds: The rectangular region in which to place subviews.
    ///   - proposal: The size proposed by the parent (used for child sizing).
    ///   - subviews: The child views to position.
    ///   - cache: Storage for computed layout values (unused by CStack).
    ///
    /// ```swift
    /// let layout = CStack(spacing: 10)
    /// layout.placeSubviews(
    ///     in: CGRect(x: 0, y: 0, width: 300, height: 50),
    ///     proposal: ProposedViewSize(width: 300, height: 50),
    ///     subviews: subviews,
    ///     cache: &cache
    /// )
    /// ```
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
            for subview in leftItems {
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
            for subview in rightItems.reversed() {
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
        CStack(spacing: 0) {
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

        CStack(spacing: 10) {
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
