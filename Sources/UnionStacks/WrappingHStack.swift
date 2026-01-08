//
//  WrappingHStack.swift
//  UnionStacks
//
//  Created by Ben Sage on 12/22/24.
//

import SwiftUI

private struct BreakAfterKey: LayoutValueKey {
    static let defaultValue: Bool = false
}

extension View {
    /// Forces a line break after this view when used inside a `WrappingHStack`.
    ///
    /// Use `breakAfter()` to guarantee that the next view in a `WrappingHStack` starts on a new row,
    /// regardless of available horizontal space. This is useful for creating visual sections, grouping
    /// related items, or ensuring specific layout structure.
    ///
    /// The view with `breakAfter()` remains on its current row and takes up space normally. The next
    /// view in the layout sequence will begin a new row, even if there's room on the current row.
    ///
    /// ## Basic Usage
    ///
    /// ```swift
    /// WrappingHStack {
    ///     Text("First")
    ///     Text("Second")
    ///         .breakAfter()
    ///     Text("Third")
    /// }
    /// ```
    ///
    /// This creates two rows:
    /// - Row 1: "First", "Second"
    /// - Row 2: "Third"
    ///
    /// ## Common Patterns
    ///
    /// **Section headers:**
    ///
    /// ```swift
    /// WrappingHStack {
    ///     Text("Fruits")
    ///         .font(.headline)
    ///         .breakAfter()
    ///     
    ///     Text("Apple")
    ///     Text("Banana")
    ///     Text("Cherry")
    ///         .breakAfter()
    ///     
    ///     Text("Vegetables")
    ///         .font(.headline)
    ///         .breakAfter()
    ///     
    ///     Text("Carrot")
    ///     Text("Lettuce")
    /// }
    /// ```
    ///
    /// **Conditional breaks:**
    ///
    /// ```swift
    /// WrappingHStack {
    ///     ForEach(items) { item in
    ///         TagView(item)
    ///             .breakAfter(item.isLastInGroup)
    ///     }
    /// }
    /// ```
    ///
    /// **Responsive separators:**
    ///
    /// ```swift
    /// WrappingHStack {
    ///     Text("Action 1")
    ///     Text("Action 2")
    ///     Text("Action 3")
    ///         .breakAfter()
    ///     
    ///     Text("Help")
    ///     Text("Settings")
    /// }
    /// ```
    ///
    /// ## Important Notes
    ///
    /// - **No effect outside WrappingHStack:** This modifier only affects layout within `WrappingHStack`.
    ///   Other layouts ignore it.
    /// - **Works with natural wrapping:** If the view would naturally wrap (due to width constraints),
    ///   the break still occurs. This modifier doesn't prevent normal wrapping behavior.
    /// - **Applies after the view:** The break happens *after* this view, not before. The next view
    ///   starts the new row.
    /// - **Performance:** Has negligible performance impact - only a boolean check during layout.
    ///
    /// ## When to Use
    ///
    /// Use `breakAfter()` when you need:
    /// - Semantic sections within a flowing layout
    /// - Guaranteed visual separation between groups
    /// - Control over layout structure while maintaining responsive wrapping
    /// - Headers or labels that should be followed by wrapped content
    ///
    /// **Don't use** when:
    /// - You need consistent grid columns (use `LazyVGrid` instead)
    /// - Every item should break (just use `VStack`)
    /// - You want full manual control over every row (use explicit `HStack`s in a `VStack`)
    ///
    /// - Returns: A view that signals to `WrappingHStack` to start a new row after this view.
    public func breakAfter() -> some View {
        layoutValue(key: BreakAfterKey.self, value: true)
    }
    
    /// Conditionally forces a line break after this view when used inside a `WrappingHStack`.
    ///
    /// Use this variant when you need to conditionally apply line breaks based on data or state.
    /// Similar to SwiftUI modifiers like `.disabled(_:)`, this allows you to toggle the break
    /// behavior dynamically.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// WrappingHStack {
    ///     ForEach(items) { item in
    ///         ItemView(item)
    ///             .breakAfter(item.isLastInSection)
    ///     }
    /// }
    /// ```
    ///
    /// ```swift
    /// WrappingHStack {
    ///     ForEach(metadata) { item in
    ///         HStack {
    ///             Image(systemName: item.icon)
    ///             Text(item.text)
    ///         }
    ///         .breakAfter(item.icon == "clock.fill")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter condition: When `true`, forces a line break after this view. When `false`, allows normal wrapping behavior.
    /// - Returns: A view that conditionally signals to `WrappingHStack` to start a new row after this view.
    public func breakAfter(_ condition: Bool) -> some View {
        layoutValue(key: BreakAfterKey.self, value: condition)
    }
}

