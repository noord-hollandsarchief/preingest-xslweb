<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:nha="http://noord-hollandsarchief.nl/namespaces/1.0"
    exclude-result-prefixes="#all"
    expand-text="yes"
    version="3.0">

    <!--
      This very file must be imported by any fix that can be selected for pre-wash transformations, to ensure that the
      XSLWeb HTTP request parameters are handled, and to ensure that the source XML is copied as is before any fixes
      are applied.
    -->

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:param name="data-uri-prefix" as="xs:string" required="yes"/>
    <xsl:param name="prewash-stylesheet" as="xs:string" select="''"/>

    <xsl:template match="/">
        <xsl:try>
            <xsl:variable name="reluri" as="xs:string" select="replace(/*/req:path, '^/[^/]+/(.*)$', '$1')"/>
            <xsl:call-template name="nha:prewash">
                <xsl:with-param name="absuri" select="$data-uri-prefix || encode-for-uri($reluri)"/>
            </xsl:call-template>
            <xsl:catch>
                <nha:error code="{$err:code}" description="{$err:description}" module="{$err:module}" line-number="{$err:line-number}"/>
            </xsl:catch>
        </xsl:try>
    </xsl:template>
    
    <xsl:template name="nha:prewash">
        <xsl:param name="absuri" as="xs:string" required="yes"/>

        <xsl:variable name="topxDoc" as="document-node()" select="doc($absuri)"/>

        <!-- Despite this comment, there may be no changes at all -->
        <xsl:comment>Document processed by pre-wash stylesheet "{$prewash-stylesheet}" on {current-dateTime()}</xsl:comment>
        <!-- Preserve previous pre-wash comments when running multiple pre-wash transformations -->
        <xsl:copy-of select="$topxDoc/comment()" />
        <xsl:apply-templates select="$topxDoc/*"/>
    </xsl:template>
</xsl:stylesheet>
