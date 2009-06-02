<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dt="http://xsltsl.org/date-time"
    xmlns:str="http://xsltsl.org/string"
    exclude-result-prefixes="dt str"
>
<!--
   | process config/config.xml to produce an index of available clusters
-->

<!-- output declarations -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

<!-- Import the XSLTL library method -->
<xsl:include href="xsltl/stdlib.xsl"/>

<!-- Import our uniform masthead -->
<xsl:include href="xmlqstat-masthead.xsl"/>

<!-- Import our templates -->
<xsl:include href="xmlqstat-templates.xsl"/>

<xsl:template match="/" >
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="icon" type="image/png" href="images/icons/silk/tux.png"/>
<title>clusters</title>

<xsl:comment> Load CSS from a file </xsl:comment>
<xsl:text>
</xsl:text>
<link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />

</head>
<xsl:text>
</xsl:text>

<!-- CALCULATE -->

<!-- done CALCULATE -->

<body>
<xsl:text>
</xsl:text>
<xsl:comment> Main body content </xsl:comment>
<xsl:text>
</xsl:text>

<div id="main">
<!-- Topomost Logo Div -->
<xsl:call-template name="topLogo"/>

<!-- Top Menu Bar -->
<div id="menu">
  <img alt="*" src="images/icons/silk/bullet_blue.png" />
  <a href="#" title="clusters"><img border="0"
      src="images/icons/silk/house.png"
      alt="[home]"
  /></a>

  <img alt="*" src="images/icons/silk/bullet_blue.png" />
  <a href="config" title="config"><img border="0"
      src="images/icons/silk/folder_wrench.png"
      alt="[config]"
  /></a>

  <img alt="*" src="images/icons/silk/bullet_blue.png" />
  <a href="sitemap.xmap" title="sitemap"><img border="0"
      src="images/icons/silk/wrench.png"
      alt="[sitemap]"
  /></a>

  <img alt="*" src="images/icons/silk/bullet_blue.png" />
  <a href="info/about.html" title="about"><img border="0"
      src="images/icons/silk/information.png"
      alt="[about]"
  /></a>

  <img alt="*" src="images/icons/silk/bullet_blue.png" />
  <a href="" title="reload"><img border="0"
      src="images/icons/silk/arrow_refresh_small.png"
      alt="[reload]"
  /></a>

  <img alt="*" src="images/icons/silk/bullet_blue.png" />
</div>

<!-- <div class="dividerBarBelow">
</div>
-->

<xsl:text>
</xsl:text>

<!-- cluster selection -->
<blockquote>
<table class="listing">
  <tr valign="middle">
    <td>
      <div class="tableCaption">Clusters</div>
    </td>
  </tr>
</table>
<xsl:apply-templates select="//config/clusters" />
</blockquote>

</div>

<!-- bottom links -->
<div class="bottomBox">
  <img alt="*" src="images/icons-silk-empty.png" />
  <a href="qstat-jobs.html" title="xmlqstat"><img border="0"
      src="images/icons/silk/table_gear.png" alt="[xmlqstat]"
  /></a>
  <xsl:text> </xsl:text>
  <a href="psp/" title="sony psp"><img border="0"
      src="images/icons/silk/controller.png" alt="[psp]"
  /></a>
</div>

</body></html>

</xsl:template>


<!--
  list of available clusters
 -->
<xsl:template match="//config/clusters">
  <table class="listing" style="text-align:left;">
  <tr>
    <th colspan="2">name</th>
    <th>root</th>
    <th>cell</th>
    <th>cache</th>
  </tr>
  <xsl:for-each select="cluster">
    <!-- sorted by job number and task -->
    <xsl:sort select="name"/>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match="//cluster">
  <tr>
  <!-- cluster name -->
  <td>
    <xsl:element name="a">
      <xsl:attribute name="title">jobs</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/jobs</xsl:attribute>
      <xsl:value-of select="@name"/>
    </xsl:element>
  </td>
  <td>
    <!-- jobs -->
    <xsl:element name="a">
      <xsl:attribute name="title">jobs</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/jobs</xsl:attribute>
      <img border="0"
          src="images/icons/silk/lorry_flatbed.png"
          alt="[jobs]"
      />
    </xsl:element>

    <!-- queues?summary -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">queue summary</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/queues?summary</xsl:attribute>
      <img border="0"
          src="images/icons/silk/chart_bar.png"
          alt="[queue instances]"
      />
    </xsl:element>

    <!-- queues -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">queue listing</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/queues</xsl:attribute>
      <img border="0"
          src="images/icons/silk/chart_bar_add.png"
          alt="[queue instances]"
      />
    </xsl:element>

    <!-- queues?warn -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">queue warnings</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/queues?warn</xsl:attribute>
      <img border="0"
          src="images/icons/silk/chart_bar_error.png"
          alt="[warn queue]"
      />
    </xsl:element>

    <!-- resources -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">resources</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/resources</xsl:attribute>
      <img border="0"
          src="images/icons/silk/database_key.png"
          alt="[resources]"
      />
    </xsl:element>

    <!-- job details -->
    <!-- disabled for now: can be fairly resource-intensive
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">job details</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/jobinfo</xsl:attribute>
      <img border="0"
          src="images/icons/silk/magnifier_zoom_in.png"
          alt="[job details]"
      />
    </xsl:element>
    -->
  </td>
  <td>
      <xsl:value-of select="@root"/>
  </td>
  <td>
      <xsl:value-of select="@cell"/>
  </td>
  <td>
    <!-- list cache files -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">cache</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/cache</xsl:attribute>
      <img border="0"
          src="images/icons/silk/folder_page.png"
          alt="[cache]"
      />
    </xsl:element>
  </td>

  </tr>
</xsl:template>

<!--
  active jobs: contents
 -->


</xsl:stylesheet>
