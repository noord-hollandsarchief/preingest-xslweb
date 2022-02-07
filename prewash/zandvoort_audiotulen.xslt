<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:log="http://www.armatiek.com/xslweb/functions/log"
                xmlns:req="http://www.armatiek.com/xslweb/request"
                xmlns:nha="http://noord-hollandsarchief.nl/namespaces/1.0"
                xpath-default-namespace="http://www.nationaalarchief.nl/ToPX/v2.3"
                xmlns="http://www.nationaalarchief.nl/ToPX/v2.3"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">

    <!--
        Enhance the September 2019 ToPX metadata for the Gemeente Zandvoort meeting recordings to match the 2021
        expectations, and add the missing sidecar metadata files for "Record", assuming each folder like `0175`
        holds at most one non-metadata file:

            ├── 1498
            │  :
            │  ├── 1075
            │  │   ├── NL-HlmNHA_1498_1075.wav
            │  │   └── NL-HlmNHA_1498_1075.wav.metadata
            │  ├── 1076
            │  │   ├── NL-HlmNHA_1498_1076.wav
            │  │   └── NL-HlmNHA_1498_1076.wav.metadata
            │  ├── ...
            │  :
            │  └── 1498.metadata

        NOTE: THIS WILL ONLY WORK ON FIRST RUN, as this removes "openbaarheid" for files, which is needed for Record.

        NOTE: for regular transformations, the pre-wash does not write the results to disk itself. Instead, although it
        does read the current contents from disk, it only returns the result as text, leaving it up to the caller (the
        orchestrating API) to overwrite the original file. However, the missing metadata for "Record" is written to disk
        by this pre-wash transformation directly. This is acceptable for this very fix, but very much relies on the
        caller to get a fresh list of files for any subsequent processing. NOT RECOMMENDED for regular use.
    -->

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- In this case, this is actually also imported by all common fixes below -->
    <xsl:import href="_prewash-identity-transform.xslt"/>

    <!-- Common fixes -->
    <xsl:import href="fix_algoritme.xslt"/>
    <xsl:import href="fix_toegang.xslt"/>

    <!-- Override 'gedeeltelijk openbaar' on root level (which otherwise is mapped to 'publiek_metadata' in the import above) -->
    <xsl:template match="aggregatie[aggregatieniveau eq 'Archief']/openbaarheid/omschrijvingBeperkingen/text()">
        <xsl:choose>
            <!-- September 2019 Audiotulen Zandvoort, at root level; other levels use a mix of 'Openbaar' and 'Beperkt openbaar' -->
            <xsl:when test="lower-case(.) eq 'gedeeltelijk openbaar'">publiek</xsl:when>
            <xsl:otherwise>{.}</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        /*/req:path yields something like transform/prewash/0ee4629b-3394-6986-b859-430c0256ecd1/path/to/name.metadata
        (without any ?prewash=prewash-stylesheet query parameter). Get the full base path (with trailing slash, without
        file name) from that (which is somewhere in /data), and get the name of the current folder.
    -->
    <xsl:variable name="basepath" as="xs:string" select="$data-uri-prefix || replace(/*/req:path, '^/[^/]+/(.*/)[^/]+$', '$1')"/>
    <xsl:variable name="foldername" as="xs:string" select="replace($basepath, '^.*/([^/]*)/$', '$1')"/>

    <xsl:template match="bestand">
        <!-- First, for the file, duplicate the full input except for "openbaarheid" which we do not support for files -->
        <xsl:copy>
             <!-- Use apply-templates rather than copy-of to ensure common fixes are applied too -->
             <xsl:apply-templates select="@* | node()[not(self::openbaarheid)]"/>
        </xsl:copy>

        <!-- Next, create a sidecar file for the parent "Record". See notes above about writing this to disk. -->
        <xsl:variable name="foldermetadatafilename" as="xs:string" select="$basepath || $foldername || '.metadata'"/>

        <xsl:choose>
            <xsl:when test="doc-available($foldermetadatafilename)">
                <xsl:variable name="errormessage" as="xs:string" select="'Metadata file for folder already exists: ' || $foldermetadatafilename"/>
                <xsl:sequence select="log:log('ERROR', $errormessage)"/>
                <xsl:sequence select="error(xs:QName('nha:invalide-prewash-stylesheet'), $errormessage)"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:sequence select="log:log('INFO', 'Creating new metadata file for folder: ' || $foldermetadatafilename)"/>
                <xsl:result-document method="xml" href="{ $foldermetadatafilename }">
                    <xsl:comment>Document created by pre-wash stylesheet "{$prewash-stylesheet}" on {current-dateTime()}</xsl:comment>
                    <ToPX xmlns="http://www.nationaalarchief.nl/ToPX/v2.3">
                        <aggregatie>
                            <identificatiekenmerk>{ $foldername }</identificatiekenmerk>
                            <aggregatieniveau>Record</aggregatieniveau>
                            <xsl:apply-templates select="naam"/>
                            <xsl:apply-templates select="dekking"/>
                            <!-- Will only work on first run; for subsequent runs, "openbaarheid" will have been removed from the source -->
                            <xsl:apply-templates select="openbaarheid"/>
                        </aggregatie>
                    </ToPX>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>