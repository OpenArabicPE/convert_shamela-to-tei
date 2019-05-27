<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:oape="https://openarabicpe.github.io/ns"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xd:doc scope="stylesheet">
    <xd:desc>
        <xd:p></xd:p>
    </xd:desc>
    </xd:doc>
    
   <xsl:output encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="no"/>
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>

    <!-- Identity transform-->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc/tei:biblStruct//tei:biblScope[@unit='page']">
        <xsl:variable name="v_page-first" select="ancestor::tei:TEI/tei:text/descendant::tei:pb[@ed='print'][1]/@n"/>
    <xsl:variable name="v_page-last" select="ancestor::tei:TEI/tei:text/descendant::tei:pb[@ed='print'][last()]/@n -1"/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="change" select="concat('#',$p_id-change)"/>
            <xsl:attribute name="from" select="$v_page-first"/>
            <xsl:attribute name="to" select="$v_page-last"/>
            <xsl:value-of select="concat($v_page-first,'-',$v_page-last)"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}" who="{concat('#',$p_id-editor)}" xml:id="{$p_id-change}">Page numbers to bibliographic description of the source based on the file's content.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@change" mode="m_documentation">
        <xsl:attribute name="change">
            <xsl:value-of select="concat(., ' #', $p_id-change)"/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>