<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.openpreservationexchange.org/opex/v1.0"
 xmlns:x="http://www.openpreservationexchange.org/opex/v1.0"
 exclude-result-prefixes="">
	<xsl:output method="xml"
	version="1.0"
	encoding="UTF-8"
	indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>	
	
	<xsl:template match="x:SecurityDescriptor">
		<SecurityDescriptor>open</SecurityDescriptor>
	</xsl:template>

</xsl:stylesheet>

