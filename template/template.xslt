<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">
    
    <!-- Output method is XSL-FO -->
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Main template matching document root -->
    <xsl:template match="/">
        <fo:root>
            <!-- Define page layout -->
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4" 
                        page-height="29.7cm" page-width="21.0cm" 
                        margin-top="1cm" margin-bottom="1cm" 
                        margin-left="2cm" margin-right="2cm">
                    <fo:region-body margin-top="1cm" margin-bottom="1.5cm"/>
                    <fo:region-before extent="1cm"/>
                    <fo:region-after extent="1cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            
            <!-- Page content -->
            <fo:page-sequence master-reference="A4">
                <!-- Footer with page number -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="center" font-size="10pt">
                        Page <fo:page-number/>
                    </fo:block>
                </fo:static-content>
                
                <!-- Main content -->
                <fo:flow flow-name="xsl-region-body">
                    <!-- Title from article info -->
                    <xsl:apply-templates select="//articleinfo/title | //article/title"/>
                    
                    <!-- Process all sections -->
                    <xsl:apply-templates select="//section"/>
                    
                    <!-- Process paragraphs not in sections -->
                    <xsl:apply-templates select="//article/para"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    
    <!-- Template for article title -->
    <xsl:template match="//articleinfo/title | //article/title">
        <fo:block font-size="24pt" font-weight="bold" space-after="16pt" text-align="center">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- Template for section titles -->
    <xsl:template match="section/title">
        <fo:block font-size="18pt" font-weight="bold" space-before="16pt" space-after="8pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- Template for paragraphs -->
    <xsl:template match="para">
        <fo:block space-after="6pt" text-align="justify" line-height="1.5">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- Template for section -->
    <xsl:template match="section">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Template for emphasis (italic) -->
    <xsl:template match="emphasis">
        <fo:inline font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    
    <!-- Template for strong (bold) -->
    <xsl:template match="emphasis[@role='bold'] | emphasis[@role='strong']">
        <fo:inline font-weight="bold">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    
    <!-- Template for links -->
    <xsl:template match="ulink">
        <fo:basic-link external-destination="{@url}" color="blue" text-decoration="underline">
            <xsl:apply-templates/>
        </fo:basic-link>
    </xsl:template>
    
    <!-- Template for lists -->
    <xsl:template match="itemizedlist">
        <fo:list-block space-before="6pt" space-after="6pt" provisional-distance-between-starts="12pt">
            <xsl:apply-templates/>
        </fo:list-block>
    </xsl:template>
    
    <!-- Template for list items -->
    <xsl:template match="listitem">
        <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
                <fo:block>•</fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <xsl:apply-templates/>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
    
    <!-- Template for code blocks -->
    <xsl:template match="programlisting">
        <fo:block font-family="monospace" background-color="#f0f0f0" padding="6pt" white-space-treatment="preserve" linefeed-treatment="preserve" white-space-collapse="false">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
</xsl:stylesheet>
