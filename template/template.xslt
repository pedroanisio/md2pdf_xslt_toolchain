<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- Output method is HTML -->
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <!-- Key for finding sections by title to avoid duplication -->
    <xsl:key name="section-by-title" match="section" use="title"/>
    
    <!-- Main template matching document root -->
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="//articleinfo/title | //article/title"/>
                </title>
                <style type="text/css">
                    /* Professional PDF Report Styles */
                    @page {
                        size: A4;
                        margin: 1.5cm;  /* Reduced margin for space efficiency */
                        @top-center {
                            content: string(document-title);
                            font-size: 9pt;
                            color: #444;
                            font-family: "Arial", sans-serif;
                            border-bottom: 1pt solid #ddd;
                            padding-bottom: 5pt;
                        }
                        @bottom-center {
                            content: "Page " counter(page) " of " counter(pages);
                            font-size: 9pt;
                            color: #444;
                            font-family: "Arial", sans-serif;
                            border-top: 1pt solid #ddd;
                            padding-top: 5pt;
                        }
                    }
                    
                    /* Add alternate paper sizes 
                       Uncomment one of these and comment out the default A4 size above
                    */
                    /*
                    @page {
                        size: letter;  /* US Letter: 8.5in x 11in */
                        margin: 1.5cm;
                    }
                    */
                    
                    /*
                    @page {
                        size: 210mm 297mm;  /* Custom size - equivalent to A4 */
                        margin: 1.5cm;
                    }
                    */
                    
                    /* Add print-specific styles */
                    @media print {
                        section {
                            page-break-inside: avoid;
                        }
                        h1, h2 {
                            page-break-after: avoid;
                        }
                        h3, h4, h5 {
                            page-break-after: avoid;
                        }
                        table, figure {
                            page-break-inside: avoid;
                        }
                    }
                    
                    /* Enable better font rendering */
                    html {
                        -webkit-font-smoothing: antialiased;
                        -moz-osx-font-smoothing: grayscale;
                        font-feature-settings: "kern" 1, "liga" 1;
                    }
                    
                    body {
                        /* Font stack with more compact options */
                        font-family: "Arial Narrow", "Helvetica Neue", "Roboto Condensed", sans-serif;
                        line-height: 1.4;
                        font-size: 10pt;
                        font-weight: 400;
                        color: #333;
                        max-width: 1000px;
                        margin: 0 auto;
                        padding: 20px;
                        counter-reset: section;
                    }
                    
                    /* Font spacing adjustments for space efficiency */
                    p, li, td, th {
                        letter-spacing: -0.01em;  /* Slightly tighter character spacing */
                        word-spacing: -0.01em;    /* Slightly tighter word spacing */
                    }

                    /* Add @font-face declarations for web fonts if needed */
                    @font-face {
                        font-family: 'Roboto Condensed';
                        font-style: normal;
                        font-weight: 400;
                        /* Use data URIs for small fonts or specify relative paths for font files */
                        src: url('fonts/RobotoCondensed-Regular.woff2') format('woff2');
                        font-display: swap;
                    }
                    
                    /* More compact heading hierarchy */
                    h1.document-title {
                        string-set: document-title content();
                        font-size: 18pt;   /* Reduced size */
                        font-family: "Arial", sans-serif;
                        text-align: center;
                        color: #003366;
                        margin-top: 25px;
                        margin-bottom: 15px;
                    }

                    .cover-page {
                        height: 90vh;  /* Reduced from 100vh */
                        display: flex;
                        flex-direction: column;
                        justify-content: center;
                        align-items: center;
                        text-align: center;
                        page-break-after: always;
                    }

                    .cover-title {
                        font-size: 26pt;
                        font-family: "Arial", sans-serif;
                        color: #003366;
                        margin-bottom: 40px;
                        font-weight: bold;
                    }

                    .cover-subtitle {
                        font-size: 16pt;
                        font-family: "Arial", sans-serif;
                        color: #004080;
                        margin-bottom: 60px;
                    }

                    .cover-date {
                        font-size: 12pt;
                        font-family: "Arial", sans-serif;
                        margin-top: 80px;
                        color: #666;
                    }

                    /* Improved section titles with automatic numbering */
                    h2 {
                        counter-increment: section;
                        font-size: 13pt;   /* Reduced size */
                        font-family: "Arial", sans-serif;
                        color: #003366;
                        border-bottom: 1px solid #003366;
                        margin-top: 18px;
                        padding-bottom: 3px;
                        clear: both;
                    }
                    
                    h2::before {
                        content: counter(section) ". ";
                    }
                    
                    h3 {
                        font-size: 11pt;   /* Reduced size */
                        font-family: "Arial", sans-serif;
                        color: #004080;
                        margin-top: 12px;
                        counter-reset: subsection;
                    }
                    
                    h3::before {
                        content: counter(section) "." counter(subsection) " ";
                        counter-increment: subsection;
                    }

                    h4 {
                        font-size: 10pt;   /* Same as body text, just bold */
                        font-family: "Arial", sans-serif;
                        font-weight: bold;
                        color: #004080;
                        margin-top: 10px;
                    }

                    h5 {
                        font-size: 10pt;
                        font-family: "Arial", sans-serif;
                        color: #004080;
                        margin-top: 10px;
                        font-style: italic;
                    }

                    p {
                        text-align: justify;
                        margin-bottom: 8px;  /* Reduced */
                        hyphens: auto;
                    }

                    a {
                        color: #0066cc;
                        text-decoration: none;
                    }

                    a:hover {
                        text-decoration: underline;
                    }

                    /* Space-efficient TOC */
                    .toc {
                        font-family: "Arial Narrow", sans-serif;
                        margin: 15px 0 25px 0;
                        page-break-after: always;
                    }
                    
                    .toc-header {
                        font-size: 16pt;
                        font-family: "Arial", sans-serif;
                        text-align: center;
                        color: #003366;
                        margin-bottom: 15px;
                        page-break-before: always;
                        page-break-after: avoid;
                    }

                    .toc a {
                        text-decoration: none;
                        color: #333;
                    }

                    .toc a:hover {
                        text-decoration: underline;
                    }

                    .toc-item-1 {
                        margin: 8px 0 4px 0;
                        font-weight: bold;
                    }
                    
                    .toc-item-1::after {
                        content: leader('.') target-counter(attr(href), page);
                        float: right;
                    }

                    .toc-item-2 {
                        margin: 4px 0 2px 20px;
                    }
                    
                    .toc-item-2::after {
                        content: leader('.') target-counter(attr(href), page);
                        float: right;
                    }

                    .toc-item-3 {
                        margin-left: 40px;
                        font-size: 95%;
                    }
                    
                    .toc-item-3::after {
                        content: leader('.') target-counter(attr(href), page);
                        float: right;
                    }

                    /* Compact tables with optimized fonts */
                    table {
                        width: 100%;
                        border-collapse: collapse;
                        margin: 12px 0;
                        font-size: 8.5pt;  /* Reduced size */
                        font-family: "Arial Narrow", sans-serif;
                    }

                    th {
                        background-color: #f2f2f2;
                        font-weight: bold;
                        text-align: left;
                        padding: 6px 10px;  /* Reduced padding */
                        border: 1px solid #ddd;
                        vertical-align: middle;
                    }

                    td {
                        border: 1px solid #ddd;
                        padding: 6px 10px;  /* Reduced padding */
                        text-align: left;
                        vertical-align: top;
                    }

                    tr:nth-child(even) {
                        background-color: #f9f9f9;
                    }
                    
                    /* Add caption for tables */
                    caption {
                        font-style: italic;
                        font-family: "Arial Narrow", sans-serif;
                        text-align: left;
                        caption-side: bottom;
                        margin-top: 8px;
                        font-size: 8pt;
                        color: #666;
                    }

                    /* Compact code with monospace optimization */
                    code {
                        font-family: "Consolas", "DejaVu Sans Mono", monospace;
                        font-size: 90%;
                        background-color: #f5f5f5;
                        padding: 1px 3px;
                        border-radius: 3px;
                        color: #d14;
                    }

                    pre {
                        font-family: "Consolas", "DejaVu Sans Mono", monospace;
                        font-size: 8.5pt;
                        background-color: #f5f5f5;
                        padding: 10px;
                        border-radius: 4px;
                        overflow-x: auto;
                        margin: 15px 0;
                        border: 1px solid #eee;
                        line-height: 1.3;
                    }
                    
                    /* Optional two-column layout for specific sections */
                    .two-column-section {
                        column-count: 2;
                        column-gap: 20px;
                        column-rule: 1px solid #eee;
                    }
                    
                    /* Ensure headings span across columns */
                    .two-column-section h2, 
                    .two-column-section h3 {
                        column-span: all;
                    }
                    
                    /* Lists styling - more compact */
                    ul, ol {
                        margin: 10px 0;  /* Reduced */
                        padding-left: 25px;  /* Reduced */
                    }
                    
                    li {
                        margin-bottom: 3px;  /* Reduced */
                    }
                    
                    /* Admonitions styling */
                    .note, .warning, .important {
                        margin: 15px 0;
                        padding: 12px 12px 12px 45px;
                        border-radius: 4px;
                        background-position: 12px center;
                        background-repeat: no-repeat;
                        background-size: 20px 20px;
                        font-size: 9pt;
                    }
                    
                    .note {
                        background-color: #e6f3ff;
                        border-left: 4px solid #4a86e8;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='24' height='24'%3E%3Cpath fill='%234a86e8' d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z'/%3E%3C/svg%3E");
                    }
                    
                    .warning {
                        background-color: #fff9e6;
                        border-left: 4px solid #f4b400;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='24' height='24'%3E%3Cpath fill='%23f4b400' d='M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z'/%3E%3C/svg%3E");
                    }
                    
                    .important {
                        background-color: #fce9e9;
                        border-left: 4px solid #db4437;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='24' height='24'%3E%3Cpath fill='%23db4437' d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 15h2v2h-2v-2zm0-10h2v8h-2V7z'/%3E%3C/svg%3E");
                    }
                    
                    /* Footnotes and captions in smaller, space-efficient font */
                    .footer, figcaption {
                        font-family: "Arial Narrow", sans-serif;
                        font-size: 8pt;
                        color: #666;
                    }

                    /* Page break utility class */
                    .page-break {
                        page-break-before: always;
                    }
                </style>
            </head>
            <body>
                <!-- Cover Page -->
                <div class="cover-page">
                    <div class="cover-title">
                        <xsl:value-of select="//articleinfo/title | //article/title"/>
                    </div>
                    <div class="cover-subtitle">Technical Documentation</div>
                    <div class="cover-date">
                        <xsl:value-of select="format-date(current-date(), '[MNn] [D], [Y]')"/>
                    </div>
                </div>
                
                <!-- Document title for running header -->
                <h1 class="document-title">
                    <xsl:value-of select="//articleinfo/title | //article/title"/>
                </h1>
                
                <!-- TOC -->
                <h1 class="toc-header">Table of Contents</h1>
                <div class="toc">
                    <xsl:for-each select="//section">
                        <!-- Only process unique titles to avoid duplication -->
                        <xsl:if test="generate-id(.) = generate-id(key('section-by-title', ./title)[1])">
                            <div class="toc-item-1">
                                <a href="#{generate-id(.)}">
                                    <xsl:value-of select="./title"/>
                                </a>
                            </div>
                            
                            <!-- Add subsections if needed -->
                            <xsl:for-each select="./section">
                                <div class="toc-item-2">
                                    <a href="#{generate-id(.)}">
                                        <xsl:value-of select="./title"/>
                                    </a>
                                </div>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:for-each>
                </div>
                
                <!-- Content starts -->
                <div class="content">
                    <!-- Process all sections, preventing duplicates -->
                    <xsl:apply-templates select="//section"/>
                    
                    <!-- Process paragraphs not in sections -->
                    <xsl:apply-templates select="//article/para"/>
                </div>
                
                <!-- Footer -->
                <div class="footer">
                    <p>Document generated on <xsl:value-of select="format-date(current-date(), '[MNn] [D], [Y]')"/></p>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- Prevent duplicated content -->
    <xsl:template match="section">
        <!-- Only process sections with unique titles -->
        <xsl:if test="generate-id(.) = generate-id(key('section-by-title', ./title)[1])">
            <div id="{generate-id(.)}" class="section">
                <h2><xsl:value-of select="./title"/></h2>
                <xsl:apply-templates select="*[not(self::title)]"/>
            </div>
        </xsl:if>
    </xsl:template>
    
    <!-- Template for nested sections -->
    <xsl:template match="section/section">
        <div id="{generate-id(.)}" class="subsection">
            <h3><xsl:value-of select="./title"/></h3>
            <xsl:apply-templates select="*[not(self::title)]"/>
        </div>
    </xsl:template>
    
    <!-- Template for compact content -->
    <xsl:template match="section[@role='compact']">
        <div id="{generate-id(.)}" class="section two-column-section">
            <h2><xsl:value-of select="./title"/></h2>
            <xsl:apply-templates select="*[not(self::title)]"/>
        </div>
    </xsl:template>
    
    <!-- Template for paragraphs -->
    <xsl:template match="para">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <!-- Template for emphasis (italic) -->
    <xsl:template match="emphasis">
        <em><xsl:apply-templates/></em>
    </xsl:template>
    
    <!-- Template for strong (bold) -->
    <xsl:template match="emphasis[@role='bold'] | emphasis[@role='strong']">
        <strong><xsl:apply-templates/></strong>
    </xsl:template>
    
    <!-- Template for links -->
    <xsl:template match="ulink">
        <a href="{@url}"><xsl:apply-templates/></a>
    </xsl:template>
    
    <!-- Template for lists -->
    <xsl:template match="itemizedlist">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <!-- Template for ordered lists -->
    <xsl:template match="orderedlist">
        <ol>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    
    <!-- Template for list items -->
    <xsl:template match="listitem">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <!-- Template for code blocks -->
    <xsl:template match="programlisting">
        <pre><code><xsl:apply-templates/></code></pre>
    </xsl:template>
    
    <!-- Template for inline code -->
    <xsl:template match="code">
        <code><xsl:apply-templates/></code>
    </xsl:template>
    
    <!-- Template for tables -->
    <xsl:template match="table">
        <table>
            <xsl:if test="@id">
                <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="title">
                <caption><xsl:value-of select="title"/></caption>
            </xsl:if>
            <xsl:apply-templates select="*[not(self::title)]"/>
        </table>
    </xsl:template>
    
    <!-- Template for table headers -->
    <xsl:template match="thead">
        <thead>
            <xsl:apply-templates/>
        </thead>
    </xsl:template>
    
    <!-- Template for table body -->
    <xsl:template match="tbody">
        <tbody>
            <xsl:apply-templates/>
        </tbody>
    </xsl:template>
    
    <!-- Template for table rows -->
    <xsl:template match="row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <!-- Template for table cells -->
    <xsl:template match="entry">
        <xsl:choose>
            <xsl:when test="parent::row/parent::thead">
                <th><xsl:apply-templates/></th>
            </xsl:when>
            <xsl:otherwise>
                <td><xsl:apply-templates/></td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Template for notes -->
    <xsl:template match="note">
        <div class="note">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Template for warnings -->
    <xsl:template match="warning">
        <div class="warning">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Template for important notices -->
    <xsl:template match="important">
        <div class="important">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Template for figures -->
    <xsl:template match="figure">
        <figure id="{@id}">
            <xsl:apply-templates select="*[not(self::title)]"/>
            <figcaption><xsl:value-of select="title"/></figcaption>
        </figure>
    </xsl:template>
    
    <!-- Template for images -->
    <xsl:template match="graphic | imagedata">
        <img src="{@fileref}" alt="{../@alt}">
            <xsl:if test="@width">
                <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@depth">
                <xsl:attribute name="height"><xsl:value-of select="@depth"/></xsl:attribute>
            </xsl:if>
        </img>
    </xsl:template>
</xsl:stylesheet>
