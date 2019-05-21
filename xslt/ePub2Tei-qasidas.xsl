<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs dc opf xd html" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet will paragraphs with a single gap node in the center into line groups.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>
    <!-- the templates -->
   
    <!-- identiy transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="node() | @*" mode="m_preprocess">
        <xsl:copy>
            <xsl:apply-templates mode="m_preprocess" select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="node() | @*" mode="m_process">
        <xsl:copy>
            <xsl:apply-templates mode="m_process" select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:div">
        <xsl:variable name="vPreprocessedText">
            <xsl:copy>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates mode="m_preprocess"/>
            </xsl:copy>
        </xsl:variable>
        <xsl:apply-templates mode="m_process" select="$vPreprocessedText/tei:div"/>
    </xsl:template>
    <xsl:param name="p_max-string-length" select="40"/>
    <xsl:template match="tei:p" mode="m_preprocess">
        <xsl:choose>
            <xsl:when
                test="(count(child::node()) = 3) and child::node()[position() = (1,3)] = text()[string-length() lt $p_max-string-length] and child::node()[2] = child::tei:gap[@resp = '#org_MS']">
                <xsl:call-template name="t_generate-bayt">
                    <xsl:with-param name="p_seg-1" select="text()[1]"/>
                    <xsl:with-param name="p_seg-2" select="text()[2]"/>
                </xsl:call-template>
            </xsl:when>
             <xsl:when
                test="(count(child::node()) = 7) and child::node()[position() = (1,3,5,7)] = text()[string-length() lt $p_max-string-length] and child::node()[position() = (2,6)] = child::tei:gap[@resp = '#org_MS']">
                 <xsl:call-template name="t_generate-bayt">
                    <xsl:with-param name="p_seg-1" select="text()[1]"/>
                    <xsl:with-param name="p_seg-2" select="text()[2]"/>
                </xsl:call-template>
                 <xsl:apply-templates select="node()[4]"/>
                 <xsl:call-template name="t_generate-bayt">
                    <xsl:with-param name="p_seg-1" select="text()[3]"/>
                    <xsl:with-param name="p_seg-2" select="text()[4]"/>
                </xsl:call-template>
             </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="t_generate-bayt">
        <xsl:param name="p_seg-1"/>
        <xsl:param name="p_seg-2"/>
        <xsl:element name="tei:l">
            <xsl:attribute name="type" select="'bayt'"/>
            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
            <xsl:element name="tei:seg">
                <xsl:value-of select="normalize-space($p_seg-1)"/>
            </xsl:element>
            <xsl:text> </xsl:text>
            <xsl:element name="tei:seg">
                <xsl:value-of select="normalize-space($p_seg-2)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!--<xsl:template match="tei:p[count(child::node()) = 3][child::tei:gap[@resp = '#org_MS']]"
        mode="m_preprocess">
        <l type="bayt">
            <xsl:for-each select="child::text()">
                <seg>
                    <xsl:value-of select="."/>
                </seg>
            </xsl:for-each>
        </l>
    </xsl:template>-->
    <!-- wrap single lines in <lg> -->
    <!--<xsl:template
        match="tei:l[@type = 'bayt'][not(preceding-sibling::node()[1] = tei:l[@type = 'bayt'])][not(following-sibling::node()[1] = tei:l[@type = 'bayt'])]"
        mode="m_process">
        <lg>
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
        </lg>
    </xsl:template>-->
    <!-- find the first line in a line group -->
    <xsl:template match="tei:l[@type = 'bayt']" mode="m_process">
        <xsl:choose>
            <xsl:when test="following-sibling::node()[1] = tei:l[@type = 'bayt']">
                <xsl:message>
                    <xsl:text>l followed by an l</xsl:text>
                </xsl:message>
            </xsl:when>
            <xsl:when test="(preceding-sibling::node()[1] != self::tei:l[@type = 'bayt']) and (following-sibling::node()[1] = self::tei:l[@type = 'bayt'])">
                <xsl:message>
                    <xsl:text>found first l in an lg</xsl:text>
                </xsl:message>
                <lg change="{concat('#',$p_id-change)}">
                    <xsl:copy>
                        <xsl:apply-templates select="@* | node()"/>
                    </xsl:copy>
                    <xsl:for-each select="following-sibling::tei:l[@type = 'bayt'][preceding-sibling::node()[1] = tei:l[@type = 'bayt']]">
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()"/>
                        </xsl:copy>
                    </xsl:for-each>
                </lg>
            </xsl:when>
            <xsl:otherwise>
                <lg change="{concat('#',$p_id-change)}">
                    <xsl:copy>
                            <xsl:apply-templates select="@* | node()"/>
                        </xsl:copy>
                </lg>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--<xsl:template
        match="tei:l[@type = 'bayt'][not(preceding-sibling::node()[1] = tei:l[@type = 'bayt'])][following-sibling::node()[1] = tei:l[@type = 'bayt']]"
        mode="m_process" priority="10">
        <lg>
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
            <xsl:for-each
                select="following-sibling::tei:l[@type = 'bayt'][preceding-sibling::node()[1] = tei:l[@type = 'bayt']]">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:for-each>
        </lg>
    </xsl:template>-->
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}" who="{concat('#',$p_id-editor)}" change="{$p_id-change}" xml:lang="en"
                >Converted the mark-up of <foreign xml:lang="ar-Latn-x-ijmes"
                >qaṣīda</foreign>s from <gi>p</gi>s divided by a <gi>gap</gi> to <gi>l</gi> of <att>type</att>="bayt" comprising two <gi>seg</gi> nodes.</change>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