/// A layout that arranges children horizontally and wraps to new rows when space runs out, like text flowing in a paragraph.
///
/// `WrappingHStack` flows children left-to-right like an `HStack`, but automatically wraps
/// to the next row when adding another child would exceed the available width. Each row's
/// height is determined by its tallest child, creating a natural flow layout.
///
/// **Use WrappingHStack when you have:**
/// - Variable-length collections (tags, chips, categories)
/// - Content that needs to adapt to different screen widths
/// - Items that should flow naturally like text
/// - Dynamic content where item count isn't fixed
///
/// **Don't use WrappingHStack when you need:**
/// - Grid alignment with columns (use `LazyVGrid` instead)
/// - Large collections with 100+ items (use `LazyVGrid` for better performance)
/// - Single-row layouts (use `HStack` instead)
///
/// This creates a "flow layout" behavior similar to CSS flexbox with `flex-wrap: wrap` or
/// text flowing across lines in a paragraph. The layout is responsive and automatically
/// adapts to different screen sizes and orientations.
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
/// WrappingHStack uses a greedy wrapping algorithm:
/// 1. **Measures** each child's ideal size (width and height)
/// 2. **Places** children left-to-right on the current row
/// 3. **Wraps** to a new row when the next child would exceed available width
/// 4. **Heights** each row based on its tallest child
/// 5. **Spaces** items with horizontal spacing within rows and vertical spacing between rows
///
/// **Important:** Children are always placed at their ideal size. WrappingHStack doesn't stretch,
/// compress, or truncate children. If a single child is wider than the available width,
/// it's placed on its own row at full width (potentially overflowing).
///
/// The layout algorithm runs in O(n) time where n is the number of children, making it
/// efficient for typical UI scenarios with dozens of items.
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
/// **Forcing line breaks with `breakAfter()`:**
///
/// Use the `breakAfter()` modifier on any child to force a new line after that element,
/// regardless of available horizontal space:
///
/// ```swift
/// struct SectionedTags: View {
///     var body: some View {
///         WrappingHStack {
///             Text("Section 1")
///                 .font(.headline)
///                 .breakAfter()
///             
///             Text("Tag A")
///             Text("Tag B")
///             Text("Tag C")
///                 .breakAfter()
///             
///             Text("Section 2")
///                 .font(.headline)
///                 .breakAfter()
///             
///             Text("Tag D")
///             Text("Tag E")
///         }
///     }
/// }
/// ```
///
/// **Limiting rows with `maxRows`:**
///
/// Set `maxRows` to limit the number of displayed rows, similar to how `.lineLimit()` works for Text:
///
/// ```swift
/// struct CompactTagList: View {
///     let tags: [String]
///     @State private var showAll = false
///     
///     var body: some View {
///         VStack(alignment: .leading) {
///             WrappingHStack(maxRows: showAll ? nil : 2) {
///                 ForEach(tags, id: \.self) { tag in
///                     Text(tag)
///                         .padding(.horizontal, 12)
///                         .padding(.vertical, 6)
///                         .background(Color.blue.opacity(0.2))
///                         .cornerRadius(8)
///                 }
///             }
///             
///             if !showAll {
///                 Button("Show More") {
///                     showAll = true
///                 }
///             }
///         }
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
/// **When to use WrappingHStack vs alternatives:**
///
/// | Layout | Wrapping | Item Sizing | Alignment | Best For |
/// |--------|----------|-------------|-----------|----------|
/// | `WrappingHStack` | ✅ Automatic | Ideal size | Left-aligned rows | Tags, chips, keywords, dynamic content |
/// | `HStack` | ❌ Single row | May compress | Flexible | Fixed content, navigation bars, toolbars |
/// | `LazyVGrid` | ✅ Column-based | Grid cells | Vertical columns | Photo grids, uniform items, large collections |
/// | `FlowLayout` (Swift 6+) | ✅ Native | Ideal size | Configurable | When available, use Apple's native implementation |
///
/// **WrappingHStack shines when:**
/// - Items have different widths (like text tags)
/// - You want natural text-like flow
/// - Collection size is small to medium (1-100 items)
/// - Content is dynamically generated
///
/// **Choose LazyVGrid when:**
/// - Items should align vertically in columns
/// - You have 100+ items (lazy loading helps performance)
/// - Items are uniform in size
/// - You need explicit column control
///
/// **Performance note:** WrappingHStack computes layout for all children upfront.
/// For very large collections (100+ items), consider using `LazyVGrid` with adaptive
/// columns for better performance through lazy loading.
///
/// **Important:** WrappingHStack always takes the full proposed width from its parent.
/// Children wrap based on this width, not on their container's current size. If you need
/// responsive wrapping, ensure the parent properly constrains the width:
///
/// ```swift
/// WrappingHStack {
///     ForEach(tags, id: \.self) { tag in
///         Text(tag)
///     }
/// }
/// .frame(maxWidth: .infinity)
/// .padding()
/// ```
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
    
    /// The maximum number of rows to display before truncating.
    ///
    /// When set, only the first `maxRows` rows will be displayed. Any children that would
    /// wrap beyond this limit are hidden. Setting to `nil` (the default) allows unlimited rows.
    ///
    /// Rows that would overflow the available vertical bounds are also skipped, similar
    /// to how `lineLimit` works for Text.
    ///
    /// ```swift
    /// WrappingHStack(maxRows: 2) {
    ///     ForEach(manyTags, id: \.self) { tag in
    ///         Text(tag)
    ///     }
    /// }
    /// ```
    ///
    /// This is particularly useful for:
    /// - Showing a preview with "Show more" functionality
    /// - Limiting tag displays in compact views
    /// - Creating consistent-height containers
    public var maxRows: Int?
    
