
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

