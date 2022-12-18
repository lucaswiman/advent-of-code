<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:ext="http://exslt.org/common" exclude-result-prefixes="ext">
<!-- https://stackoverflow.com/questions/12760249/reapplying-templates-to-output-of-other-templates-in-xslt -->
 <!-- <xsl:output omit-xml-declaration="yes" indent="yes"/>
 <xsl:strip-space elements="*"/> -->

 <xsl:template match="@*|node()" name="identity">
   <xsl:copy>
     <xsl:apply-templates select="@*|node()" />
   </xsl:copy>
 </xsl:template>

 <xsl:template match="/">
  <xsl:variable name="vrtfPass1">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:variable name="vPass1" select="ext:node-set($vrtfPass1)/*"/>

  <xsl:apply-templates select="$vPass1" mode="pass2"/>
 </xsl:template>

 <xsl:template match="content">
   <wrapper>
     <replace />
     <xsl:apply-templates select="@*|node()" />
   </wrapper>
 </xsl:template>

 <xsl:template match="replace">
  <xsl:text>&#xA;Hello world&#xA;</xsl:text>
 </xsl:template>

 <xsl:template match="@*|node()" mode="pass2">
  <xsl:call-template name="identity"/>
 </xsl:template>
</xsl:stylesheet>