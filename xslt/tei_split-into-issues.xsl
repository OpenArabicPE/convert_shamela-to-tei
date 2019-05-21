<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet _exclude-result-prefixes="xd" exclude-result-prefixes="xs" version="3.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheets tries to split a TEI for an entire journal into issues.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>
    <xsl:variable name="v_teiHeader" select="tei:TEI/tei:teiHeader"/>
    <xsl:variable name="v_sourceDesc" select="$v_teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
    <xsl:variable name="v_id-oclc" select="$v_sourceDesc/descendant::tei:idno[@type = 'OCLC'][1]"/>
    <!-- identity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:body">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <!-- in some instances, such as *al-Manār*, issues have been marked up as such -->
                <xsl:when test="descendant::tei:div[@type = 'issue']">
                    <xsl:apply-templates select="descendant::tei:div[@type = 'issue']"/>
                    <!--<xsl:for-each-group group-starting-with="self::tei:div[@type = 'volume']" select="tei:div">
                        <xsl:variable name="v_volume" select="current-group()/descendant-or-self::tei:div[@type = 'volume']/@n"/>
                        <xsl:message>
                            <xsl:text>volume: </xsl:text><xsl:value-of select="$v_volume"/>
                        </xsl:message>
                        <!-\- on to issues -\->
                        <xsl:for-each-group select="current-group()/descendant-or-self::tei:div[@type = 'issue']" group-by=".">
                            <xsl:variable name="v_issue" select="count(self::node()/preceding-sibling::tei:div[@type = 'issue']) + 1"/>
                            <xsl:result-document href="_output/issues/oclc_{$v_id-oclc}-v_{$v_volume}-i_{$v_issue}.TEIP5.xml">
                                <xsl:element name="tei:TEI">
                                    <!-\- construct metadata -\->
                                    <xsl:element name="tei:teiHeader">
                                        <xsl:element name="tei:fileDesc">
                                            <xsl:apply-templates select="$v_teiHeader/tei:fileDesc/tei:titleStmt"/>
                                            <xsl:apply-templates select="$v_teiHeader/tei:fileDesc/tei:publicationStmt"/>
                                            <xsl:element name="tei:sourceDesc">
                                                <xsl:element name="tei:biblStruct">
                                                    <xsl:attribute name="xml:lang" select="'ar'"/>
                                                    <xsl:element name="tei:monogr">
                                                        <xsl:apply-templates select="$v_sourceDesc/tei:title"/>
                                                        <xsl:apply-templates select="$v_sourceDesc/tei:idno"/>
                                                        <xsl:apply-templates select="$v_sourceDesc/tei:textLang"/>
                                                        <xsl:apply-templates select="$v_sourceDesc/tei:editor"/>
                                                        <xsl:apply-templates select="$v_sourceDesc/tei:imprint"/>
                                                        <!-\- volume and issue information -\->
                                                        <xsl:element name="tei:biblScope">
                                                            <xsl:attribute name="unit" select="'volume'"/>
                                                            <xsl:attribute name="from" select="$v_volume"/>
                                                            <xsl:attribute name="to" select="$v_volume"/>
                                                            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                                                            <xsl:value-of select="$v_volume"/>
                                                        </xsl:element>
                                                        <xsl:element name="tei:biblScope">
                                                            <xsl:attribute name="unit" select="'issue'"/>
                                                            <xsl:attribute name="from" select="$v_issue"/>
                                                            <xsl:attribute name="to" select="$v_issue"/>
                                                            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                                                            <xsl:value-of select="$v_issue"/>
                                                        </xsl:element>
                                                        <xsl:element name="tei:biblScope">
                                                            <xsl:attribute name="unit" select="'page'"/>
                                                            <xsl:attribute name="from"/>
                                                            <xsl:attribute name="to"/>
                                                        </xsl:element>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:apply-templates select="$v_teiHeader/tei:revisionDesc"/>
                                    </xsl:element>
                                    <xsl:element name="tei:text">
                                        <xsl:attribute name="xml:lang" select="'ar'"/>
                                        <!-\- add the preceding <pb/>-\->
                                        <xsl:copy-of select="preceding::tei:pb[1]"/>
                                        <xsl:element name="tei:body">
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:result-document>
                        </xsl:for-each-group>
                    </xsl:for-each-group>-->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each-group group-starting-with="self::tei:div[matches(tei:head, 'العدد\s*\d+')]" select="tei:div">
                        <xsl:variable name="v_issue" select="replace(tei:head, 'العدد\s*(\d+)', '$1')"/>
                        <xsl:result-document href="_output/issues/oclc_{$v_id-oclc}-i_{$v_issue}.TEIP5.xml">
                            <xsl:element name="tei:TEI">
                                <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader"/>
                                <xsl:element name="tei:text">
                                    <xsl:attribute name="xml:lang" select="'ar'"/>
                                    <!-- add the preceding <pb/>-->
                                    <xsl:copy-of select="preceding::tei:pb[1]"/>
                                    <xsl:element name="tei:body">
                                        <xsl:apply-templates select="current-group()"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:result-document>
                    </xsl:for-each-group>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:div[@type = 'issue']">
        <xsl:variable name="v_volume" select="parent::tei:div[@type = 'volume']/@n"/>
        <xsl:variable name="v_issue" select="count(preceding-sibling::tei:div[@type = 'issue']) + 1"/>
        <xsl:result-document href="_output/issues/oclc_{$v_id-oclc}-v_{$v_volume}-i_{$v_issue}.TEIP5.xml">
            <xsl:element name="tei:TEI">
                <!-- construct metadata -->
                <xsl:element name="tei:teiHeader">
                    <xsl:element name="tei:fileDesc">
                        <xsl:apply-templates select="$v_teiHeader/tei:fileDesc/tei:titleStmt"/>
                        <xsl:apply-templates select="$v_teiHeader/tei:fileDesc/tei:publicationStmt"/>
                        <xsl:element name="tei:sourceDesc">
                            <xsl:element name="tei:biblStruct">
                                <xsl:attribute name="xml:lang" select="'ar'"/>
                                <xsl:element name="tei:monogr">
                                    <xsl:apply-templates select="$v_sourceDesc/tei:monogr/tei:title"/>
                                    <xsl:apply-templates select="$v_sourceDesc/tei:monogr/tei:idno"/>
                                    <xsl:apply-templates select="$v_sourceDesc/tei:monogr/tei:textLang"/>
                                    <xsl:apply-templates select="$v_sourceDesc/tei:monogr/tei:editor"/>
                                    <xsl:apply-templates select="$v_sourceDesc/tei:monogr/tei:imprint"/>
                                    <!-- volume and issue information -->
                                    <xsl:element name="tei:biblScope">
                                        <xsl:attribute name="unit" select="'volume'"/>
                                        <xsl:attribute name="from" select="$v_volume"/>
                                        <xsl:attribute name="to" select="$v_volume"/>
                                        <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                                        <xsl:value-of select="$v_volume"/>
                                    </xsl:element>
                                    <xsl:element name="tei:biblScope">
                                        <xsl:attribute name="unit" select="'issue'"/>
                                        <xsl:attribute name="from" select="$v_issue"/>
                                        <xsl:attribute name="to" select="$v_issue"/>
                                        <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                                        <xsl:value-of select="$v_issue"/>
                                    </xsl:element>
                                    <xsl:element name="tei:biblScope">
                                        <xsl:attribute name="unit" select="'page'"/>
                                        <xsl:attribute name="from"/>
                                        <xsl:attribute name="to"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:apply-templates select="$v_teiHeader/tei:revisionDesc"/>
                </xsl:element>
                <xsl:element name="tei:text">
                    <xsl:attribute name="xml:lang" select="'ar'"/>
                    <!-- add the preceding <pb/>-->
                    <xsl:copy-of select="preceding::tei:pb[1]"/>
                    <xsl:element name="tei:body">
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    <!-- documentation of changes -->
    <xsl:template match="tei:revisionDesc" priority="100">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="change">
                <xsl:attribute name="when" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#', $p_editor/descendant-or-self::tei:respStmt[1]/tei:persName/@xml:id)"/>
                <xsl:attribute name="xml:id" select="$p_id-change"/>
                <xsl:attribute name="xml:lang" select="'en'"/>
                <xsl:text>Grouped divs along the presence of </xsl:text>
                <tei:gi xml:lang="en">head</tei:gi>
                <xsl:text>of &quot;العدد\s*\d+&quot; that indicate the beginning of a new journal issue into ...</xsl:text>
                <tei:gi xml:lang="en">tei:p</tei:gi>
                <xsl:text>s.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>