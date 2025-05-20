# Quick Start Guide

## Setup and Run

To get started with the Markdown to PDF converter:

1. Clone this repository
2. Create the required directories and files:

```bash
# Create directories
mkdir -p input templates output

# Copy example files
cp document.md input/
cp template.xsl templates/
```

3. Build and run the Docker container:

```bash
# Build the Docker image
docker-compose build

# Run the conversion
docker-compose up
```

4. Find your PDF in the `output` directory

## Directory Structure

The required file structure is:

```
.
├── Dockerfile
├── docker-compose.yml
├── convert.sh
├── input/
│   └── document.md
├── templates/
│   └── template.xsl
└── output/
    └── output.pdf (generated)
```

## Command Examples

### Basic usage:
```bash
docker-compose up
```

### Specify custom filenames:
```bash
MARKDOWN_FILE=custom.md XSLT_FILE=style.xsl OUTPUT_FILE=result.pdf docker-compose up
```

### Run directly:
```bash
docker-compose run md-to-pdf custom.md style.xsl result.pdf
```

### Keep temporary files for debugging:
```bash
KEEP_TEMP=true docker-compose up
```
