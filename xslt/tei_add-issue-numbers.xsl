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
    <xsl:include href="../../../xslt-calendar-conversion/date-function.xsl"/>

    <!-- Identity transform-->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="v_issue" select="tei:TEI/tei:text/tei:body/tei:div[1]/tei:head/tei:num/@value"/>
    <xsl:variable name="v_date-publication" select="tei:TEI/tei:text/tei:body/tei:div[1]/tei:dateline/tei:date/@when"/>
    
    <xsl:template match="tei:sourceDesc/tei:biblStruct/tei:monogr">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
            <!-- add empty biblScope for volume information -->
            <xsl:element  name="biblScope">
                <xsl:attribute name="unit" select="'volume'"/>
                <xsl:attribute name="from" select="''"/>
                <xsl:attribute name="to" select="''"/>
            </xsl:element>
            <!-- add issue numbers -->
            <xsl:element  name="biblScope">
                <xsl:attribute name="unit" select="'issue'"/>
                <xsl:attribute name="from" select="$v_issue"/>
                <xsl:attribute name="to" select="$v_issue"/>
                <xsl:value-of select="$v_issue"/>
            </xsl:element>
            <!-- add empty biblScope for page information -->
            <xsl:element  name="biblScope">
                <xsl:attribute name="unit" select="'page'"/>
                <xsl:attribute name="from" select="''"/>
                <xsl:attribute name="to" select="''"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:imprint/tei:date">
        <xsl:copy-of select="oape:date-format-iso-string-to-tei($v_date-publication,'#cal_gregorian',true(),false(),'ar')"/>
        <!--<xsl:copy>
            <!-\- add information -\->
            <xsl:attribute name="when" select="$v_date-publication"/>
            <xsl:attribute name="calendar" select="'#cal_gregorian'"/>
            
        </xsl:copy>-->
    </xsl:template>
    <!--<xsl:template match="tei:biblScope">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <!-\- add documentation of change -\->
                    <xsl:choose>
                        <xsl:when test="not(@change)">
                            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="m_documentation" select="@change"/>
                        </xsl:otherwise>
                    </xsl:choose>
            <xsl:if test="@unit = 'volume'">
                <xsl:attribute name="from" select="$v_volume"/>
            <xsl:attribute name="to" select="$v_volume"/>
            </xsl:if>
            <xsl:if test="@unit = 'issue'">
                <xsl:attribute name="from" select="$v_issue"/>
            <xsl:attribute name="to" select="$v_issue"/>
            </xsl:if>
        </xsl:copy>
    </xsl:template>-->
    
    
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}" who="{concat('#',$p_id-editor)}" xml:id="{$p_id-change}">Added  issue numbers and publication dates on the basis of first div's title in shamela's transcription.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@change" mode="m_documentation">
        <xsl:attribute name="change">
            <xsl:value-of select="concat(., ' #', $p_id-change)"/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>