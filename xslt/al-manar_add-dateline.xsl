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
    <!--<xsl:include href="../../../xslt-calendar-conversion/date-function.xsl"/>-->

    <!-- Identity transform-->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
   <xsl:template match="tei:body/tei:head">
       <xsl:element name="tei:div">
           <xsl:attribute name="type" select="'item'"/>
           <xsl:attribute name="subtype" select="'masthead'"/>
           <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
           <!-- replicate the head without dates -->
           <xsl:copy>
               <xsl:apply-templates select="@*"/>
               <xsl:apply-templates select="node()[not(self::tei:date)]"/>
           </xsl:copy>
           <xsl:element name="tei:dateline">
               <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
               <xsl:apply-templates select="tei:date"/>
               <xsl:apply-templates select="following-sibling::tei:date"/>
           </xsl:element>
           <!-- add rest -->
<!--           <xsl:apply-templates select="following-sibling::node()[not(self::tei:date)] >> tei:div"/>-->
       </xsl:element>
   </xsl:template>
<!--    <xsl:template match="tei:body/tei:date"/>-->
    
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
             <xsl:apply-templates select="@*"/>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}" who="{concat('#',$p_id-editor)}" xml:id="{$p_id-change}" xml:lang="en">Wrapped the beginning of <gi>body</gi> in a <gi>div</gi> and added a <gi>dateline</gi></change>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@change" mode="m_documentation">
        <xsl:attribute name="change">
            <xsl:value-of select="concat(., ' #', $p_id-change)"/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>