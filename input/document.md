# Sample Document

## Introduction

This is a sample Markdown document that can be used to test the Markdown to PDF conversion workflow. This file should be placed in the `input` directory.

## Features

- **Bold text** and *italic text* for emphasis
- Lists for organizing information
- Code blocks for technical content
- Links to external resources

## Code Example

```python
def hello_world():
    print("Hello, world!")
    return True

# Call the function
hello_world()
```

## How It Works

The conversion process transforms this Markdown file into XML, applies an XSLT transformation, and then generates a PDF document.

1. First, Pandoc converts Markdown to HTML
2. Then, the HTML is converted to DocBook XML
3. The XSLT template is applied to the XML
4. Finally, either Apache FOP or WeasyPrint creates the PDF

## External Resources

For more information about the tools used in this process, visit:

- [Pandoc](https://pandoc.org/)
- [Saxon XSLT](https://www.saxonica.com/)
- [Apache FOP](https://xmlgraphics.apache.org/fop/)

## Conclusion

This example demonstrates how to structure a Markdown document for optimal conversion to PDF using the XSLT workflow.
