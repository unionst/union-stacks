# Advanced Wrapping Stack Patterns

Master advanced techniques for building dynamic, interactive layouts with WrappingHStack.

@Metadata {
    @PageKind(article)
    @PageColor(purple)
    @CallToAction(purpose: link, url: "https://github.com/unionst/union-stacks")
    @Available(iOS, introduced: "17.0")
    @Available(macOS, introduced: "14.0")
    @Available(tvOS, introduced: "17.0")
    @Available(watchOS, introduced: "10.0")
}

## Overview

Once you've mastered the basics of ``WrappingHStack``, you can unlock powerful patterns for building sophisticated, interactive layouts. This guide covers advanced techniques, real-world scenarios, and production-ready patterns used in modern iOS applications.

## State Management Patterns

### Interactive Tags with Selection

Build a tag selector where users can toggle multiple selections:

```swift
import SwiftUI
import UnionStacks

struct TagSelectorView: View {
    let availableTags = ["Swift", "Kotlin", "Python", "JavaScript", "Rust", "Go", "Ruby", "TypeScript"]
    @State private var selectedTags: Set<String> = ["Swift", "Python"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Technologies")
                .font(.headline)
            
            WrappingHStack(horizontalSpacing: 10, verticalSpacing: 10) {
                ForEach(availableTags, id: \.self) { tag in
                    TagButton(
                        text: tag,
                        isSelected: selectedTags.contains(tag)
                    ) {
                        toggleTag(tag)
                    }
                }
            }
            
            if !selectedTags.isEmpty {
                Text("Selected: \(Array(selectedTags).joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
}

struct TagButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.small)
                }
                Text(text)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.15))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TagSelectorView()
}
```

### Dynamic Tag Addition

Create an interface where users can add custom tags:

```swift
struct DynamicTagInputView: View {
    @State private var tags: [String] = ["SwiftUI", "iOS"]
    @State private var inputText = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Tags")
                .font(.headline)
            
            WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    TagWithRemove(text: tag) {
                        removeTag(tag)
                    }
                }
                
                TagInput(
                    text: $inputText,
                    isFocused: $isInputFocused,
                    onSubmit: addTag
                )
            }
        }
        .padding()
    }
    
    func addTag() {
        let trimmed = inputText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tags.contains(trimmed) else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            tags.append(trimmed)
            inputText = ""
        }
    }
    
    func removeTag(_ tag: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            tags.removeAll { $0 == tag }
        }
    }
}

struct TagWithRemove: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .imageScale(.small)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.2))
        .clipShape(Capsule())
        .transition(.scale.combined(with: .opacity))
    }
}

struct TagInput: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            TextField("New tag", text: $text)
                .textFieldStyle(.plain)
                .frame(minWidth: 60, maxWidth: 120)
                .focused($isFocused)
                .onSubmit(onSubmit)
            
            if isFocused && !text.isEmpty {
                Button(action: onSubmit) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .clipShape(Capsule())
    }
}

#Preview {
    DynamicTagInputView()
}
```

## Animation Patterns

### Smooth Entry and Exit

Animate tags as they're added and removed:

```swift
struct AnimatedTagListView: View {
    @State private var tags = ["Swift", "iOS", "SwiftUI"]
    
    var body: some View {
        VStack(spacing: 20) {
            WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.purple.opacity(0.2))
                        .clipShape(Capsule())
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale(scale: 0.8).combined(with: .opacity)
                        ))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.65), value: tags)
            
            HStack(spacing: 12) {
                Button("Add Random") {
                    let newTags = ["Kotlin", "Python", "Rust", "Go", "Ruby"]
                    if let random = newTags.randomElement() {
                        tags.append(random)
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Remove Last") {
                    if !tags.isEmpty {
                        tags.removeLast()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(tags.isEmpty)
            }
        }
        .padding()
    }
}

#Preview {
    AnimatedTagListView()
}
```

### Pulse Effect on Selection

Add visual feedback when tags are selected:

```swift
struct PulsingTagView: View {
    let tags = ["Design", "Development", "Marketing", "Sales"]
    @State private var selectedTag: String?
    @State private var pulseScale = 1.0
    
    var body: some View {
        WrappingHStack(horizontalSpacing: 12, verticalSpacing: 12) {
            ForEach(tags, id: \.self) { tag in
                Button {
                    selectTag(tag)
                } label: {
                    Text(tag)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedTag == tag ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundStyle(selectedTag == tag ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .scaleEffect(selectedTag == tag ? pulseScale : 1.0)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
    
    func selectTag(_ tag: String) {
        selectedTag = tag
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
            pulseScale = 1.1
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4).delay(0.1)) {
            pulseScale = 1.0
        }
    }
}

#Preview {
    PulsingTagView()
}
```

## Data Source Integration

### Async Loading from API

Load tags dynamically from a network source:

