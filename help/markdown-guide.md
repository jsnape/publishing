# Markdown Quick Reference

This guide covers the Markdown features supported by the publishing pipeline
via Pandoc.

## Headings

```markdown
# Chapter Title       (becomes \chapter in book, \section in article)
## Section            (becomes \section in book, \subsection in article)
### Subsection
#### Sub-subsection
```

## Emphasis

```markdown
*italic*  or  _italic_
**bold**  or  __bold__
~~strikethrough~~
x^superscript^
H~subscript~O
```

## Lists

```markdown
- Unordered item
- Another item
  - Nested item

1. Ordered item
2. Another item
   a. Sub-item
```

## Links and Images

```markdown
[Link text](https://example.com)
[Link with title](https://example.com "Title")

![Alt text](images/figure.png)
![Caption text](images/figure.png "Optional title")
```

Images are automatically scaled to fit the page width.

## Code

````markdown
Inline: `code here`

Fenced block with syntax highlighting:
```python
def example():
    return True
```
````

## Block Quotes

```markdown
> This is a block quote.
> It can span multiple lines.
>
> And multiple paragraphs.
```

## Tables

```markdown
| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |
```

Alignment can be specified with colons:

```markdown
| Left     | Centre   | Right    |
|:---------|:--------:|---------:|
| text     | text     | text     |
```

## Footnotes

```markdown
This has a footnote[^1].

[^1]: Footnote content here.
```

## Horizontal Rules

```markdown
---
```

## Mathematics

```markdown
Inline: $E = mc^2$

Display:
$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$
```

## Cross-References

For cross-referencing between sections, use Pandoc's header identifiers:

```markdown
## My Section {#sec:my-section}

See [My Section](#sec:my-section) for details.
```

## Raw LaTeX

You can include raw LaTeX for features not available in Markdown:

```markdown
\newpage

\begin{center}
Custom centred content
\end{center}
```
