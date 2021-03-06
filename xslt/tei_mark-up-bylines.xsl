<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="no"/>
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>
    <xsl:param name="p_string-length" select="70"/>
    <!-- Identity transform-->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- find the last <p> in a div and check if it is below a maximum length -->
    <xsl:template
        match="tei:div[@type = 'item'][not(tei:byline)]/tei:p[not(following-sibling::node())]">
        <xsl:if test="$p_verbose = true()">
            <xsl:message>
                <xsl:text>Found div without byline.</xsl:text>
            </xsl:message>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="tei:persName">
                <xsl:if test="$p_verbose = true()">
                    <xsl:message>
                        <xsl:text>Final p contains a persName</xsl:text>
                    </xsl:message>
                </xsl:if>
                <xsl:element name="byline">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(.) lt $p_string-length">
                <xsl:if test="$p_verbose = true()">
                    <xsl:message>
                        <xsl:text>Final p is shorter than threshhold.</xsl:text>
                    </xsl:message>
                </xsl:if>
                <xsl:element name="byline">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$p_verbose = true()">
                    <xsl:message>
                        <xsl:text>Final p is longer than threshhold.</xsl:text>
                    </xsl:message>
                </xsl:if>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}"
                who="{concat('#',$p_id-editor)}" xml:id="{$p_id-change}" xml:lang="en"
                >Marked final <tei:gi>p</tei:gi>s inside <tei:gi>div</tei:gi>s as bylines (<tei:gi>byline</tei:gi>) if they did not exceed a string length of <xsl:value-of
                select="$p_string-length"/>.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
