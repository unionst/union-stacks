
# Building with WrappingHStack

Create flowing, responsive layouts that adapt to any screen size.

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @CallToAction(purpose: link, url: "https://github.com/unionst/union-stacks")
    @Available(iOS, introduced: "17.0")
    @Available(macOS, introduced: "14.0")
    @Available(tvOS, introduced: "17.0")
    @Available(watchOS, introduced: "10.0")
}

## Overview

``WrappingHStack`` is a SwiftUI layout that arranges views horizontally and automatically wraps them to new rows when space runs out - just like text flowing in a paragraph. Perfect for tags, chips, filters, and any dynamic content that needs to adapt to different screen widths.

## Installation

Add UnionStacks to your project via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/unionst/union-stacks", from: "1.2.0")
]
```

Then import in your SwiftUI views:

```swift
import SwiftUI
import UnionStacks
```

**Requirements:** iOS 17.0+, macOS 14.0+, tvOS 17.0+, watchOS 10.0+

## Basic Example: Tag Collection

![Example of WrappingHStack showing tags that wrap across multiple rows](wrapping-hstack-example.png)

Create a wrapping tag list in just a few lines:

```swift
struct TagsView: View {
    let tags = ["SwiftUI", "iOS", "Development", "Layout", "Tags"]
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
}
```

**Result:** Tags flow left to right and automatically wrap to new rows when they reach the edge - exactly like CSS `display: flex; flex-wrap: wrap`.

## Common Use Cases

### Interactive Filter Chips (Multi-Select UI)

```swift
struct FilterView: View {
    let filters = ["All", "Active", "Completed"]
    @State private var selected = "All"
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 12, verticalSpacing: 12) {
            ForEach(filters, id: \.self) { filter in
                Button(filter) {
                    selected = filter
                }
                .buttonStyle(.bordered)
                .tint(selected == filter ? .blue : .gray)
            }
        }
    }
}
```

### Editable Tags (Removable Chips)

```swift
struct EditableTagsView: View {
    @State private var tags = ["Swift", "iOS"]
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(tags, id: \.self) { tag in
                HStack(spacing: 4) {
                    Text(tag)
                    Button {
                        tags.removeAll { $0 == tag }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.2))
                .clipShape(Capsule())
            }
        }
    }
}
```

### Dynamic Content from API (Hashtags/Categories)

```swift
struct TrendingView: View {
    @State private var hashtags: [String] = []
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 10, verticalSpacing: 10) {
            ForEach(hashtags, id: \.self) { tag in
                Button("#\(tag)") {
                    search(tag)
                }
                .buttonStyle(.bordered)
            }
        }
        .task {
            hashtags = await loadTrending()
        }
    }
    
    func search(_ tag: String) {
        print("Search: \(tag)")
    }
    
    func loadTrending() async -> [String] {
        ["swift", "ios", "mobile"]
    }
}
```

## Customizing Spacing

Control horizontal spacing (between items) and vertical spacing (between rows):

- **Compact** (4-6 points): Dense tag clouds, limited space
- **Standard** (8-12 points): Most use cases - default is 8
- **Spacious** (16-20 points): Prominent content, better touch targets

```swift
WrappingHStack(horizontalSpacing: 12, verticalSpacing: 12) {
}
```

## Advanced Features

### Forcing Line Breaks with `.breakAfter()`

Use the `.breakAfter()` modifier to guarantee a new row starts after a specific element, regardless of available space. Perfect for creating visual sections or grouping related items.

```swift
struct SectionedTagsView: View {
    var body: some View {
        WrappingHStack(horizontalSpacing: 8, verticalSpacing: 12) {
            Text("Priority")
                .font(.headline)
                .breakAfter()
            
            Text("High")
                .tagStyle(.red)
            Text("Medium")
                .tagStyle(.orange)
            Text("Low")
                .tagStyle(.yellow)
                .breakAfter()
            
            Text("Status")
                .font(.headline)
                .breakAfter()
            
            Text("Active")
                .tagStyle(.green)
            Text("Pending")
                .tagStyle(.blue)
            Text("Completed")
                .tagStyle(.gray)
        }
        .padding()
    }
}

