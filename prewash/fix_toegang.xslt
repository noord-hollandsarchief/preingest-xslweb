<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.nationaalarchief.nl/ToPX/v2.3"
    xmlns="http://www.nationaalarchief.nl/ToPX/v2.3"
    exclude-result-prefixes="#all"
    expand-text="yes"
    version="3.0">

    <xsl:import href="_prewash-identity-transform.xslt"/>

    <!--
        Map old-style codes such as `Openbaar` to 2021 codes such as `publiek`, `publiek_metadata` and `intern`.

        As we do not support this for ToPX <bestand> we could limit to <aggregatie>. But if we need to copy details from
        <bestand> to <aggregatie> (like for the September 2019 Zandvoort audiotulen) we may need to be less strict, to
        apply fixes before/while copying.
    -->
    <xsl:template match="openbaarheid/omschrijvingBeperkingen/text()">
        <xsl:choose>
            <xsl:when test="lower-case(.) eq 'openbaar'">publiek</xsl:when>
            <xsl:when test="lower-case(.) eq 'beperkt openbaar'">publiek_metadata</xsl:when>
            <xsl:when test="lower-case(.) eq 'gedeeltelijk openbaar'">publiek_metadata</xsl:when>
            <xsl:otherwise>{.}</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
