<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet splits a large TEI file into smaller TEI files based on some criteria. The original file is already structured into <tei:gi>div</tei:gi>s.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:result-document href="{ substring-before(base-uri(),'.TEIP5')}-SplitDivs.TEIP5.xml">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:text/tei:body">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="descendant::tei:head"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- split into divs: between a text node and a <head> -->
    
    <xsl:template match="tei:head">
        <xsl:element name="tei:div">
            <!-- here comes the head -->
            <xsl:copy-of select="."/>
            <!-- wrap everything into an <ab> to make it validate against TEI all -->
            <xsl:element name="tei:ab">
                <!-- copy all following nodes until the next head -->
                <!-- functional for all but the last head -->
                <!--            <xsl:copy-of select="following::node()[. &lt;&lt; current()/following::tei:head[1]]"/>-->
                <xsl:copy-of select="following-sibling::node()[not(self::tei:head)][preceding-sibling::tei:head[1]=current()]"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>