extension View {
    func tagStyle(_ color: Color) -> some View {
        self.padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .clipShape(Capsule())
    }
}
```

**Result:** Each section header forces a new line, creating clear visual grouping even if there's available horizontal space.

**Conditional line breaks:**

```swift
WrappingHStack {
    ForEach(items) { item in
        ItemView(item)
            .breakAfter(when: item.isLastInGroup)
    }
}

extension View {
    func breakAfter(when condition: Bool) -> some View {
        if condition {
            self.breakAfter()
        } else {
            self
        }
    }
}
```

### Limiting Rows with `maxRows`

Limit the number of displayed rows, similar to `.lineLimit()` for Text. Perfect for preview displays with "Show More" functionality.

```swift
struct TagPreviewView: View {
    let tags: [String]
    @State private var showAll = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            WrappingHStack(
                horizontalSpacing: 8,
                verticalSpacing: 8,
                maxRows: showAll ? nil : 2
            ) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            
            if !showAll && tags.count > 6 {
                Button("Show \(tags.count - 6) more") {
                    withAnimation {
                        showAll = true
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.blue)
            }
        }
        .padding()
    }
}

#Preview {
    TagPreviewView(tags: Array(1...20).map { "Tag \($0)" })
}
```

**Compact lists with consistent height:**

```swift
struct CompactFilterView: View {
    let filters = ["All", "Active", "Pending", "Completed", "Archived", "Draft", "Published"]
    
    var body: some View {
        WrappingHStack(maxRows: 1) {
            ForEach(filters, id: \.self) { filter in
                Button(filter) {
                    applyFilter(filter)
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(height: 44)
    }
    
    func applyFilter(_ filter: String) {
        print("Filter: \(filter)")
    }
}
```

**Combining maxRows with breakAfter:**

```swift
WrappingHStack(maxRows: 3) {
    Text("Featured")
        .font(.headline)
        .breakAfter()
    
    ForEach(featuredItems) { item in
        ItemView(item)
    }
    
    Text("Others")
        .font(.headline)
        .breakAfter()
    
    ForEach(otherItems) { item in
        ItemView(item)
    }
}
```

Both features work together seamlessly - forced breaks are respected within the row limit.

## WrappingHStack vs Alternatives

Choosing the right SwiftUI layout:

| Layout | Wrapping | Best For | Performance |
|--------|----------|----------|-------------|
| ``WrappingHStack`` | ✅ Automatic | Variable-width tags, chips, keywords | Good (< 100 items) |
| `HStack` | ❌ Single row | Navigation bars, toolbars, fixed content | Excellent |
| `LazyVGrid` | ✅ Column-based | Large lists (100+), photo grids, uniform items | Excellent (lazy) |
| FlowLayout (iOS 16+) | ✅ Native | Similar to WrappingHStack when available | Excellent |

## Pro Tips

### Force Line Breaks
Use `.breakAfter()` to force a new row after specific elements:
```swift
WrappingHStack {
    Text("Section Header").breakAfter()
    Text("Item 1")
    Text("Item 2")
}
```

### Limit Rows
Use `maxRows` to truncate wrapped content (like `.lineLimit()` for Text):
```swift
WrappingHStack(maxRows: 2) {
    ForEach(tags, id: \.self) { tag in
        Text(tag)
    }
}
```

### Smooth Animations
Add spring animations when tags change:
```swift
WrappingHStack { }
    .animation(.spring(), value: tags)
```

### Empty State Handling
Always handle empty collections:
```swift
if tags.isEmpty {
    ContentUnavailableView("No tags", systemImage: "tag.slash")
} else {
    WrappingHStack { }
}
```

### Ensure Proper Wrapping
Constrain the width for responsive wrapping:
```swift
WrappingHStack { }
    .frame(maxWidth: .infinity)
    .padding()
```

## Keywords

SwiftUI wrapping stack, flow layout, auto-wrap, horizontal stack wrap, tag layout, chip layout, CSS flexbox wrap SwiftUI, UICollectionView flow layout SwiftUI, wrapped horizontal stack, dynamic tag collection, filter chips SwiftUI, custom layout protocol, iOS 17 layout

## See Also

- ``WrappingHStack``
- ``CStack``
- <doc:AdvancedWrappingPatterns>
