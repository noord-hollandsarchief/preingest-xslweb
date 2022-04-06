<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
	<ns uri="http://www.nationaalarchief.nl/ToPX/v2.3" prefix="topx"/>
	<pattern id="topx-pattern-1a">
		<rule context="topx:aggregatie | topx:bestand">
			<p>Controleer of er precies één element "naam" is (dus niet 0 of meer dan 1)</p>
			<report test="count(topx:naam) eq 1">Er is geen of meer dan één "naam"-gegeven in de ToPX-metadata</report>
			<assert test="count(topx:naam) eq 1">Er is geen of meer dan één "naam"-gegeven in de ToPX-metadata</assert>
		</rule>
	</pattern>
	<!-- Niet van toepassing. Aangepast op verzoek Mark met instemming Lucas op 6-4-2022 om 16:19
	<pattern id="topx-pattern-1c">
		<rule context="topx:aggregatie | topx:bestand">
			<p>Controleer of er precies één element "omschrijving" is (dus niet 0 of meer dan 1)</p>
			<report test="count(topx:classificatie/topx:omschrijving) eq 1">Er is geen of meer dan één "classificatie/omschrijving"-gegeven in de ToPX-metadata</report>
			<assert test="count(topx:classificatie/topx:omschrijving) eq 1">Er is geen of meer dan één "classificatie/omschrijving"-gegeven in de ToPX-metadata</assert>
		</rule>
	</pattern>
	-->
	<pattern id="topx-pattern-2a">
		<rule context="topx:aggregatie">
			<p>Controleer of er precies één element "omschrijvingBeperkingen" is (dus niet 0 of meer dan 1)</p>
			<report test="count(topx:openbaarheid/topx:omschrijvingBeperkingen) eq 1">Er is geen of meer dan één "openbaarheid/omschrijvingBeperkingen"-gegeven in de ToPX-metadata</report>
			<p>Controleer de aanwezigheid van element "omschrijvingBeperkingen"</p>
			<assert test="count(topx:openbaarheid/topx:omschrijvingBeperkingen) eq 1">Er is geen of meer dan één "openbaarheid/omschrijvingBeperkingen"-gegeven in de ToPX-metadata</assert>
		</rule>
	</pattern>
	<!--
	<pattern id="topx-pattern-2b">
		<rule context="topx:bestand">
			<p>Controleer of er precies één element "algoritme" is (dus niet 0 of meer dan 1)</p>
			<report test="count(topx:formaat/topx:fysiekeIntegriteit/topx:algoritme) eq 0">Het "formaat/fysiekeIntegriteit/algoritme"-gegeven ontbreekt in de ToPX-metadata</report>
			<report test="count(topx:formaat/topx:fysiekeIntegriteit/topx:algoritme) gt 1">Er is meer dan één "formaat/fysiekeIntegriteit/algoritme"-gegeven in de ToPX-metadata</report>
			<p>Controleer of er precies één element "waarde" (behorend bij "algoritme") is (dus niet 0 of meer dan 1)</p>
			<report test="count(topx:formaat/topx:fysiekeIntegriteit/topx:waarde) eq 0">Het "formaat/fysiekeIntegriteit/waarde"-gegeven ontbreekt in de ToPX-metadata</report>
			<report test="count(topx:formaat/topx:fysiekeIntegriteit/topx:waarde) gt 1">Er is meer dan één "formaat/fysiekeIntegriteit/waarde"-gegeven in de ToPX-metadata</report>
			<p>Controleer of er niet sprake is van een openbaarheid element (with the disallowed omschrijvingBeperkingen inside it)</p>
			<assert test="empty(topx:openbaarheid/topx:omschrijvingBeperkingen)">Op bestandsniveau wordt het gegeven omschrijvingBeperkingen niet ondersteund</assert>
		</rule>
	</pattern>
	-->
	<pattern id="topx-pattern-2b">
		<rule context="topx:aggregatie/topx:openbaarheid/topx:omschrijvingBeperkingen">
			<p>Controleer de tekstuele inhoud van element "omschrijvingBeperkingen"</p>
			<assert test="matches(., '^(Openbaar|Niet openbaar|Beperkt openbaar)$')">De inhoud van het gegeven "omschrijvingBeperkingen" voldoet niet aan het vereiste patroon</assert>
		</rule>
	</pattern>
	<pattern id="topx-pattern-3">
		<rule context="topx:algoritme">
			<p>Controleer de tekstuele inhoud van element "algoritme"</p>
			<assert test="matches(., '^(MD5|SHA1|SHA256|SHA512|MD-5|SHA-1|SHA-256|SHA-512)$')">De waarde van het "algoritme"-gegeven in de ToPX-metadata is niet MD5, SHA1, SHA256, of SHA512 maar "
				<value-of select="."/>
				"
			</assert>
		</rule>
	</pattern>
</schema>
