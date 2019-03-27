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
    
    <xsl:variable name="v_file-name" select="number(replace(base-uri(),'.+-i_(\d+).+$','$1'))"/>
    <xsl:variable name="v_volume">
        <xsl:if test="$v_file-name > 0 and $v_file-name lt 13">1</xsl:if>
        <xsl:if test="$v_file-name > 12 and $v_file-name lt 25">2</xsl:if>
        <xsl:if test="$v_file-name > 24 and $v_file-name lt 35">3</xsl:if>
        <xsl:if test="$v_file-name > 34 and $v_file-name lt 45">4</xsl:if>
        <xsl:if test="$v_file-name > 44 and $v_file-name lt 55">5</xsl:if>
        <xsl:if test="$v_file-name > 54 and $v_file-name lt 65">6</xsl:if>
        <xsl:if test="$v_file-name > 64 and $v_file-name lt 76">7</xsl:if>
        <xsl:if test="$v_file-name > 75 and $v_file-name lt 86">8</xsl:if>
        <xsl:if test="$v_file-name > 85 and $v_file-name lt 96">9</xsl:if>
    </xsl:variable>
    <xsl:variable name="v_issue">
        <xsl:if test="$v_volume = 1">
            <xsl:value-of select="$v_file-name"/>
        </xsl:if>
        <xsl:if test="$v_volume = 2">
            <xsl:value-of select="$v_file-name - 12"/>
        </xsl:if>
        <xsl:if test="$v_volume = 3">
            <xsl:value-of select="$v_file-name - 24"/>
        </xsl:if>
        <xsl:if test="$v_volume = 4">
            <xsl:value-of select="$v_file-name - 34"/>
        </xsl:if>
        <xsl:if test="$v_volume = 5">
            <xsl:value-of select="$v_file-name - 44"/>
        </xsl:if>
        <xsl:if test="$v_volume = 6">
            <xsl:value-of select="$v_file-name - 54"/>
        </xsl:if>
        <xsl:if test="$v_volume = 7">
            <xsl:value-of select="$v_file-name - 64"/>
        </xsl:if>
        <xsl:if test="$v_volume = 8">
            <xsl:value-of select="$v_file-name - 75"/>
        </xsl:if>
        <xsl:if test="$v_volume = 9">
            <xsl:value-of select="$v_file-name - 85"/>
        </xsl:if>
    </xsl:variable>
    
    <xsl:template match="tei:biblScope">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <!-- add documentation of change -->
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
    </xsl:template>
    
    
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}" who="{concat('#',$p_id-editor)}" xml:id="{$p_id-change}">Added volume and issue numbers on the basis of the file names.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@change" mode="m_documentation">
        <xsl:attribute name="change">
            <xsl:value-of select="concat(., ' #', $p_id-change)"/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>