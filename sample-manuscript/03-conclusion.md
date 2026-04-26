# Conclusion

This sample manuscript has demonstrated the core features of the publishing
pipeline.

## Summary

The pipeline provides a straightforward workflow:

1. **Write** content in Markdown files
2. **Configure** the manuscript via `manuscript.yaml`
3. **Build** the PDF with a single `make` command

## Next Steps

To create your own manuscript:

1. Create a new directory at the top level of the project
2. Add a `manuscript.yaml` with your document metadata and file list
3. Copy the per-manuscript `Makefile` from this sample
4. Write your content in Markdown files
5. Run `make` to build your PDF

The output PDF will be generated in the `build/` subdirectory of your
manuscript folder.