```swift
struct AsyncTagsView: View {
    @State private var tags: [Tag] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    struct Tag: Identifiable, Hashable {
        let id: String
        let name: String
        let count: Int
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading tags...")
            } else if let error = error {
                ErrorView(error: error) {
                    Task { await loadTags() }
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trending Topics")
                            .font(.title2.bold())
                        
                        WrappingHStack(horizontalSpacing: 10, verticalSpacing: 10) {
                            ForEach(tags) { tag in
                                TagWithCount(tag: tag)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await loadTags()
        }
    }
    
    func loadTags() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await Task.sleep(for: .seconds(1))
            tags = [
                Tag(id: "1", name: "SwiftUI", count: 1234),
                Tag(id: "2", name: "iOS Development", count: 982),
                Tag(id: "3", name: "Mobile", count: 756),
                Tag(id: "4", name: "App Design", count: 543),
                Tag(id: "5", name: "Xcode", count: 421)
            ]
        } catch {
            self.error = error
        }
    }
}

struct TagWithCount: View {
    let tag: AsyncTagsView.Tag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(tag.name)
                .font(.subheadline.weight(.medium))
            Text("\(tag.count) posts")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.purple.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ErrorView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        ContentUnavailableView(
            "Loading Failed",
            systemImage: "exclamationmark.triangle",
            description: Text(error.localizedDescription)
        )
        Button("Retry", action: retry)
            .buttonStyle(.borderedProminent)
    }
}

#Preview {
    AsyncTagsView()
}
```

### Search and Filter

Implement real-time filtering of tags:

```swift
struct SearchableTagsView: View {
    let allTags = ["SwiftUI", "UIKit", "Combine", "CoreData", "CloudKit", "WidgetKit", "AppKit", "WatchKit"]
    @State private var searchText = ""
    
    var filteredTags: [String] {
        if searchText.isEmpty {
            return allTags
        }
        return allTags.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                WrappingHStack(horizontalSpacing: 10, verticalSpacing: 10) {
                    ForEach(filteredTags, id: \.self) { tag in
                        TagChip(text: tag, searchText: searchText)
                    }
                }
                .padding()
                .animation(.spring(response: 0.3), value: filteredTags)
                
                if filteredTags.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .navigationTitle("Framework Tags")
            .searchable(text: $searchText, prompt: "Search frameworks")
        }
    }
}

struct TagChip: View {
    let text: String
    let searchText: String
    
    var body: some View {
        Text(highlightedText)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.2))
            .clipShape(Capsule())
    }
    
    var highlightedText: AttributedString {
        var attributed = AttributedString(text)
        if let range = attributed.range(of: searchText, options: .caseInsensitive) {
            attributed[range].foregroundColor = .blue
            attributed[range].font = .body.bold()
        }
        return attributed
    }
}

#Preview {
    SearchableTagsView()
}
```

## Accessibility Patterns

### VoiceOver Support

Ensure your wrapping layouts are accessible:

```swift
struct AccessibleTagsView: View {
    let tags = ["Important", "Urgent", "Review", "Done"]
    @State private var selectedTags: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Task Tags")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            WrappingHStack(horizontalSpacing: 10, verticalSpacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    AccessibleTagButton(
                        text: tag,
                        isSelected: selectedTags.contains(tag)
                    ) {
                        toggleSelection(tag)
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Tag selector")
            .accessibilityHint("Double tap on tags to select or deselect them")
        }
        .padding()
    }
    
    func toggleSelection(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
}

struct AccessibleTagButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(text)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityHint(isSelected ? "Selected. Double tap to deselect" : "Double tap to select")
    }
}

#Preview {
    AccessibleTagsView()
}
```

### Dynamic Type Support

Adapt to user's preferred text size:

```swift
struct DynamicTypeTagsView: View {
    let tags = ["Swift", "Kotlin", "Python", "JavaScript"]
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var spacing: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small, .medium:
            return 8
        case .large, .xLarge, .xxLarge:
            return 10
        default:
            return 12
        }
    }
    
    var body: some View {
        WrappingHStack(horizontalSpacing: spacing, verticalSpacing: spacing) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
}

#Preview {
    DynamicTypeTagsView()
}
```

## Performance Optimization

### Lazy Loading with Pagination

Handle large tag collections efficiently:

```swift
struct PaginatedTagsView: View {
    @State private var displayedTags: [String] = []
    @State private var currentPage = 0
    let pageSize = 20
    
    let allTags = Array(1...200).map { "Tag \($0)" }
    
    var hasMorePages: Bool {
        displayedTags.count < allTags.count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
                    ForEach(displayedTags, id: \.self) { tag in
                        Text(tag)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                
                if hasMorePages {
                    Button("Load More") {
                        loadNextPage()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .onAppear {
            loadNextPage()
        }
    }
    
    func loadNextPage() {
        let start = currentPage * pageSize
        let end = min(start + pageSize, allTags.count)
        let newTags = Array(allTags[start..<end])
        
        withAnimation {
            displayedTags.append(contentsOf: newTags)
            currentPage += 1
        }
    }
}

#Preview {
    PaginatedTagsView()
}
```

## Best Practices Summary

### Do's ✅

- Use stable, unique identifiers in `ForEach`
- Apply animations at the container level, not per item
- Provide accessibility labels and hints
- Support Dynamic Type with adaptive spacing
- Use async/await for network requests
- Implement proper error handling and loading states

### Don'ts ❌

- Don't use indices as identifiers if array can be reordered
- Don't put expensive computations in view body
- Don't forget accessibility for interactive elements
- Don't hardcode spacing - adapt to Dynamic Type
- Don't block the main thread with synchronous operations
- Don't skip empty state handling

## See Also

- ``WrappingHStack``
- <doc:BuildingWrappingHStack>
- <doc:UnionStacks>

