# UnionStacks

> **Production-ready SwiftUI layout components for wrapping, flowing, and centering content**

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![iOS 17+](https://img.shields.io/badge/iOS-17+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Layout-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

UnionStacks provides powerful, flexible layout containers that solve common SwiftUI layout challenges. Whether you need tags that wrap like text or perfectly centered navigation bars, UnionStacks makes it effortless.

## 🎯 Features

- **📦 WrappingHStack** - Auto-wrapping horizontal layout for tags, chips, and dynamic collections
- **⚖️ CStack** - Centered layout with balanced distribution for navigation bars
- **🚀 Production Ready** - Battle-tested in real applications
- **⚡️ Performant** - Efficient layout algorithms optimized for typical UI scenarios
- **📱 Responsive** - Adapts automatically to different screen sizes
- **🎨 Customizable** - Flexible spacing and configuration options

## 📸 Quick Examples

### WrappingHStack: Flow Layout for Tags

```swift
import UnionStacks

struct TagsView: View {
    let tags = ["SwiftUI", "iOS", "Layout", "Custom Views", "Flow"]
    
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

**Perfect for:**
- Tag collections (hashtags, categories, keywords)
- Filter chips and buttons
- Dynamic content from APIs
- Any variable-width items that should wrap naturally

### CStack: Centered Navigation Bars

```swift
import UnionStacks

struct NavBar: View {
    var body: some View {
        CStack(spacing: 16) {
            Button("Back") { }
            Text("Settings").font(.headline)
            Button("Save") { }
        }
        .frame(height: 44)
        .padding(.horizontal)
    }
}
```

**Perfect for:**
- Navigation bars with guaranteed center alignment
- Toolbars with symmetric left/right actions
- Any layout where the center item must be perfectly centered

## 📦 Installation

### Swift Package Manager

Add UnionStacks to your project using Xcode:

1. File → Add Package Dependencies
2. Enter: `https://github.com/unionst/union-stacks`
3. Select version and add to your target

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/unionst/union-stacks", from: "1.0.0")
]
```

## 🚀 Quick Start

### 1. Import UnionStacks

```swift
import SwiftUI
import UnionStacks
```

### 2. Use WrappingHStack for flowing content

```swift
struct ContentView: View {
    let items = ["Swift", "Kotlin", "Python", "JavaScript", "TypeScript", "Rust"]
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 12, verticalSpacing: 12) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
```

### 3. Use CStack for centered layouts

```swift
struct CustomNavBar: View {
    var body: some View {
        CStack {
            Button("Cancel") { dismiss() }
            Text("Title")
            Button("Done") { save() }
        }
    }
}
```

## 📖 Documentation

**Comprehensive guides and API documentation:**

- [Building a Wrapping HStack in SwiftUI](Sources/UnionStacks/UnionStacks.docc/BuildingWrappingHStack.md) - Complete tutorial
- [WrappingHStack API Reference](https://unionst.github.io/union-stacks/documentation/unionstacks/wrappinghstack)
- [CStack API Reference](https://unionst.github.io/union-stacks/documentation/unionstacks/cstack)

## 🎨 Real-World Examples

### Interactive Filter Chips

```swift
struct FilterView: View {
    let filters = ["All", "Active", "Completed", "Archived"]
    @State private var selected = "All"
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 12) {
            ForEach(filters, id: \.self) { filter in
                Button {
                    selected = filter
                } label: {
                    Text(filter)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selected == filter ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundStyle(selected == filter ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
```

### Dynamic Hashtags

```swift
struct HashtagView: View {
    @State private var hashtags = ["#swift", "#ios", "#dev"]
    
    var body: some View {
        ScrollView {
            WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
                ForEach(hashtags, id: \.self) { tag in
                    Button {
                        searchHashtag(tag)
                    } label: {
                        Text(tag)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.purple.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    func searchHashtag(_ tag: String) {
        print("Searching: \(tag)")
    }
}
```

### Editable Tags with Remove Buttons

```swift
struct EditableTagsView: View {
    @State private var tags = ["SwiftUI", "iOS", "Development"]
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(tags, id: \.self) { tag in
                HStack(spacing: 4) {
                    Text(tag)
                    Button {
                        tags.removeAll { $0 == tag }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.2))
                .clipShape(Capsule())
            }
        }
        .animation(.spring(), value: tags)
    }
}
```

## ⚡️ Performance

### When to use WrappingHStack

✅ **Excellent performance for:**
- Small to medium collections (1-100 items)
- Variable-width content (tags, labels)
- Dynamic content that changes infrequently

⚠️ **Consider alternatives for:**
- Very large collections (100+ items) → Use `LazyVGrid` instead
- Uniform grid layouts → Use `LazyVGrid` with fixed columns
- Infinite scrolling → Use `List` or `LazyVStack`

### Optimization Tips

```swift
WrappingHStack {
    ForEach(items, id: \.id) { item in
        ItemView(item: item)
            .drawingGroup()
    }
}
```

Use stable identifiers and consider `.drawingGroup()` for complex child views.

## 🆚 Comparison

### WrappingHStack vs HStack vs LazyVGrid

| Feature | WrappingHStack | HStack | LazyVGrid |
|---------|---------------|---------|-----------|
| **Multiple rows** | ✅ Automatic | ❌ Single row | ✅ Grid-based |
| **Wrapping** | ✅ Natural flow | ❌ Truncates | ✅ Column-based |
| **Item sizing** | Ideal size | May compress | Grid cells |
| **Performance** | Good (<100 items) | Excellent | Excellent (lazy) |
| **Best for** | Tags, chips | Fixed layouts | Photos, grids |
| **Alignment** | Left-aligned flow | Flexible | Vertical columns |

### When to use each

**Use WrappingHStack when:**
- Items have different widths
- You want natural text-like flow
- Collection is small to medium
- Content feels like "tags" or "chips"

**Use HStack when:**
- Content always fits in one row
- You need flexible spacing
- Building navigation bars or toolbars

**Use LazyVGrid when:**
- Items should align in columns
- You have 100+ items
- Items are uniform in size
- You need lazy loading

## 🛠 Requirements

- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+
- Swift 6.0+
- Xcode 16.0+

## 📄 License

UnionStacks is available under the MIT license. See [LICENSE](LICENSE) for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 🔗 Related Projects

- [union-ui](https://github.com/unionst/union-ui) - Comprehensive SwiftUI component library
- [union-buttons](https://github.com/unionst/union-buttons) - Beautiful button components
- [union-haptics](https://github.com/unionst/union-haptics) - Haptic feedback utilities

## 📱 Apps Using UnionStacks

Is your app using UnionStacks? Open an issue to be featured here!

## 🌟 Credits

Built with ❤️ by [Ben Sage](https://github.com/bensage)

## 🔍 Keywords

SwiftUI, Layout, Custom Layout, Flow Layout, Wrapping Stack, Wrapped HStack, Tag Layout, Chip Layout, iOS Development, Swift Package, SwiftUI Components, Responsive Layout, Dynamic Layout, Auto-wrapping, Horizontal Stack, Centered Layout, Navigation Bar Layout, SwiftUI Layout Protocol, iOS 17, Modern SwiftUI

---

**⭐️ If you find UnionStacks useful, please star the repository!**

[View Documentation](https://unionst.github.io/union-stacks) • [Report Bug](https://github.com/unionst/union-stacks/issues) • [Request Feature](https://github.com/unionst/union-stacks/issues)
