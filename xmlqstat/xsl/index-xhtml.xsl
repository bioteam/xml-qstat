<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
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

<!-- get specific configuration parameters -->
<xsl:variable name="config_qlicserver">
<xsl:if
    test="document('../config/config.xml')/config/qlicserver = 'yes'"
    >yes</xsl:if>
</xsl:variable>



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
  <a href="#" title="clusters" class="leftSpace"><img
      src="images/icons/silk/house.png"
      alt="[home]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="config" title="config"><img
      src="images/icons/silk/folder_wrench.png"
      alt="[config]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="sitemap.xmap" title="sitemap"><img
      src="images/icons/silk/wrench.png"
      alt="[sitemap]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="http://olesenm.github.com/xml-qstat/index.html"
      title="about"><img
      src="images/icons/silk/information.png"
      alt="[about]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="info/links.html" title="links"><img
      src="images/icons/silk/link.png"
      alt="[links]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="info/rss-feeds.html" title="RSS feeds (under development)"><img border="0"
      src="images/icons/silk/feed.png" alt="[rss feeds]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="http://github.com/bioteam/xml-qstat/tree/master"
      title="github repo"><img border="0"
      src="css/screen/git-icon.png" alt="[git]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="" title="reload"><img
      src="images/icons/silk/arrow_refresh_small.png"
      alt="[reload]"
  /></a>

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
      <div class="tableCaption">Grid Engine Clusters</div>
    </td>
  </tr>
</table>
<xsl:apply-templates select="//config/clusters" />
</blockquote>

</div>


<!-- bottom links -->
<div class="bottomBox">

  <!-- jobs: using qstat -f output (cached or direct) -->
  <xsl:text> </xsl:text>
  <a href="jobs" title="jobs"><img border="0"
      src="images/icons/silk/lorry.png" alt="[jobs]"
  /></a>

  <!-- queues: using qstat -f output (cached or direct) -->
  <xsl:text> </xsl:text>
  <a href="queues" title="queue listing"><img border="0"
      src="images/icons/silk/shape_align_left.png"
      alt="[queue instances]"
  />
  </a>

  <!-- summary: using qstat -f output (cached or direct) -->
  <xsl:text> </xsl:text>
  <a href="summary" title="cluster summary"><img border="0"
      src="images/icons/silk/sum.png"
      alt="[cluster summary]"
  />
  </a>

  <!-- view qstat -f xml: (cached or direct) -->
  <xsl:text> </xsl:text>
  <xsl:choose>
  <xsl:when test="//dir:directory[@name='cache']/dir:file[@name='qstatf.xml']">
    <a href="cache/qstatf.xml" title="cached qstat -f query"><img border="0"
        src="images/icons/silk/folder_page.png"
        alt="[cache]"
    />
    </a>
  </xsl:when>
  <xsl:otherwise>
    <a href="qstatf.xml" title="qstat -f -xml"><img border="0"
        src="images/icons/silk/tag.png"
        alt="[raw xml]"
    />
    </a>
  </xsl:otherwise>
  </xsl:choose>

  <xsl:text> </xsl:text>Query unnamed (default) cluster

</div>

</body></html>
</xsl:template>


<!--
  list of available clusters
 -->
