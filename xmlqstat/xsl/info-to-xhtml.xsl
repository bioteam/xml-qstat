<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
<!ENTITY  newline "<xsl:text>&#x0a;</xsl:text>">
<!ENTITY  space   "<xsl:text> </xsl:text>">
<!ENTITY  nbsp    "&#xa0;">
]>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!--
   |
   | documentation rendering for url path /info/
   |
   | expected input: xml/info/{1}.xml
   -->

<!-- ======================= Imports / Includes =========================== -->
<!-- Include our masthead and templates -->
<xsl:include href="xmlqstat-masthead.xsl"/>
<xsl:include href="xmlqstat-templates.xsl"/>


<!-- ======================== Passed Parameters =========================== -->
<!-- NONE -->


<!-- ======================= Internal Parameters ========================== -->
<!-- NONE -->


<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="icon" type="image/png" href="../css/screen/icons/information.png"/>
&newline;
<title><xsl:value-of select="/content/title"/></title>

&newline;
<!-- load css -->
<link href="../css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
</head>
&newline;

<!-- begin body -->
<body>

&newline;
<xsl:comment>Main body content</xsl:comment>
&newline;
<div id="main">
<!-- Topomost Logo Div -->
  <xsl:call-template name="topLogo">
    <xsl:with-param name="relPath" select="'../'" />
  </xsl:call-template>
&newline;
<!-- Top Menu Bar -->
<div id="menu">
  <a href="../" title="home" class="leftSpace"><img
      src="../css/screen/icons/house.png"
      alt="[home]"
  /></a>

  <img alt=" | " src="../css/screen/icon_divider.png" />
  <a href="http://olesenm.github.com/xml-qstat/index.html"
      title="about"><img
      src="../css/screen/icons/information.png"
      alt="[about]"
  /></a>

  <img alt=" | " src="../css/screen/icon_divider.png" />
  <a href="../info/rss-feeds.html"
      title="rss-feeds"><img
      src="../css/screen/icons/feed.png"
      alt="[rss feeds]"
  /></a>

  <img alt=" | " src="../css/screen/icon_divider.png" />
  <a href="" title="reload"><img
      src="../css/screen/icons/arrow_refresh_small.png"
      alt="[reload]"
  /></a>

</div>

&newline;
<!--
<xsl:comment> Top dotted line bar</xsl:comment>
&newline;
    <div class="dividerBarBelow"><xsl:text> </xsl:text></div>
&newline;
-->

<!-- stuff above is XHTML boilerplate for the basic page layout-->

<!-- BEGIN INFO STUFF HERE  -->
<blockquote>
  <h2 class="infoHeading"><xsl:value-of select="/content/heading"/></h2>
</blockquote>

<!-- create a table of contents -->
<blockquote>
  <ul>
    <xsl:apply-templates select="//section" mode="toc" />
  </ul>
</blockquote>


<!-- now we process each paragraph of our intended content -->
<blockquote>
  <xsl:apply-templates select="//section"/>
</blockquote>

<!-- END INFO STUFF HERE -->

<!-- stuff below is XHTML boilerplate for the basic page layout -->

&newline;
</div> <xsl:comment>This is the end of main content </xsl:comment>
&newline;

</body></html>
<!-- end body/html -->
</xsl:template>


<xsl:template match="section" mode="toc">
  <li>
    <xsl:element name="a">
      <xsl:attribute name="href">#<xsl:value-of select="position()"/></xsl:attribute>
      <xsl:value-of select="sectionHead"/>
    </xsl:element>
  </li>
</xsl:template>

<!-- create a name anchor we can use if we ever get around to
     automatically makinga table of contents
-->
<xsl:template match="section">
  <xsl:element name="a">
    <xsl:attribute name="name">
      <xsl:value-of select="position()"/>
    </xsl:attribute>
    <h3 class="infoSectionHead"><xsl:value-of select="sectionHead"/></h3>
  </xsl:element>
  <xsl:apply-templates select="./para"/>
</xsl:template>

<!-- disable-output-escaping allows us to embed html sequences in CDATA,
     but is unfortunately not supported in mozilla
     https://developer.mozilla.org/en/XSL_Transformations_in_Mozilla_FAQ#Can_I_do_disable-output-escaping.3f
-->

<xsl:template match="para">
  <div class="infoPara">
    <xsl:value-of select="." disable-output-escaping="yes"/>
  </div>
</xsl:template>


</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
