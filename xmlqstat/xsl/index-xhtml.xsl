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
<meta http-equiv="Refresh" content="30" />
<title>Clusters</title>

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

<div id="menu" style="text-align:left;">
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
  <a href="" title="reload"><img border="0"
      src="images/icons/silk/arrow_refresh_small.png"
      alt="[reload]"
  /></a>

  <img alt="*" src="images/icons/silk/bullet_blue.png" />
</div>

<!-- <div id="upperBar">
</div>
-->

<xsl:text>
</xsl:text>

<!-- cluster selection -->
<blockquote>
<table class="qstat" width="100%">
  <tr valign="middle">
    <td>
      <div class="tableDescriptorElement">Clusters</div>
    </td>
  </tr>
</table>
<xsl:apply-templates select="//config/clusters" />
</blockquote>

</div>

<!-- bottom links -->
<img alt="*" src="images/icons-silk-empty.png" />
<a href="qstat-jobs.html" title="xmlqstat"><img border="0"
    src="images/icons/silk/table_gear.png" alt="[xmlqstat]"
/></a>
<xsl:text> </xsl:text>
<a href="psp/" title="sony psp"><img border="0"
    src="images/icons/silk/controller.png" alt="[psp]"
/></a>

</body></html>

</xsl:template>


<!--
  active jobs: header
 -->
<xsl:template match="//config/clusters">
  <div class="activeJobTable" style="text-align:left;">
    <table class="qstat" width="100%">
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
  </div>
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
          src="images/icons/silk/chart_organisation.png"
          alt="[queue instances]"
      />
    </xsl:element>

    <!-- queues -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">queue listing</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/queues</xsl:attribute>
      <img border="0"
          src="images/icons/silk/chart_organisation_add.png"
          alt="[queue instances]"
      />
    </xsl:element>

    <!-- queues?warn -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">warn queues</xsl:attribute>
      <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/queues?warn</xsl:attribute>
      <img border="0"
          src="images/icons/silk/error.png"
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
          src="images/icons/silk/folder_explore.png"
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
