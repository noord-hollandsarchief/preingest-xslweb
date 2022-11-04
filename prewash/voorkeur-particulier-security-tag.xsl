<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="http://www.openpreservationexchange.org/opex/v1.0" xmlns:t="http://www.nationaalarchief.nl/ToPX/v2.3" xmlns:m="https://www.nationaalarchief.nl/mdto" exclude-result-prefixes="x t m" xmlns="http://www.openpreservationexchange.org/opex/v1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="x:SecurityDescriptor">
		<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
		<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
		<xsl:choose>
			<xsl:when test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie/t:openbaarheid/t:omschrijvingBeperkingen[translate(., $uppercase, $lowercase)='openbaar']">
				<xsl:if test="not(/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie/t:gebruiksrechten/t:omschrijvingVoorwaarden[translate(., $uppercase, $lowercase)='studiezaal'])">
					<SecurityDescriptor>
						<xsl:text>TAG_particulier_publiek</xsl:text>
					</SecurityDescriptor>
				</xsl:if>
				<xsl:if test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie/t:gebruiksrechten/t:omschrijvingVoorwaarden[translate(., $uppercase, $lowercase)='studiezaal']">
					<SecurityDescriptor>
						<xsl:text>TAG_particulier_publiek_studiezaal</xsl:text>
					</SecurityDescriptor>
				</xsl:if>
			</xsl:when>
			<xsl:when test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie/t:openbaarheid/t:omschrijvingBeperkingen[translate(., $uppercase, $lowercase)='niet openbaar']">
				<SecurityDescriptor>
					<xsl:text>TAG_particulier_publiek_metadata</xsl:text>
				</SecurityDescriptor>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
