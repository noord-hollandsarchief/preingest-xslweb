<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.nationaalarchief.nl/ToPX/v2.3"
    xmlns="http://www.nationaalarchief.nl/ToPX/v2.3"
    exclude-result-prefixes="#all"
    expand-text="yes"
    version="3.0">

    <xsl:import href="_prewash-identity-transform.xslt"/>

    <!--
      Remove leading and trailing non-digits in ToPX `<omvang>`, such as a trailing ` bytes`.

      NOTE: one may want to be more specific, like to only expect/remove `bytes` but not units like `kB` or `MB`.
    -->
    <xsl:template match="bestand/formaat/omvang">
        <omvang>
            <xsl:value-of select="replace(., '^\D*(\d+)\D*$', '$1')"/>
        </omvang>
    </xsl:template>

</xsl:stylesheet>
