#!/bin/bash
set -e

# Define default paths
INPUT_DIR="/data/input"
OUTPUT_DIR="/data/output"
TEMPLATE_DIR="/data/templates"
TEMP_DIR="/data/temp"

# Check if arguments are provided
MARKDOWN_FILE="${1:-document.md}"
XSLT_FILE="${2:-template.xsl}"
OUTPUT_FILE="${3:-output.pdf}"

# Create temp directory if it doesn't exist
mkdir -p "$TEMP_DIR"

# Full paths
INPUT_PATH="$INPUT_DIR/$MARKDOWN_FILE"
XSLT_PATH="$TEMPLATE_DIR/$XSLT_FILE"
OUTPUT_PATH="$OUTPUT_DIR/$OUTPUT_FILE"
TEMP_HTML="$TEMP_DIR/temp.html"
TEMP_XML="$TEMP_DIR/temp.xml"
TEMP_FO="$TEMP_DIR/temp.fo"

echo "Starting conversion process..."
echo "Input Markdown: $INPUT_PATH"
echo "XSLT Template: $XSLT_PATH"
echo "Output PDF: $OUTPUT_PATH"

# Check if input files exist
if [ ! -f "$INPUT_PATH" ]; then
    echo "Error: Input file $INPUT_PATH does not exist"
    exit 1
fi

if [ ! -f "$XSLT_PATH" ]; then
    echo "Error: XSLT file $XSLT_PATH does not exist"
    exit 1
fi

# Step 1: Convert Markdown to HTML (intermediate format)
echo "Converting Markdown to HTML..."
pandoc "$INPUT_PATH" -f markdown -t html -o "$TEMP_HTML"

# Step 2: Convert HTML to XML (if needed for better XSLT compatibility)
echo "Converting HTML to XML..."
pandoc "$TEMP_HTML" -f html -t docbook -o "$TEMP_XML"

# Step 3: Apply XSLT transformation
echo "Applying XSLT transformation..."

# Determine output format from XSLT (FO or HTML)
if grep -q "fo:root" "$XSLT_PATH"; then
    # XSLT produces XSL-FO
    echo "Detected XSL-FO output format"
    java -jar /opt/saxon/saxon-he-11.4.jar -s:"$TEMP_XML" -xsl:"$XSLT_PATH" -o:"$TEMP_FO"
    
    # Step 4a: Convert XSL-FO to PDF
    echo "Converting XSL-FO to PDF..."
    /opt/fop/fop -fo "$TEMP_FO" -pdf "$OUTPUT_PATH"
else
    # XSLT produces HTML
    echo "Detected HTML output format"
    java -jar /opt/saxon/saxon-he-11.4.jar -s:"$TEMP_XML" -xsl:"$XSLT_PATH" -o:"$TEMP_HTML"
    
    # Step 4b: Convert HTML to PDF
    echo "Converting HTML to PDF using WeasyPrint..."
    python3 -m weasyprint "$TEMP_HTML" "$OUTPUT_PATH"
fi

# Check if output was created
if [ -f "$OUTPUT_PATH" ]; then
    echo "Conversion complete! PDF saved to: $OUTPUT_PATH"
    # Get file size
    FILE_SIZE=$(du -h "$OUTPUT_PATH" | cut -f1)
    echo "PDF size: $FILE_SIZE"
else
    echo "Error: Failed to create PDF"
    exit 1
fi

# Clean up temp files
if [ "$KEEP_TEMP" != "true" ]; then
    echo "Cleaning up temporary files..."
    rm -f "$TEMP_HTML" "$TEMP_XML" "$TEMP_FO"
fi

echo "Process completed successfully!"
