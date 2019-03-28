<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    
       <xsl:output encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="no"/>
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>

    <!-- Identity transform-->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- find the last <p> in a div and check if it is below a maximum length -->
    <xsl:template match="tei:div[@type='item']/tei:p[not(following-sibling::*)][string-length(.) lt 60]">
        <xsl:element name="byline">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}" who="{concat('#',$p_id-editor)}" xml:id="{$p_id-change}">Marked final <tei:gi>p</tei:gi>s inside <tei:gi>div</tei:gi>s as bylines (<tei:gi>byline</tei:gi>) if they did not exceed a string length of 60.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>