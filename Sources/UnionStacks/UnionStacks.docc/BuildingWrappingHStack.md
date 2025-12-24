
```swift
dependencies: [
    .package(url: "https://github.com/unionst/union-stacks", from: "1.0.0")
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

## WrappingHStack vs Alternatives

Choosing the right SwiftUI layout:

| Layout | Wrapping | Best For | Performance |
|--------|----------|----------|-------------|
| ``WrappingHStack`` | ✅ Automatic | Variable-width tags, chips, keywords | Good (< 100 items) |
| `HStack` | ❌ Single row | Navigation bars, toolbars, fixed content | Excellent |
| `LazyVGrid` | ✅ Column-based | Large lists (100+), photo grids, uniform items | Excellent (lazy) |
| FlowLayout (iOS 16+) | ✅ Native | Similar to WrappingHStack when available | Excellent |

## Pro Tips

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
