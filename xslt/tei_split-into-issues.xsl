<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     _exclude-result-prefixes="xd">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheets tries to split a TEI for an entire journal into issues.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>
    
    <xsl:variable name="v_source-desc" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc"/>
    <xsl:variable name="v_id-oclc" select="$v_source-desc/descendant::tei:idno[@type='OCLC'][1]"/>
    <!-- identity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:for-each-group select="tei:div" group-starting-with="self::tei:div[matches(tei:head,'العدد\s*\d+')]">
                 <xsl:variable name="v_issue" select="replace(tei:head,'العدد\s*(\d+)','$1')"/>
        <xsl:result-document href="_output/issues/oclc_{$v_id-oclc}-i_{$v_issue}.TEIP5.xml">
            <xsl:element name="tei:TEI">
            <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader"/>
            <xsl:element name="tei:text">
                <xsl:attribute name="xml:lang" select="'ar'"/>
                <!-- add the preceding <pb/> -->
                <xsl:copy-of select="preceding::tei:pb[1]"/>
                <xsl:element name="tei:body">
                        <xsl:apply-templates select="current-group()"/>
                </xsl:element>
            </xsl:element>
            </xsl:element>
        </xsl:result-document>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    <!-- split issues -->
    <!--<xsl:template match="tei:div[matches(tei:head,'العدد\s*\d+')]">
        <!-\- do something: new wrapping node, new file etc. -\->
        <xsl:variable name="v_issue" select="replace(tei:head,'العدد\s*(\d+)','$1')"/>
        <xsl:result-document href="_output/issues/oclc_{$v_id-oclc}-i_{$v_issue}.TEIP5.xml">
            <xsl:element name="tei:TEI">
            <xsl:copy-of select="ancestor::tei:TEI/tei:teiHeader"/>
            <xsl:element name="tei:text">
                <xsl:attribute name="xml:lang" select="'ar'"/>
                <!-\- add the preceding <pb/> -\->
                <xsl:copy-of select="preceding::tei:pb[1]"/>
                <xsl:element name="tei:body">
                    <xsl:copy>
                        <xsl:apply-templates select="@* | node()"/>
                    </xsl:copy>
                </xsl:element>
            </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>-->
   
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
                <xsl:text>Grouped divs along the presence of </xsl:text>
                <tei:gi xml:lang="en">head</tei:gi>
                <xsl:text> of "العدد\s*\d+" that indicate the beginning of a new journal issue into ...</xsl:text>
                <tei:gi xml:lang="en">tei:p</tei:gi>
                <xsl:text>s.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
