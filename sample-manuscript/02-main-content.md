# Main Content

This chapter demonstrates the various Markdown features supported by the
pipeline.

## Text Formatting

You can use **bold text**, *italic text*, and ~~strikethrough~~. You can also
write superscripts like x^2^ and subscripts like H~2~O.

## Lists

### Unordered Lists

- First item
- Second item
  - Nested item
  - Another nested item
- Third item

### Ordered Lists

1. First step
2. Second step
3. Third step

## Code Blocks

Inline code looks like `this`. Fenced code blocks support syntax highlighting:

```python
def hello(name: str) -> str:
    """Greet someone by name."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(hello("World"))
```

## Block Quotes

> This is a block quote. It can span multiple lines and is useful for
> highlighting important passages or attributing quotes to their sources.

## Tables

| Feature   | Supported | Notes                   |
|-----------|-----------|-------------------------|
| Bold      | Yes       | Use `**text**`          |
| Italic    | Yes       | Use `*text*`            |
| Tables    | Yes       | Pipe-delimited          |
| Footnotes | Yes       | Use `[^label]` syntax   |

## Footnotes

This sentence has a footnote[^1].

[^1]: This is the footnote content. It will appear at the bottom of the page
  in the PDF output.

## Links

Visit the [Pandoc documentation](https://pandoc.org/MANUAL.html) for a
complete reference of supported Markdown features.
