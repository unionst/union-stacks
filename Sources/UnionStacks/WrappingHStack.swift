//
//  WrappingHStack.swift
//  UnionStacks
//
//  Created by Ben Sage on 12/22/24.
//

import SwiftUI

/// A layout that arranges children horizontally and wraps to new rows when space runs out.
///
/// `WrappingHStack` flows children left-to-right like an `HStack`, but automatically wraps
/// to the next row when adding another child would exceed the available width. Each row's
/// height is determined by its tallest child.
///
/// This creates a "flow layout" behavior similar to CSS flexbox with `flex-wrap: wrap` or
/// text flowing across lines in a paragraph.
///
/// ## Basic Usage
///
/// ```swift
/// struct TagListView: View {
///     let tags = ["Swift", "SwiftUI", "iOS", "macOS", "Xcode"]
///     
///     var body: some View {
///         WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
///             ForEach(tags, id: \.self) { tag in
///                 Text(tag)
///                     .padding(.horizontal, 12)
///                     .padding(.vertical, 6)
///                     .background(Color.blue.opacity(0.2))
///                     .cornerRadius(8)
///             }
///         }
///     }
/// }
/// ```
///
/// ## How It Works
///
/// WrappingHStack places children row by row:
/// 1. Measures each child's ideal size
/// 2. Adds children to the current row until adding another would exceed the width
/// 3. Starts a new row and continues placing remaining children
/// 4. Each row's height is the maximum height of its children
///
/// Children are always placed at their ideal size - WrappingHStack doesn't stretch or
/// compress children to fit.
///
/// ## Common Patterns
///
/// **Tag collection:**
///
/// ```swift
/// struct HashtagView: View {
///     let hashtags = ["#swift", "#ios", "#development"]
///     
///     var body: some View {
///         WrappingHStack {
///             ForEach(hashtags, id: \.self) { tag in
///                 Text(tag)
///                     .padding(8)
///                     .background(Color.purple.opacity(0.2))
///                     .cornerRadius(4)
///             }
///         }
///         .padding()
///     }
/// }
/// ```
///
/// **Filter chips:**
///
/// ```swift
/// struct FilterBar: View {
///     let filters = ["All", "Active", "Completed", "Archived"]
///     @State private var selected = "All"
///     
///     var body: some View {
///         WrappingHStack(horizontalSpacing: 12) {
///             ForEach(filters, id: \.self) { filter in
///                 Button(filter) {
///                     selected = filter
///                 }
///                 .buttonStyle(.bordered)
///             }
///         }
///     }
/// }
/// ```
///
/// **When to use WrappingHStack vs HStack:**
///
/// | Layout | Behavior | Best For |
/// |--------|----------|----------|
/// | `WrappingHStack` | Wraps to multiple rows when needed | Tags, chips, variable-length collections |
/// | `HStack` | Single row, may truncate or overflow | Fixed content, navigation bars |
/// | `LazyVGrid` | Grid with explicit columns | Uniform items, photo grids |
///
/// **Important:** WrappingHStack always takes the full proposed width. Children wrap based
/// on this width, not on their container's current size. If you need responsive wrapping
/// in a narrower container, ensure the parent properly constrains the width.
public struct WrappingHStack: Layout {
    
    /// The horizontal spacing between adjacent children within a row.
    ///
    /// This spacing is applied between children on the same row. It does not affect
    /// spacing between rows (use `verticalSpacing` for that).
    ///
    /// ```swift
    /// WrappingHStack(horizontalSpacing: 12) {
    ///     Text("One")
    ///     Text("Two")
    ///     Text("Three")
    /// }
    /// ```
    ///
    /// Setting to `0` places children directly adjacent within rows.
    public var horizontalSpacing: CGFloat
    
    /// The vertical spacing between rows.
    ///
    /// This spacing is applied between rows when children wrap. It does not affect
    /// spacing within a single row (use `horizontalSpacing` for that).
    ///
    /// ```swift
    /// WrappingHStack(verticalSpacing: 16) {
    ///     ForEach(0..<20) { i in
    ///         Text("Item \(i)")
    ///     }
    /// }
    /// ```
    ///
    /// Setting to `0` stacks rows directly adjacent vertically.
    public var verticalSpacing: CGFloat
    
    /// Creates a WrappingHStack with the specified spacing.
    ///
    /// Both spacing values default to `8` points, matching typical UI spacing conventions.
    /// Adjust these to create tighter or looser layouts.
    ///
    /// - Parameters:
    ///   - horizontalSpacing: The spacing between children within a row. Defaults to `8`.
    ///   - verticalSpacing: The spacing between rows. Defaults to `8`.
    ///
    /// ```swift
    /// struct CompactTagsView: View {
    ///     let tags = ["iOS", "Swift", "SwiftUI"]
    ///     
    ///     var body: some View {
    ///         WrappingHStack(horizontalSpacing: 4, verticalSpacing: 4) {
    ///             ForEach(tags, id: \.self) { tag in
    ///                 Text(tag).padding(4)
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    public init(horizontalSpacing: CGFloat = 8, verticalSpacing: CGFloat = 8) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
    
    /// Calculates the size that fits the proposed size.
    ///
    /// WrappingHStack computes the row layout to determine total height needed. The width
    /// is taken from the proposal, and height is the sum of all row heights plus vertical
    /// spacing between rows.
    ///
    /// This method is called by SwiftUI's layout system to determine how much space the
    /// layout needs. You rarely call this directly - SwiftUI handles it automatically
    /// when sizing views.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size from the parent container.
    ///   - subviews: The child views to measure.
    ///   - cache: Storage for computed layout values (unused by WrappingHStack).
    ///
    /// - Returns: A size with the proposed width and computed height based on row wrapping.
    ///
    /// ```swift
    /// let layout = WrappingHStack()
    /// let size = layout.sizeThatFits(
    ///     proposal: ProposedViewSize(width: 300, height: nil),
    ///     subviews: subviews,
    ///     cache: &cache
    /// )
    /// print(size)
    /// ```
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let totalHeight = rows.reduce(0) { $0 + $1.height } + CGFloat(max(0, rows.count - 1)) * verticalSpacing
        return CGSize(width: proposal.width ?? 0, height: totalHeight)
    }
    
    /// Positions the subviews within the given bounds.
    ///
    /// This method performs the WrappingHStack layout algorithm:
    /// 1. Computes which children belong on which rows based on available width
    /// 2. Places children row by row, left to right
    /// 3. Advances to the next row with vertical spacing when a row is complete
    ///
    /// Each child is positioned at its ideal size - no stretching or compression occurs.
    ///
    /// This method is called by SwiftUI's layout system during the layout pass.
    /// You don't call this directly - SwiftUI manages the layout cycle automatically.
    ///
    /// - Parameters:
    ///   - bounds: The rectangular region in which to place subviews.
    ///   - proposal: The size proposed by the parent (used for child sizing).
    ///   - subviews: The child views to position.
    ///   - cache: Storage for computed layout values (unused by WrappingHStack).
    ///
    /// ```swift
    /// let layout = WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8)
    /// layout.placeSubviews(
    ///     in: CGRect(x: 0, y: 0, width: 300, height: 200),
    ///     proposal: ProposedViewSize(width: 300, height: 200),
    ///     subviews: subviews,
    ///     cache: &cache
    /// )
    /// ```
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
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

