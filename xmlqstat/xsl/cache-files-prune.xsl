<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
<!ENTITY  newline "<xsl:text>&#x0a;</xsl:text>">
<!ENTITY  space   "<xsl:text> </xsl:text>">
<!ENTITY  nbsp    "&#xa0;">
]>
<xsl:stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
>
<!--
   | process output from a directory generator:
   | In Apache Cocoon
   |   <map:generate type="directory"  src=".">
   |       <map:parameter name="depth" value="2"/>
   |   </map:generate>
   |
   | * keep /^cache(-.+)?$/ directories
   | * keep /^*\.xml$/  files
   -->

<!-- ======================= Imports / Includes =========================== -->
<!-- Include processor-instruction parsing -->
<xsl:include href="pi-param.xsl"/>

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="dir">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'dir'"/>
    <xsl:with-param  name="default" select="/dir:directory/@name"/>
  </xsl:call-template>
</xsl:param>

<!-- ======================= Internal Parameters ========================== -->
<!-- NONE -->

<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>

<!-- ============================ Matching ================================ -->

<!-- Identity transform -->
<xsl:template match="node() | @*">
  <xsl:copy>
    <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
</xsl:template>

<!-- Copy through for misc directories (fallback) -->
<xsl:template match="//dir:directory[@name != $dir]">
  <xsl:copy>
    <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
</xsl:template>

<!-- special filtering for top-level directory -->
<xsl:template match="//dir:directory[@name = $dir]">
  <xsl:copy>
    <xsl:apply-templates
      select="*[@name = 'cache' or substring-before(@name, '-') = 'cache']"
    />
  </xsl:copy>
</xsl:template>

<!-- generally ignore dir:file entries -->
<xsl:template match="dir:file"/>

<!-- but copy through *.xml files -->
<xsl:template match="//dir:file[
    contains(@name, '.xml') and
    not(string-length(substring-after(@name, '.xml')))
    ]">
  <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
