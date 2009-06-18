<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<!--
   |
   | documentation rendering for url path /info/
   |
-->

<!-- output declarations -->
<xsl:output method="xhtml" indent="yes" version="4.01" encoding="ISO-8859-1"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

<!-- get specific configuration parameters -->
<xsl:variable name="config_qlicserver">
<xsl:if
    test="document('../config/config.xml')/config/qlicserver = 'yes'"
    >yes</xsl:if>
</xsl:variable>

<!-- Import our uniform masthead -->
<xsl:include href="xmlqstat-masthead.xsl"/>

<!-- XSL Parameters -->
<xsl:param name="timestamp"/>

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="icon" type="image/png" href="../images/icons/silk/information.png"/>
<title><xsl:value-of select="/content/title"/></title>

<xsl:text>
</xsl:text>
<xsl:comment>Load our CSS from a file now ...</xsl:comment>
<xsl:text>
</xsl:text>
<link href="../css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
<xsl:text>
</xsl:text>
</head>
<body>

<xsl:text>
</xsl:text>
<xsl:comment>Main body content</xsl:comment>
<xsl:text>
</xsl:text>
<div id="main">
<!-- Topomost Logo Div -->
  <xsl:call-template name="xmlqstatLogo">
    <xsl:with-param name="relPath" select="'../'" />
  </xsl:call-template>
<xsl:text>
</xsl:text>
<!-- Top Menu Bar -->
<div id="menu">
  <img alt="*" src="../images/icons/silk/bullet_blue.png" />
  <a href="../" title="home"><img border="0"
      src="../images/icons/silk/house.png"
      alt="[home]"
  /></a>
  <img alt="*" src="../images/icons/silk/bullet_blue.png" />
  <a href="../info/about.html" title="about"><img border="0"
      src="../images/icons/silk/information.png"
      alt="[about]"
  /></a>
  <!-- not yet written
  <img alt="*" src="../images/icons/silk/bullet_blue.png" />
  <a href="../info/help.html" title="help"><img border="0"
      src="../images/icons/silk/help.png"
      alt="[help]"
  /></a>
  <img alt="*" src="../images/icons/silk/bullet_blue.png" />
  <a href="../info/participate.html" title="participate"><img border="0"
      src="../images/icons/silk/page_white_edit.png"
      alt="[notes]"
  /></a>
  -->
  <img alt="*" src="../images/icons/silk/bullet_blue.png" />
  <a href="" title="reload"><img border="0"
      src="../images/icons/silk/arrow_refresh_small.png"
      alt="[reload]"
  /></a>
  <img alt="*" src="../images/icons/silk/bullet_blue.png" />
</div>

<xsl:text>
</xsl:text>
<!--
<xsl:comment> Top dotted line bar</xsl:comment>
<xsl:text>
</xsl:text>
    <div class="dividerBarBelow"><xsl:text> </xsl:text></div>
<xsl:text>
</xsl:text>
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

<!-- bottom status bar with rendered time -->
<xsl:call-template name="bottomStatusBar">
  <xsl:with-param name="timestamp" select="$timestamp" />
</xsl:call-template>
<xsl:text>
</xsl:text>
</div> <xsl:comment>This is the end of main content </xsl:comment>
<xsl:text>

</xsl:text><xsl:comment>bottom box section </xsl:comment>
<xsl:text>
</xsl:text>
<div class="bottomBox">
  <a href="../info/rss-feeds.html" title="list RSS feeds"><img border="0"
      src="../images/icons/silk/feed.png" alt="[rss feeds]"
  /></a>
  <xsl:text> </xsl:text>
  <a href="../psp/qstat.html" title="format for Sony PSP web browser"><img border="0"
      src="../images/icons/silk/controller.png" alt="[psp]"
  /></a>
</div>

</body></html>
</xsl:template>

<xsl:template match="section" mode="toc">
  <li><xsl:element name="a"><xsl:attribute name="href">#<xsl:value-of select="position()"/></xsl:attribute><xsl:value-of select="sectionHead"/></xsl:element></li>
</xsl:template>

<!-- create a name anchor we can use if we ever get around to
     automatically makinga table of contents
-->
<xsl:template match="section">
  <xsl:element name="a"><xsl:attribute name="name"><xsl:value-of select="position()"/></xsl:attribute></xsl:element>
  <h3 class="infoSectionHead"><xsl:value-of select="sectionHead"/></h3>
  <xsl:apply-templates select="./para"/>
</xsl:template>

<xsl:template match="para">
  <div class="infoPara"><br/>
    <xsl:value-of select="." disable-output-escaping="yes"/>
  </div>
</xsl:template>

</xsl:stylesheet>
