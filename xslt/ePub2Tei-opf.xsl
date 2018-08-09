<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:opf="http://www.idpf.org/2007/opf" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet will transform an ePub from shamela.ws to TEI P5. Input is the core opf file. In order to make everything work, it makes sense to un-zip the ePub and check whether all the contained xhtml files are well-formed XML. The main problem are unescaped ampersands.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
    <xsl:include href="ePub2Tei-pages.xsl"/>
    
    <!-- provides some global parameters -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>
 
    <!-- the templates -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="opf:package">
        <xsl:result-document
            href="{translate(child::opf:metadata/dc:identifier[@opf:scheme='UUID'],':','-')}.TEIP5.xml">
            <TEI>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>
                                <xsl:value-of select="child::opf:metadata/dc:title"/>
                            </title>
                            <title type="sub">TEI edition</title>
                            <author>
                                <xsl:value-of
                                    select="child::opf:metadata/dc:creator[@opf:role = 'aut']"/>
                            </author>
                            <xsl:copy-of select="$p_editor"/>
                        </titleStmt>
                        <publicationStmt>
                            <p>Unpulished TEI edition</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>
                                <xsl:copy-of select="child::opf:metadata/child::node()"/>
                            </p>
                        </sourceDesc>
                    </fileDesc>
                    <revisionDesc>
                        <change>
                            <xsl:attribute name="when"
                                select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                            <xsl:attribute name="who" select="concat('#', $p_editor/descendant-or-self::tei:respStmt[1]/tei:persName/@xml:id)"/>
                            <xsl:attribute name="xml:id" select="$p_id-change"/>
                            <xsl:attribute name="xml:lang" select="'en'"/>
                            <xsl:text>Created this TEI P5 file by automatic conversion from ePub.</xsl:text>
                        </change>
                    </revisionDesc>
                </teiHeader>
                <text>
                    <body>
                        <div>
                            <xsl:for-each
                                select="opf:manifest/opf:item[@media-type = 'application/xhtml+xml'][starts-with(@id, 'P')]">
                                <xsl:apply-templates
                                    select="doc(concat(substring-before(base-uri(), 'content.opf'), @href))/descendant::html:div[@id = 'book-container']"
                                />
                            </xsl:for-each>
                        </div>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
