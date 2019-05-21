<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd"
    version="3.0">
    
    <xd:doc scope="stylesheet">
    <xd:desc>
        <xd:p></xd:p>
    </xd:desc>
    </xd:doc>
    
   <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>

    <!-- Identity transform-->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:pb[@ed='shamela']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <!-- add new page break -->
        <xsl:element name="pb">
            <xsl:attribute name="change" select="concat('#',$p_id-change)"/>
            <xsl:attribute name="ed" select="'print'"/>
            <xsl:attribute name="n" select="replace(@n,'n\d-p(\d+)$','$1')"/>
        </xsl:element>
    </xsl:template>
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}" who="{concat('#',$p_id-editor)}" xml:id="{$p_id-change}">Page breaks for the print edition that mirror the pagination from shamela.ws</change>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>