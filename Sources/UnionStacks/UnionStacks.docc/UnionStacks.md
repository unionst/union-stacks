# ``UnionStacks``

Custom SwiftUI layout containers for advanced horizontal arrangements.

## Overview

UnionStacks provides two specialized `Layout` implementations that solve common UI patterns not covered by SwiftUI's built-in stack views:

- ``CStack`` - Centers a middle child and distributes remaining children equally on left and right sides
- ``WrappingHStack`` - Flows children horizontally and wraps to new rows when space runs out

These layouts integrate seamlessly with SwiftUI's layout system and work with any SwiftUI views as children.

## Quick Start

### CStack - Centered Layout

Use ``CStack`` when you need a guaranteed centered element with balanced sides, like navigation bars or symmetric toolbars:

```swift
struct NavigationBarView: View {
    var body: some View {
        CStack(spacing: 10) {
            Button("Cancel") { }
            Text("Title").font(.headline)
            Button("Save") { }
        }
        .frame(height: 44)
        .padding(.horizontal)
    }
}
```

The middle child (at index `count / 2`) is centered, while left and right children share their respective sides equally.

### WrappingHStack - Flow Layout

Use ``WrappingHStack`` when you have a variable number of items that should flow naturally and wrap to multiple rows:

```swift
struct TagListView: View {
    let tags = ["Swift", "SwiftUI", "iOS", "macOS", "Xcode"]
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
```

Children flow left-to-right and automatically wrap when they would exceed the available width.

## When to Use Each Layout

### CStack vs HStack

| Layout | Center Behavior | Distribution | Best For |
|--------|----------------|--------------|----------|
| ``CStack`` | Guaranteed center alignment for middle child | Left/right items share available space equally | Navigation bars, symmetric toolbars, action bars |
| `HStack` with `Spacer` | No guaranteed center (depends on child sizes) | Flexible spacing | Most horizontal layouts, asymmetric content |

**Use CStack when:**
- You need a perfectly centered title or logo
- Left and right sides should have equal visual weight
- You're building navigation bar-style layouts

**Use HStack when:**
- Flexible spacing is acceptable
- Content is naturally asymmetric
- You don't need guaranteed centering

### WrappingHStack vs HStack vs LazyVGrid

| Layout | Wrapping | Sizing | Best For |
|--------|----------|--------|----------|
| ``WrappingHStack`` | Automatic | Children take ideal size | Tags, chips, variable-length collections |
| `HStack` | None | May truncate or overflow | Fixed content, single-row layouts |
| `LazyVGrid` | Manual columns | Grid-based | Uniform items, photo grids, structured layouts |

**Use WrappingHStack when:**
- You have variable numbers of items
- Items have different widths
- You want natural flow like text wrapping
- Examples: tags, filter chips, keyword lists

**Use HStack when:**
- Content fits in a single row
- Wrapping would be undesirable

**Use LazyVGrid when:**
- You want explicit column control
- Items should align vertically across rows
- You need lazy loading for performance

## Common Patterns

### CStack: Three-Part Navigation Bar

```swift
struct CustomNavBar: View {
    var body: some View {
        CStack(spacing: 16) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Text("Settings")
                .font(.headline)
            
            Button("Done") {
                save()
            }
        }
        .frame(height: 44)
        .padding(.horizontal)
    }
}
```

### CStack: Symmetric Action Bar

```swift
struct ActionBar: View {
    var body: some View {
        CStack(spacing: 20) {
            Button("Delete") { }
            Text("3 items selected")
            Button("Share") { }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
```

### WrappingHStack: Hashtag Collection

```swift
struct HashtagView: View {
    let hashtags = ["#swift", "#ios", "#development", "#programming"]
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(hashtags, id: \.self) { tag in
                Text(tag)
                    .padding(8)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(4)
            }
        }
    }
}
```

### WrappingHStack: Filter Chips

```swift
struct FilterBar: View {
    let filters = ["All", "Active", "Completed", "Archived"]
    @State private var selected = "All"
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 12, verticalSpacing: 8) {
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

## Performance

Both layouts are efficient and suitable for typical UI scenarios:

- **CStack** performs simple arithmetic to position children - constant time complexity
- **WrappingHStack** measures each child once to compute rows - linear time complexity

For large collections (100+ items), consider whether you truly need custom layout or if `LazyVGrid` with lazy loading would be more appropriate.

## Tips and Best Practices

### CStack Tips

**Plan your child order:**
```swift
CStack {
    leftButton
    centerTitle
    rightButton
}
```

The center child is always at index `count / 2`. With 3 children, that's index 1 (the title).

**Use empty spacers for asymmetric layouts:**
```swift
CStack {
    Button("Back") { }
    Text("Title")
    Spacer().frame(width: 0)
}
```

### WrappingHStack Tips

**Control wrapping with padding:**

Children include their padding in size calculations, affecting when they wrap:

```swift
WrappingHStack {
    ForEach(tags, id: \.self) { tag in
        Text(tag)
            .padding(.horizontal, 12)
    }
}
```

**Ensure parent constrains width:**

WrappingHStack uses the proposed width for wrapping decisions. If the parent doesn't constrain width, wrapping won't work as expected:

```swift
WrappingHStack { }
    .frame(maxWidth: .infinity)
    .padding()
```

## Topics

### Layouts

- ``CStack``
- ``WrappingHStack``