<xsl:template match="//config/clusters">
  <table class="listing" style="text-align:left;">
  <tr>
    <th>name</th>
    <th>
      <acronym title="Use cached qhost/qlicserver/qstat xml files, typically generated by the qlicserver.">
      query cached
      </acronym>
    </th>
    <th>
      <acronym title="Use cached qstat -f xml files if available, otherwise query qmaster directly.">
      qstat -f query (cached or direct)
      </acronym>
    </th>
    <th>root</th>
    <th>cell</th>
  </tr>
  <xsl:for-each select="cluster">
    <!-- sorted by job number and task -->
    <xsl:sort select="name"/>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match="//cluster">

  <!-- directory name for qlicserver-style caches -->
  <xsl:param name="cacheDir">cache-<xsl:value-of select="@name"/></xsl:param>
  <!-- directory name for qstat -f cache -->
  <xsl:param name="cacheFile">qstatf~<xsl:value-of select="@name"/>.xml</xsl:param>

  <xsl:param name="hasCache">
     <xsl:if test="//dir:directory[@name=$cacheDir]">true</xsl:if>
  </xsl:param>

  <!-- fixme: This does not yet work, needs sub-dir from cache-{clusterName} -->
  <xsl:param name="qstatfCached">
    <xsl:if test="
       //dir:directory[@name='cache']/dir:file[@name=$cacheFile]
       or
       //dir:directory[@name=$cacheDir]/dir:file[@name='qstatf.xml']
       ">true</xsl:if>
  </xsl:param>

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
    <xsl:choose>
    <xsl:when test="$hasCache='true'">
      <!-- jobs -->
      <xsl:text> </xsl:text>
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
            src="images/icons/silk/sum.png"
            alt="[queue instances]"
        />
      </xsl:element>

      <!-- queues?free -->
      <xsl:text> </xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="title">queues free</xsl:attribute>
        <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/queues?free</xsl:attribute>
        <img border="0"
            src="images/icons/silk/tick.png"
            alt="[queues free]"
        />
      </xsl:element>

      <!-- queues?warn -->
      <xsl:text> </xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="title">queue warnings</xsl:attribute>
        <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/queues?warn</xsl:attribute>
        <img border="0"
            src="images/icons/silk/error.png"
            alt="[warn queue]"
        />
      </xsl:element>

      <!-- queues -->
      <xsl:text> </xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="title">queue listing</xsl:attribute>
        <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/queues</xsl:attribute>
        <img border="0"
            src="images/icons/silk/shape_align_left.png"
            alt="[queue instances]"
        />
      </xsl:element>

      <!-- resources -->
      <xsl:if test="$config_qlicserver = 'yes'">
        <xsl:text> </xsl:text>
        <xsl:element name="a">
          <xsl:attribute name="title">resources</xsl:attribute>
          <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/resources</xsl:attribute>
          <img border="0"
              src="images/icons/silk/database_key.png"
              alt="[resources]"
          />
        </xsl:element>
      </xsl:if>

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

      <!-- list cache files -->
      <xsl:text> </xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="title">cached files</xsl:attribute>
        <xsl:attribute name="href">cluster/<xsl:value-of select="@name"/>/cache</xsl:attribute>
        <img border="0"
            src="images/icons/silk/folder_page.png"
            alt="[cache]"
        />
      </xsl:element>

    </xsl:when>
    <xsl:otherwise>
    no cache
    </xsl:otherwise>
    </xsl:choose>
  </td>

  <td>
    <!-- jobs: using qstat -f output (cached or direct) -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">jobs</xsl:attribute>
      <xsl:attribute name="href">jobs~<xsl:value-of select="@name"/></xsl:attribute>
      <img border="0"
          src="images/icons/silk/lorry.png"
          alt="[xmlqstat]"
      />
    </xsl:element>

    <!-- queues: using qstat -f output (cached or direct) -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">queue listing</xsl:attribute>
      <xsl:attribute name="href">queues~<xsl:value-of select="@name"/></xsl:attribute>
      <img border="0"
          src="images/icons/silk/shape_align_left.png"
          alt="[queue instances]"
      />
    </xsl:element>

    <!-- summary: using qstat -f output (cached or direct) -->
    <xsl:text> </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="title">cluster summary</xsl:attribute>
      <xsl:attribute name="href">summary~<xsl:value-of select="@name"/></xsl:attribute>
      <img border="0"
          src="images/icons/silk/sum.png"
          alt="[cluster summary]"
      />
    </xsl:element>

    <!-- view qstat -f xml : (cached or direct) -->
    <xsl:text> </xsl:text>
    <xsl:choose>
    <xsl:when test="$qstatfCached='true'">
      <xsl:element name="a">
        <xsl:attribute name="title">cached qstat -f query</xsl:attribute>
        <xsl:attribute name="href">qstatf~<xsl:value-of select="@name"/>.xml</xsl:attribute>
        <img border="0"
            src="images/icons/silk/folder_page.png"
            alt="[cached qstat -f]"
        />
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="a">
        <xsl:attribute name="title">qstat -f -xml</xsl:attribute>
        <xsl:attribute name="href">qstatf~<xsl:value-of select="@name"/>.xml</xsl:attribute>
        <img border="0"
            src="images/icons/silk/tag.png"
            alt="[qstat -f -xml]"
        />
      </xsl:element>
    </xsl:otherwise>
    </xsl:choose>

  </td>

  <!-- sge root -->
  <td>
      <xsl:value-of select="@root"/>
  </td>
  <!-- sge cell -->
  <td>
      <xsl:value-of select="@cell"/>
  </td>

  </tr>
</xsl:template>

</xsl:stylesheet>
