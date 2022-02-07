<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.nationaalarchief.nl/ToPX/v2.3"
                xmlns="http://www.nationaalarchief.nl/ToPX/v2.3"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">

    <!--
      This stylesheet fixes errors in the sidecar metadata of the Statenvragen of the Provincie Noord-Holland.
    -->

    <!-- In this case, this is actually also imported by all common fixes below -->
    <xsl:import href="_prewash-identity-transform.xslt"/>

    <!-- Common fixes; note that this may require URL percent-encoding for file names, such as `%20` for spaces -->
    <xsl:import href="fix_toegang.xslt"/>

    <!-- Temporarily fix empty <begin><jaar> in:

        <dekking>
            <inTijd>
                <begin>
                    <jaar />
                </begin>
                <eind>
                    <jaar>2020</jaar>
                </eind>
            </inTijd>
            <geografischGebied />
        </dekking>
    -->
    <xsl:template match="begin/jaar[not(string(.))]">
        <jaar>9999</jaar>
    </xsl:template>

    <!-- Temporarily fix empty <identificatiekenmerk> and <geautoriseerdeNaam>, and invalid value for <aggregatieniveau> in:

        <actor>
            <identificatiekenmerk />
            <aggregatieniveau>Verantwoordelijke ambtenaarN</aggregatieniveau>
            <geautoriseerdeNaam />
            <plaats />
            <jurisdictie />
        </actor>
    -->
    <xsl:template match="actor/identificatiekenmerk[not(string(.))]">
        <identificatiekenmerk>TODO actor identificatiekenmerk</identificatiekenmerk>
    </xsl:template>
    <xsl:template match="actor/aggregatieniveau[. eq 'Verantwoordelijke ambtenaarN']">
        <aggregatieniveau>Verantwoordelijke ambtenaar</aggregatieniveau>
    </xsl:template>
    <xsl:template match="actor/geautoriseerdeNaam[not(string(.))]">
        <geautoriseerdeNaam>TODO actor geautoriseerdeNaam</geautoriseerdeNaam>
    </xsl:template>

    <!-- Temporarily fix empty <nummerBinnenSysteem> in:

        <externIdentificatiekenmerk>
            <kenmerkSysteem />
            <nummerBinnenSysteem />
        </externIdentificatiekenmerk>
    -->
    <xsl:template match="nummerBinnenSysteem[not(string(.))]">
        <nummerBinnenSysteem>9999</nummerBinnenSysteem>
    </xsl:template>

    <!-- On the archive level, the name may have a missing dash in "Noord-Holland".

      Make sure to match for `aggregatie/naam`, not for its child text node-set `aggregatie/naam/text()`, as the fix for
      newlines below will not call apply-templates for its (converted) child text node.
    -->
    <xsl:template match="aggregatie/naam[../aggregatieniveau eq 'Archief' and . eq 'Provincie Noord Holland']">
        <naam>Provincie Noord-Holland</naam>
    </xsl:template>

    <!-- Remove newlines in <naam> (which may still be too long for ToPX though okay for XIP/Preservica):

        <naam>Schriftelijke statenvragen nummer 116 2018 van mw Vermaas en dhr van Liere (partij voor de dieren) J. de Groot (SP) en F Kramer (groen links) inzake voorstel unie van waterschappen tot verhoging belasting natuurbeheerder



        en Kramer Groen links
        inzake voorstel Unie van Waterschappen tot verhoging belastingnatuurbeheer</naam>
    -->
    <xsl:template match="naam">
        <naam><xsl:value-of select="normalize-space(.)"/></naam>
    </xsl:template>

</xsl:stylesheet>
