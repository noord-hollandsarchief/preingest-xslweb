<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:topx="http://www.nationaalarchief.nl/ToPX/v2.3"
    xpath-default-namespace="http://www.nationaalarchief.nl/ToPX/v2.3"
    xmlns="http://www.nationaalarchief.nl/ToPX/v2.3"
    exclude-result-prefixes="#all"
    expand-text="yes"
    version="3.0">

    <xsl:import href="_prewash-identity-transform.xslt"/>

    <!--
      OBSOLETE: Ensure ToPX `<naam>` does not exceed the Preservica limit of 255 characters for XIP `title`.

      Until April 16 2021, there was a maximum length in some Preservica database, throwing PRES_CREATESTRUCT_00
      during ingest. This was resolved in 6.3.0 (ticket #10766), so: THIS FIX SHOULD NO LONGER BE NEEDED. If some
      limit still applies then one better restore the fix in topx2xip.xslt as that would not change the original
      ToPX values, which this prewash does.
    -->

    <!-- The maximum size of a Title in XIP: -->
    <xsl:param name="max-length-of-title" as="xs:integer" select="255"/>

    <xsl:template match="topx:naam">
        <xsl:variable name="text" select="." as="xs:string"/>
        <xsl:choose>
            <xsl:when test="string-length($text) le $max-length-of-title">
                <naam><xsl:value-of select="$text"/></naam>
            </xsl:when>
            <xsl:otherwise>
                <!-- Shorten the title by taking the first and the last part and inserting " ... " in between. -->
                <xsl:variable name="ellipsisstring" as="xs:string" select="' ... '"/>
                <xsl:variable name="half-max-length-of-title" as="xs:integer" select="xs:integer($max-length-of-title div 2)"/>
                <xsl:variable name="part1-end-offst" as="xs:integer" select="$half-max-length-of-title - string-length($ellipsisstring) - 1"/>
                <xsl:variable name="part2-start-offset" as="xs:integer" select="string-length($text) - $half-max-length-of-title"/>

                <xsl:variable name="part1" as="xs:string" select="substring($text, 1, $part1-end-offst)"/>
                <xsl:variable name="part2" as="xs:string" select="substring($text, $part2-start-offset)"/>

                <xsl:comment>ToPX.naam truncated; original value: {$text}</xsl:comment>
                <naam><xsl:value-of select="$part1 || $ellipsisstring || $part2"/> </naam>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
