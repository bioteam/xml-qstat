<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
<!ENTITY  newline "<xsl:text>&#x0a;</xsl:text>">
<!ENTITY  space   "<xsl:text> </xsl:text>">
<!ENTITY  nbsp    "&#xa0;">
]>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
>
<!--
   | process output from a directory generator to create a list of hyperlinks
   |
   | expected input:
   | Apache-style Directory listing
   -->

<!-- ======================= Imports / Includes =========================== -->
<!-- Include our masthead -->
<xsl:include href="xmlqstat-masthead.xsl"/>
<!-- Include processor-instruction parsing -->
<xsl:include href="pi-param.xsl"/>


<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="dir">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'dir'"/>
    <xsl:with-param  name="default" select="/dir:directory/@name"/>
  </xsl:call-template>
</xsl:param>
<xsl:param name="prefix">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'prefix'"/>
    <xsl:with-param  name="default" select="$dir"/>
  </xsl:call-template>
</xsl:param>


<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/" >
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  &newline;
  <link rel="icon" type="image/png" href="css/screen/icons/folder.png"/>
  <link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
  &newline;
  <title>dir - <xsl:value-of select="$dir"/></title>
  &newline;

  &newline;
  <!-- load css -->
  <link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
&newline;
</head>

<!-- begin body -->
<body>
&newline;
<div id="main">
<!-- Topomost Logo Div -->
<xsl:call-template name="topLogo"/>

<!-- Top Menu Bar -->
&newline;
<div id="menu">
  <img class="leftSpace rightSpace" src="css/screen/icons/folder.png"/>
  <strong><xsl:value-of select="$dir"/>/</strong>
</div>
&newline;

<ul>
  <xsl:choose>
  <xsl:when test="/dir:directory">
    <xsl:for-each select="/dir:directory">
      <!-- sort by name -->
      <xsl:sort select="@name"/>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <!--    <xsl:apply-templates select="/dir:directory" /> -->
  </xsl:when>
  <xsl:otherwise>
    <li>directory does not exist or is empty</li>
  </xsl:otherwise>
  </xsl:choose>
</ul>
</div>

&newline;
XSLT
<xsl:value-of select="format-number(number(system-property('xsl:version')), '0.0')" />
transformed by
<xsl:element name="a">
  <xsl:attribute name="href">
    <xsl:value-of select="system-property('xsl:vendor-url')"/>
  </xsl:attribute>
  <xsl:value-of select="system-property('xsl:vendor')"/>
</xsl:element>

&newline;

</body></html>
<!-- end body/html -->
</xsl:template>


<xsl:template match="/dir:directory">
  <xsl:for-each select="dir:file">
    <!-- sort by name -->
    <xsl:sort select="@name"/>
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:if test="$prefix"><xsl:value-of select="$prefix"/>/</xsl:if>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
      </xsl:element>
    </xsl:element>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
