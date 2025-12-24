# Contributing to UnionStacks

Thank you for your interest in contributing to UnionStacks! This document provides guidelines and instructions for contributing.

## Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/unionst/union-stacks.git
   cd union-stacks
   ```

2. **Open in Xcode**
   ```bash
   open Package.swift
   ```

3. **Build and test**
   - Product → Build (⌘B)
   - Product → Test (⌘U)

## Development Environment

- **macOS**: 14.0 or later
- **Xcode**: 16.0 or later
- **Swift**: 6.0 or later

## Code Style

### Swift Style Guidelines

- Follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- Use 4 spaces for indentation
- Maximum line length: 120 characters
- Use trailing commas in multi-line arrays and function parameters
- Always use `self.` when accessing properties in closures

### SwiftUI Conventions

- Use modern SwiftUI APIs (iOS 16+)
- Prefer async/await over completion handlers
- Use `@Observable` instead of `ObservableObject`
- Use `#Preview` instead of `PreviewProvider`
- Use multiple trailing closure syntax

### Documentation

All public APIs must be documented with:
- Summary line describing what it is
- Detailed discussion of when/why/how to use it
- At least one clear example
- Parameter documentation
- Returns documentation (if applicable)

Example:

```swift
/// A layout that arranges children horizontally and wraps to new rows.
///
/// Use `WrappingHStack` when you need content to flow like text, automatically
/// wrapping to multiple rows when space runs out. Perfect for tags, chips, and
/// dynamic collections.
///
/// ```swift
/// WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
///     ForEach(tags, id: \.self) { tag in
///         Text(tag)
///     }
/// }
/// ```
///
/// - Parameters:
///   - horizontalSpacing: Space between items on the same row
///   - verticalSpacing: Space between rows
public struct WrappingHStack: Layout { }
```

## Making Changes

### Branch Naming

- **Features**: `feature/description`
- **Bug fixes**: `fix/description`
- **Documentation**: `docs/description`
- **Performance**: `perf/description`

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add support for custom alignment in WrappingHStack
fix: correct spacing calculation when items wrap
docs: add example for dynamic tag input
perf: optimize row computation algorithm
```

### Pull Request Process

1. Create a feature branch from `main`
2. Make your changes with clear, atomic commits
3. Add or update tests as needed
4. Update documentation if you changed APIs
5. Ensure all tests pass
6. Submit a pull request with:
   - Clear title and description
   - Reference to any related issues
   - Screenshots/videos for UI changes
   - Breaking changes clearly marked

## What to Contribute

### High Priority

- Bug fixes for existing layouts
- Performance improvements
- Additional real-world examples
- Improved documentation
- Accessibility enhancements

### Feature Ideas

Before implementing new features, please:
1. Open an issue to discuss the feature
2. Wait for maintainer feedback
3. Get approval before starting work

This ensures your time isn't wasted on features that won't be merged.

## Testing

### Running Tests

```bash
swift test
```

### Manual Testing

Use the Previews in Xcode to test your changes:

```swift
#Preview {
    WrappingHStack {
        ForEach(0..<10) { i in
            Text("Item \(i)")
        }
    }
}
```

### Performance Testing

For performance-related changes, include benchmark results:

```swift
func measureLayoutPerformance() {
    measure {
        // Layout code
    }
}
```

## Code Review

All contributions go through code review. Expect:
- Constructive feedback on code quality
- Requests for tests or documentation
- Discussion of alternative approaches
- Questions about edge cases

Don't take feedback personally - we're all working to improve the library!

## Questions?

- **General questions**: Open a [Discussion](https://github.com/unionst/union-stacks/discussions)
- **Bug reports**: Open an [Issue](https://github.com/unionst/union-stacks/issues)
- **Feature requests**: Open an [Issue](https://github.com/unionst/union-stacks/issues) with "Feature Request" label

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors are recognized in:
- Release notes
- Repository contributors list
- Special shoutouts for significant contributions

Thank you for making UnionStacks better! 🎉



