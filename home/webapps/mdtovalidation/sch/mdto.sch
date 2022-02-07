<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		queryBinding="xslt2">
		
    <ns uri="https://www.nationaalarchief.nl/mdto" prefix="mdto"/>
	
	<!--
    <pattern id="mdto-pattern-1">
        <rule context="mdto:informatieobject">
            <p>Controleer of er precies één element "identificatie" is (dus niet 0 of meer dan 1)</p>
			<report test="count(mdto:trefwoord) eq 2">Er is meer dan één "identificatie"-gegeven in de MDTO-metadata</report>
		</rule>
    </pattern>
	<pattern id="topx-pattern-4">
        <rule context="topx:algoritme">
			<assert test="@*[local-name() = local-name(..)] = local-name()">The value of the attribute @<value-of select="local-name()"/> of element <value-of select="local-name()"/> is not equal to <value-of select="local-name()"/>.</assert>          
        </rule>
    </pattern>
	-->
	<pattern>
		<rule context="mdto:checksumGegevens">
			<assert test="count(.) eq 0">Element "checksumGegevens" niet gevonden in MDTO-metadata</assert>
			<assert test="matches(mdto:checksumAlgoritme, '^(SHA224|SHA384|SHA256|SHA512)$')">De waarde van het "checksumAlgoritme"-gegeven in de MDTO-metadata is niet MD5, SHA1, SHA256, of SHA512 maar "<value-of select="."/>"</assert>
			<assert test="string-length(mdto:checksumWaarde) eq 0">De waarde van het "checksumWaarde"-gegeven in de MDTO-metadata is leeg</assert>
		</rule>
	</pattern>
</schema>