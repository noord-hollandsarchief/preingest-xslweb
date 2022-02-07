<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.openpreservationexchange.org/opex/v1.0"
 xmlns:x="http://www.openpreservationexchange.org/opex/v1.0"
 xmlns:t="http://www.nationaalarchief.nl/ToPX/v2.3"
 exclude-result-prefixes="x t">
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

	<xsl:template match="x:SourceID">
		<xsl:choose>
			<xsl:when test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie">
				<SourceID><xsl:value-of select="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie/t:identificatiekenmerk/text()"/></SourceID>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="x:Title">
		<xsl:choose>
			<xsl:when test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:bestand">
				<Title><xsl:value-of select="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:bestand/t:naam/text()"/></Title>
			</xsl:when>
			<xsl:when test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie">
				<Title><xsl:value-of select="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie/t:naam/text()"/></Title>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="x:Description">
		<xsl:choose>
			<xsl:when test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:bestand">
				<Description><xsl:value-of select="concat(/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:bestand/t:aggregatieniveau/text(), ' met identificatiekenmerk ', /x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:bestand/t:identificatiekenmerk/text(), ' : ', .)"/></Description>
			</xsl:when>
			<xsl:when test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie">
				<Description><xsl:value-of select="concat(/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie/t:aggregatieniveau/text(), ' met identificatiekenmerk ', /x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie/t:identificatiekenmerk/text(), ' : ', .)"/></Description>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
		<xsl:template match="x:SecurityDescriptor">
		<xsl:choose>
			<xsl:when test="/x:OPEXMetadata/x:DescriptiveMetadata/t:ToPX/t:aggregatie">
				<SecurityDescriptor>open</SecurityDescriptor>
			</xsl:when>
			<!--
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
			-->
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>

