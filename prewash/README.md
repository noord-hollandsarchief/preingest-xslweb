# Example pre-wash XSLT transformations

This folder holds some example XSLT files that can be used in pre-wash transformations. The frontend will fetch the list
of all available files, ignore anything that starts with an underscore or does not end with `.xslt`, and show a sorted
list without the `.xslt` extension and with all underscores replaced by spaces.

When using the [docker-compose.yml](../docker-compose.yml) file, see also the required environment variable to define
the location of the pre-wash XSLT files.

When the pre-wash transformations run, the orchestrating API gets the string result to write to disk. If a pre-wash
transformation needs to create files on disk itself, then it needs to specify the full path to avoid running into 
_"The system identifier of the principal output file is unknown"_. However, note that this relies on the orchestrating
API to get a fresh list of files for any subsequent processing, so the following is NOT RECOMMENDED for regular use:

```xml
<!--
    /*/req:path yields something like transform/prewash/0ee4629b-3394-6986-b859-430c0256ecd1/path/to/name.metadata
    (without any ?prewash=prewash-stylesheet query parameter). Get the full base path (with trailing slash, without
    file name) from that (which is somewhere in /data).
-->
<xsl:variable name="basepath" as="xs:string" 
              select="$data-uri-prefix || replace(/*/req:path, '^/[^/]+/(.*/)[^/]+$', '$1')"/>

...

<xsl:template match="...">
    <!--
        NOTE: for regular transformations, the pre-wash does not write the results to disk itself. Instead, although it
        does read the current contents from disk, it only returns the result as text, leaving it up to the caller (the
        orchestrating API) to overwrite the original file. However, below a new file is written to disk by this pre-wash
        transformation directly. This is acceptable for this very fix, but very much relies on the caller to get a fresh
        list of files for any subsequent processing. NOT RECOMMENDED for regular use.
    -->
    <xsl:result-document method="xml" href="{ $basepath || 'filename.xml' }">
        ...
    </xsl:result-document>
</xsl:template>
```

## Getting started with XSLT

An interactive tutorial: https://www.w3schools.com/xml/xsl_intro.asp

The above focuses on creating HTML; in our case we'll be transforming ToPX-formatted XML into a similar ToPX document.
Make sure to play around in the "Try it Yourself" editor for all examples.

A more in-depth summary: http://lenzconsulting.com/how-xslt-works/

### A few XSLT tips

- When adding elements, then if you want the output formatted to avoid not seeing changes due to very long lines:

  ```xml
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  ```

- Beware that `copy-of` will create an exact copy. If you expect other templates to match for the content you copied,
  then use `apply-templates` selecting the union of all attributes nodes (`@*` or `attribute::*`) and all other XML
  node types (`node()` or `child::node()`, for elements, text nodes, processing instructions and comments):

  ```xml
  <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
  ```

- Remember built-in rules: https://www.w3.org/TR/xslt-30/#built-in-rule

- Only a single template will be applied if multiple XSLT patterns match.

  See the priority rules in [the specification](https://www.w3.org/TR/xslt-30/#default-priority) and in Evan Lenz'
  blog post [How XSLT Works](http://lenzconsulting.com/how-xslt-works/#priority), which most importantly specify that
  any rule that includes any of the operators `/`, `//`, or `[]` has a higher default priority (0.5) over just
  specifying a single element name (default priority 0).

  Also, keep an eye on the logs for:

  > XTDE0540  Ambiguous rule match for ...

- When using `<xsl:stylesheet ... expand-text="yes">` you can use shorthand notation, like:

    - `{.}` for `<xsl:value-of select="."/>`
    - `{ ../aggregatieniveau/text() }` for `<xsl:value-of select="../aggregatieniveau/text()"/>`
