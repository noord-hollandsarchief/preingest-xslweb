<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		queryBinding="xslt2">
		
    <ns uri="https://www.nationaalarchief.nl/mdto" prefix="mdto"/>
	<pattern>
		<rule context="mdto:informatieobject">
			<assert test="count(mdto:aggregatieniveau) = 1">Element "aggregatieniveau" niet gevonden in MDTO-metadata</assert>
			
			<assert test="matches(mdto:aggregatieniveau/mdto:begripLabel, '^(Archief|Serie|Dossier|Zaak|Archiefstuk)$')">De waarde van het "begripLabel"-gegeven in de MDTO-metadata is niet Archief, Serie, Dossier, Zaak of Archiefstuk maar "<value-of select="mdto:aggregatieniveau/mdto:begripLabel"/>"</assert>
			
			<assert test="count(mdto:beperkingGebruik) = 1">Element "beperkingGebruik" niet gevonden in MDTO-metadata</assert>
		</rule>
	</pattern>
	
	<pattern>
		<rule context="mdto:informatieobject">
			<assert test="count(mdto:beperkingGebruik/mdto:beperkingGebruikType/mdto:begripLabel) = 1 and count(mdto:beperkingGebruik/mdto:beperkingGebruikType/mdto:begripCode) = 1">Element "begripCode" niet gevonden in MDTO-metadata. Element wordt wel verwacht/vereist naast "begripLabel"</assert>
		</rule>
	</pattern>
	
		<pattern>
		<rule context="mdto:informatieobject/mdto:beperkingGebruik/mdto:beperkingGebruikType">
			<assert test="(mdto:begripCode = 'Openbaarheid/AW1995/BeperktOpenbaar-levenssfeer/1.0' and ./mdto:begripLabel = 'beperkt openbaar; eerbiediging van de persoonlijke levenssfeer (Archiefwet 1995)') or
			(mdto:begripCode = 'Openbaarheid/AW1995/BeperktOpenbaar-staatsbelang/1.0' and ./mdto:begripLabel = 'beperkt openbaar; staatsbelang (Archiefwet 1995)') or
			(mdto:begripCode = 'Openbaarheid/AW1995/BeperktOpenbaar-benadeling/1.0' and ./mdto:begripLabel = 'beperkt openbaar; onevenredige bevoordeling of benadeling (Archiefwet 1995)') or
			(mdto:begripCode = 'Openbaarheid/AW1995/BeperktOpenbaar-bijzonderePersoonsgegevens/1.0' and ./mdto:begripLabel = 'beperkt openbaar; bijzondere persoonsgegevens en/of persoonsgegevens van strafrechtelijke aard (Archiefwet 1995)') or
			(mdto:begripCode = 'Openbaarheid/AW1995/BeperktOpenbaar-particulier/1.0' and ./mdto:begripLabel = 'beperkt openbaar; contractuele afspraken met archiefvormer (Archiefwet 1995)') or
			(mdto:begripCode = 'Openbaarheid/AW1995/Openbaar/1.0' and ./mdto:begripLabel = 'openbaar (Archiefwet 1995)') or
			(mdto:begripCode = 'Openbaarheid/AW1995/Openbaar-milieu/1.0' and ./mdto:begripLabel = 'openbaar; mileu-informatie (Archiefwet 1995)') or
			(mdto:begripCode = 'Openbaarheid/AW1995/NietBeoordeeld/1.0' and ./mdto:begripLabel = 'openbaarheid niet beoordeeld (Archiefwet 1995)')">Combinatie begripCode en begripLabel niet gevonden uit de begrippenlijst Openbaarheid – Archiefwet 1995: Code="<value-of select="./mdto:begripCode"/>" en label="<value-of select="./mdto:begripLabel"/>"</assert>
		</rule>
	</pattern>
	
	<pattern>
		<rule context="mdto:bestand">
			<assert test="count(mdto:checksum) = 1">Element "checksumGegevens" niet gevonden in MDTO-metadata</assert>
			<assert test="matches(mdto:checksum/mdto:checksumAlgoritme/mdto:begripLabel, '^(SHA-224|SHA-384|SHA-256|SHA-512)$')">De waarde van het "checksumAlgoritme"-gegeven in de MDTO-metadata is niet SHA224, SHA384, SHA256, of SHA512 maar "<value-of select="mdto:checksum/mdto:checksumAlgoritme/mdto:begripLabel"/>"</assert>
			<assert test="string-length(mdto:checksum/mdto:checksumWaarde) &gt; 0">De waarde van het "checksumWaarde"-gegeven in de MDTO-metadata is leeg</assert>
		</rule>
	</pattern>
</schema>