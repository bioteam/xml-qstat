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
   | produce a custom "resource not found" page
   |
   | any xml expected - the interesting info is passed via xslt-param uri
-->

<!-- ======================= Imports / Includes =========================== -->
<!-- Include our masthead -->
<xsl:include href="xmlqstat-masthead.xsl"/>
<!-- Include processor-instruction parsing -->
<xsl:include href="pi-param.xsl"/>


<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="uri">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'uri'"/>
  </xsl:call-template>
</xsl:param>
<xsl:param name="request">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'request'"/>
  </xsl:call-template>
</xsl:param>

<!-- ======================= Internal Parameters ========================== -->
<!-- NONE -->


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
<title> Resource Not Found </title>
<!-- load css -->
<link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
</head>
&newline;

<body>
&newline;
<xsl:comment> Main body content </xsl:comment>
&newline;

<div id="main">
<!-- Topomost Logo Div and Top Menu Bar -->
<xsl:call-template name="topLogo"/>
<!-- define top menu bar without navigation (except home) -->
<div id="menu">
  <!-- home -->
  <a href="/xmlqstat/" title="clusters" class="leftSpace"><img
      src="css/screen/icons/house.png"
      alt="[home]"
  /></a>
  <!-- reload -->
  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="" title="reload"><img
      src="css/screen/icons/arrow_refresh_small.png"
      alt="[reload]"
  /></a>
</div>


&newline;
<blockquote>
  The resource was not found on this system:<br/>
  <blockquote>
    <b>
    <xsl:value-of select="$uri"/>
    <xsl:if test="string-length($request)">?<xsl:value-of select="$request"/></xsl:if>
    </b>
  </blockquote>
</blockquote>

&newline;
</div>
</body></html>
<!-- end body/html -->
</xsl:template>

</xsl:stylesheet>
<!-- =========================== End of File ============================== -->
