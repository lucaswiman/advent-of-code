<!-- https://dnovatchev.wordpress.com/2007/11/09/wide-finder-in-xslt-deriving-new-requirements-for-efficiency-in-xslt-processors/ -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="3.0"
    expand-text="yes"
    xmlns:ext="http://exslt.org/common"
    exclude-result-prefixes="ext"
>

  <xsl:output method="xml" indent="yes"/>

  <!-- TODO: Apply https://stackoverflow.com/a/12762565/303931  for-each-group recursively to nest the directory structure -->
  <xsl:template match="@*|node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="/" mode="lex">
    <xsl:variable name="vLines"
      select="tokenize(unparsed-text('file:///app/example'),'\n')"
    />
    <xsl:for-each
      select="for $line in $vLines return $line"
    >
      <xsl:analyze-string select="." regex='^(\$?)\s*(ls|cd|\d+|dir)\s*(.*)$'>
        <xsl:matching-substring>
          <xsl:if test='regex-group(1)="$"' >
            <cmd>
              <xsl:attribute name="instruction">
                <xsl:value-of select="regex-group(2)" />
              </xsl:attribute>
              <xsl:if test='regex-group(2)="cd"'>
                <xsl:attribute name="dir">
                  <xsl:value-of select="regex-group(3)" />
                </xsl:attribute>
              </xsl:if>
            </cmd>
          </xsl:if>
          <xsl:if test='number(regex-group(2))=number(regex-group(2))'> <!-- number returns NaN for invalid values, which is not equal to itself -->
            <file>
              <xsl:attribute name="size">
                <xsl:value-of select="regex-group(2)" />
              </xsl:attribute>
              <xsl:attribute name="name">
                <xsl:value-of select="regex-group(3)" />
              </xsl:attribute>
            </file>
          </xsl:if>
          <xsl:if test='regex-group(2)="dir"'> <!-- These can be ignored, at least for part 1? -->
            <directory>
              <xsl:attribute name="name">
                <xsl:value-of select="regex-group(3)" />
              </xsl:attribute>
            </directory>
          </xsl:if>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="/">
    <xsl:variable name="vrtfPass1">
      <xsl:apply-templates mode="lex" select="." />
    </xsl:variable>

    <xsl:variable name="lexed" select="ext:node-set($vrtfPass1)/*"/>


    <!-- <xsl:value-of select="ext:node-set($lexed)/*"/>
    <xsl:value-of select="$lexed" /> -->
    <xsl:for-each-group select="$lexed" group-starting-with="cmd[@instruction = 'cd']" >
      <cmd-with-output>
        <xsl:for-each select="current-group()">
          <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
          </xsl:copy>
        </xsl:for-each>
      </cmd-with-output>
    </xsl:for-each-group>
  </xsl:template>


</xsl:stylesheet>