/// Creates a WrappingHStack with the specified spacing between items and rows.
///
/// **Both spacing values default to `8` points**, matching typical UI spacing conventions
/// and Apple's Human Interface Guidelines for comfortable touch targets and visual separation.
///
/// **Choosing spacing values:**
/// - **Compact layouts** (4-6 points): For dense tag collections or limited space
/// - **Standard layouts** (8-12 points): Most use cases, good balance of density and readability  
/// - **Spacious layouts** (16-20 points): For prominent content or accessibility needs
/// - **Zero spacing** (0 points): For tiled layouts or custom spacing in child views
///
/// The spacing is applied consistently between all adjacent items, creating a uniform
/// visual rhythm across rows. Row heights adjust automatically to accommodate the
/// tallest item in each row.
///
/// - Parameters:
///   - horizontalSpacing: The spacing between children within a row. Defaults to `8`.
///   - verticalSpacing: The spacing between rows. Defaults to `8`.
///   - maxRows: The maximum number of rows to display. Children beyond this limit are hidden. Defaults to `nil` (unlimited).
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
    ///
    /// ```swift
    /// struct PreviewTagsView: View {
    ///     let tags: [String]
    ///     
    ///     var body: some View {
    ///         WrappingHStack(maxRows: 2) {
    ///             ForEach(tags, id: \.self) { tag in
    ///                 Text(tag)
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    public init(horizontalSpacing: CGFloat = 8, verticalSpacing: CGFloat = 8, maxRows: Int? = nil) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.maxRows = maxRows
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
            let isLastAllowedRow = maxRows.map { rows.count == $0 - 1 } ?? false

            if requiredWidth <= maxWidth || currentRow.isEmpty {
                currentRow.append(index)
                currentWidth = requiredWidth
                currentHeight = max(currentHeight, size.height)

                // Don't break to new row if we're on the last allowed row
                if subview[BreakAfterKey.self] && !isLastAllowedRow {
                    rows.append((indices: currentRow, height: currentHeight))
                    currentRow = []
                    currentWidth = 0
                    currentHeight = 0
                }
            } else {
                // Would need to wrap - check if we're allowed to
                if isLastAllowedRow {
                    // On last row, just keep adding (will clip)
                    currentRow.append(index)
                    currentWidth = requiredWidth
                    currentHeight = max(currentHeight, size.height)
                } else {
                    // Start new row
                    rows.append((indices: currentRow, height: currentHeight))
                    currentRow = [index]
                    currentWidth = size.width
                    currentHeight = size.height

                    let nowOnLastRow = maxRows.map { rows.count == $0 - 1 } ?? false
                    if subview[BreakAfterKey.self] && !nowOnLastRow {
                        rows.append((indices: currentRow, height: currentHeight))
                        currentRow = []
                        currentWidth = 0
                        currentHeight = 0
                    }
                }
            }
        }

        if !currentRow.isEmpty {
            rows.append((indices: currentRow, height: currentHeight))
        }

        return rows
    }
}

