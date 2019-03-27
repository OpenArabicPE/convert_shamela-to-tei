<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheets groups sections between <tei:gi>lb</tei:gi> into paragraphs.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>
    <!-- identity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- group paragraphs into p's -->
    <xsl:template match="tei:div[tei:lb]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="tei:head"/>
            <xsl:for-each-group group-starting-with="tei:lb"
                select="if(tei:head) then(tei:head/following-sibling::node()) else(node())">
                <!-- do some preprocessing -->
                <xsl:variable name="v_p">
                    <xsl:element name="tei:p">
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                    <xsl:apply-templates select="current-group()"/>
                </xsl:element>
                </xsl:variable>
                <xsl:if test="not(matches($v_p,'^\s*$'))">
                    <xsl:copy-of select="$v_p"/>
                </xsl:if>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    <!-- suppress output of <lb> -->
    <xsl:template match="tei:lb"/>
    <!-- documentation of changes -->
    <xsl:template match="tei:revisionDesc" priority="100">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="change">
                <xsl:attribute name="when"
                    select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who"
                    select="concat('#', $p_editor/descendant-or-self::tei:respStmt[1]/tei:persName/@xml:id)"/>
                <xsl:attribute name="xml:id" select="$p_id-change"/>
                <xsl:attribute name="xml:lang" select="'en'"/>
                <xsl:text>Grouped paragraphs indicated by the presence of </xsl:text>
                <tei:gi xml:lang="en">tei:lb</tei:gi>
                <xsl:text> into </xsl:text>
                <tei:gi xml:lang="en">xml:p</tei:gi>
                <xsl:text>s.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
