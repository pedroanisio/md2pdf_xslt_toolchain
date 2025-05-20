# Markdown → PDF via XSLT (md2pdf_xslt_toolchain)

A reproducible, container-driven toolchain that converts **Markdown** to **PDF** through a DocBook → XSL-FO pipeline, with optional HTML-to-PDF fallback.  
Everything—from dependency installation to execution—is wrapped in Docker for one-command portability.

---

## Features

| Stage | Tool | Purpose |
|-------|------|---------|
| Markdown → HTML / DocBook | **Pandoc** | Flexible Markdown conversion |
| XSLT 2.0 processing       | **Saxon-HE** | Apply custom XSLT to produce XSL-FO or HTML |
| XSL-FO → PDF              | **Apache FOP** | Standards-compliant PDF generation |
| HTML → PDF (alt.)         | **WeasyPrint** | CSS-driven PDF fallback when XSL-FO is not produced |

*Shell orchestration* is handled by `convert.sh`, and *volume wiring / variables* by `docker-compose.yml`.

---

## Directory layout

```

repo\_root/
├── docker-compose.yml
├── Dockerfile
├── convert.sh
├── input/          # .md files go here
├── templates/      # .xsl or .xslt files go here
└── output/         # generated .pdf files appear here

````

---

## Quick start

```bash
# 1 – clone & enter the repo
git clone <repo_url>
cd <repo_dir>

# 2 – prepare working dirs (first run only)
mkdir -p input templates output

# 3 – drop Markdown + XSLT into place
cp samples/example.md      input/
cp samples/fo_template.xsl templates/

# 4 – build + run
docker-compose up --build              # foreground
# or
docker-compose run --rm md2pdf         # one-off run
````

The entrypoint script will:

1. Convert each `*.md` in **input/** to HTML and DocBook XML.
2. Apply the first XSLT found in **templates/** via Saxon.
3. Detect whether the XSLT output is XSL-FO or HTML.
4. Send XSL-FO to FOP **or** HTML to WeasyPrint.
5. Write identically named PDFs into **output/**.

Progress and errors stream to the console; non-zero exit stops the container.

---

## Environment variables

| Variable          | Default           | Description                     |
| ----------------- | ----------------- | ------------------------------- |
| `PANDOC_OPTS`     | `""`              | Extra flags handed to Pandoc    |
| `SAXON_OPTS`      | `""`              | Extra flags for Saxon-HE        |
| `FOP_OPTS`        | `""`              | Extra flags for Apache FOP      |
| `WEASYPRINT_OPTS` | `""`              | Extra flags for WeasyPrint      |
| `INPUT_DIR`       | `/data/input`     | Mounted path for Markdown files |
| `TEMPLATE_DIR`    | `/data/templates` | Mounted path for XSLT templates |
| `OUTPUT_DIR`      | `/data/output`    | Mounted path for generated PDFs |

Override them in `docker-compose.yml` or with `docker-compose run -e`.

---

## Preconditions

* Docker ≥ 24
* `docker compose` plugin (or Compose V2)
* Host file system must support POSIX permissions for volume mounts.

---

## Customising the pipeline

* **Multiple templates** – Provide distinct XSLT files; the script applies the first template that matches each source.
* **Different back-ends** – Swap in PrinceXML or other tools by editing `convert.sh` and rebuilding the image.
* **Fonts / FO config** – Add custom `*.ttf` and a `fonts.xml` to the image or mount at runtime.

---

## Contributing

1. Fork → feature branch → PR.
2. Style: POSIX-shell, no Bashisms.
3. Include a passing sample conversion in CI.

---

## License

MIT License – see `LICENSE`.

---

## Acknowledgements

* Pandoc © John MacFarlane
* Saxon-HE © Saxonica
* Apache FOP © Apache Software Foundation
* WeasyPrint © CourtBouillon

`
