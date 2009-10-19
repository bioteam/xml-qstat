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
   | process config/config.xml to produce an index of available clusters
   |
   | expected input:
   |  - directory listing of xml files in cache and cache-* directories
   |
   | uses external files:
   |  - config/config.xml
   -->

<!-- ======================= Imports / Includes =========================== -->
<!-- Include our masthead and templates -->
<xsl:include href="xmlqstat-masthead.xsl"/>
<!-- Include processor-instruction parsing -->
<xsl:include href="pi-param.xsl"/>

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="server-info">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'server-info'"/>
  </xsl:call-template>
</xsl:param>
<xsl:param name="urlExt">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'urlExt'"/>
  </xsl:call-template>
</xsl:param>


<!-- ======================= Internal Parameters ========================== -->
<!-- configuration parameters -->
<xsl:variable
    name="configFile"
    select="document('../config/config.xml')/config" />
<xsl:variable name="qlicserverAllowed">
  <xsl:choose>
  <xsl:when test="$configFile/qlicserver">
    <xsl:if test="$configFile/qlicserver != 'no'">yes</xsl:if>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>yes</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="defaultCluster">
  <xsl:choose>
  <xsl:when test="$configFile/clusters/default">
    <xsl:if test="$configFile/clusters/default != 'no'">yes</xsl:if>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>yes</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:variable>


<!-- all the directory nodes -->
<xsl:variable name="dirNodes" select="//dir:directory"/>


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
<link rel="icon" type="image/png" href="css/screen/icons/tux.png"/>
&newline;
<title>clusters</title>

&newline;
<!-- load css -->
<link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
</head>
&newline;

<!-- begin body -->
&newline;
<xsl:comment> Main body content </xsl:comment>
&newline;
<body>

<div id="main">
<!-- Topomost Logo Div -->
<xsl:call-template name="topLogo"/>

<!-- Top Menu Bar -->
&newline; <xsl:comment> Top Menu Bar </xsl:comment> &newline;
<div id="menu">
  <a href="#" title="clusters" class="leftSpace"><img
      src="css/screen/icons/house.png"
      alt="[home]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="config" title="config"><img
      src="css/screen/icons/folder_wrench.png"
      alt="[config]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="cache" title="cache files"><img
      src="css/screen/icons/folder_page.png"
      alt="[cache files]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="xsl" title="xsl transformations"><img
      src="css/screen/icons/folder_table.png"
      alt="[xsl files]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="http://olesenm.github.com/xml-qstat/index.html"
      title="about"><img
      src="css/screen/icons/information.png"
      alt="[about]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="info/rss-feeds.html" title="RSS feeds (under development)"><img border="0"
      src="css/screen/icons/feed.png" alt="[rss feeds]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="http://github.com/bioteam/xml-qstat/tree/master"
      title="github repo"><img border="0"
      src="css/screen/git-icon.png" alt="[git]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="" title="reload"><img
      src="css/screen/icons/arrow_refresh_small.png"
      alt="[reload]"
  /></a>

</div>
&newline;

<!-- <div class="dividerBarBelow">
</div>
-->

&newline;

<!-- cluster selection -->
<blockquote>
&newline; <xsl:comment> cluster selection: table header </xsl:comment> &newline;
<table class="listing">
  <tr valign="middle">
    <td>
      <div class="tableCaption">Grid Engine Clusters</div>
    </td>
  </tr>
</table>
&newline;

<!--
  list of available clusters
 -->
<table class="listing" style="text-align:left;">
<tr>
  <th>name</th>
  <th>
    <acronym title="Render cached qhost/qlicserver/qstat xml files, typically generated by qlicserver.">
    cached query
    </acronym>
  </th>
  <th>
    <acronym title="Render 'qstat -f' output: use cached xml files if available, or query qmaster directly.">
    qstat -f query (cached or direct)
    </acronym>
  </th>
  <th>root</th>
  <th>cell</th>
</tr>

<xsl:for-each select="$configFile/clusters/cluster">
  <!-- sorted by cluster name -->
  <xsl:sort select="name"/>
  <xsl:apply-templates select="."/>
</xsl:for-each>

<!-- add default cluster -->
<xsl:if test="$defaultCluster = 'yes'">
<xsl:call-template name="addClusterLinks">
  <xsl:with-param name="unnamed" select="'default'"/>
</xsl:call-template>
</xsl:if>

&newline;
</table>
</blockquote>
&newline;
<xsl:if test="string-length($server-info)">
  <xsl:call-template name="bottomStatusBar">
    <xsl:with-param name="timestamp" select="$server-info"/>
  </xsl:call-template>
</xsl:if>
</div>

</body></html>
<!-- end body/html -->
</xsl:template>


<xsl:template match="cluster">
  <xsl:call-template name="addClusterLinks">
    <xsl:with-param name="name" select="@name"/>
    <xsl:with-param name="root" select="@root"/>
    <xsl:with-param name="cell" select="@cell"/>
  </xsl:call-template>
</xsl:template>


<xsl:template name="hasCacheFile">
  <xsl:param name="cacheDir" />
  <xsl:param name="fileBase" />
  <xsl:param name="fileQualifier" select="'.xml'"/>

  <xsl:variable name="plainName" select="concat($fileBase, '.xml')" />
  <xsl:variable name="fqName" select="concat($fileBase, $fileQualifier)" />

  <xsl:if test="
     $dirNodes[@name='cache']/dir:file[@name = $fqName]
     or
     $dirNodes[@name=$cacheDir]/dir:file[@name = $plainName]
     ">true</xsl:if>

</xsl:template>



<xsl:template name="addClusterLinks">
  <xsl:param name="unnamed" />
  <xsl:param name="name" />
  <xsl:param name="root" />
  <xsl:param name="cell" />

  <!-- cache dir qualified with cluster name -->
  <xsl:variable name="fqCacheDir">
    <xsl:choose>
    <xsl:when test="string-length($name)">
      <xsl:text>cache-</xsl:text><xsl:value-of select="$name"/>
    </xsl:when>
    <xsl:otherwise>
       <xsl:text>NONE</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- cache dir qualified with cluster name -->
  <xsl:variable name="fileQualifier">
    <xsl:if test="string-length($name)">
      <xsl:text>~</xsl:text><xsl:value-of select="$name"/>
    </xsl:if>
    <xsl:text>.xml</xsl:text>
  </xsl:variable>

  <xsl:variable name="qhost_exists">
    <xsl:call-template name="hasCacheFile">
      <xsl:with-param name="cacheDir"      select="$fqCacheDir"/>
      <xsl:with-param name="fileQualifier" select="$fileQualifier"/>
      <xsl:with-param name="fileBase"      select="'qhost'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="qlicserver_exists">
    <xsl:if test="$qlicserverAllowed = 'yes'">
      <xsl:call-template name="hasCacheFile">
        <xsl:with-param name="cacheDir"      select="$fqCacheDir"/>
        <xsl:with-param name="fileQualifier" select="$fileQualifier"/>
        <xsl:with-param name="fileBase"      select="'qlicserver'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="qstat_exists">
    <xsl:call-template name="hasCacheFile">
      <xsl:with-param name="cacheDir"      select="$fqCacheDir"/>
      <xsl:with-param name="fileQualifier" select="$fileQualifier"/>
      <xsl:with-param name="fileBase"      select="'qstat'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="qstatf_exists">
    <xsl:call-template name="hasCacheFile">
      <xsl:with-param name="cacheDir"      select="$fqCacheDir"/>
      <xsl:with-param name="fileQualifier" select="$fileQualifier"/>
      <xsl:with-param name="fileBase"      select="'qstatf'"/>
    </xsl:call-template>
  </xsl:variable>


  <xsl:variable name="clusterDir">
    <xsl:text>cluster/</xsl:text>
    <xsl:choose>
    <xsl:when test="string-length($name)">
      <xsl:value-of select="$name"/>
    </xsl:when>
    <xsl:otherwise>
       <xsl:text>default</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  &newline;
  <xsl:comment> cluster: <xsl:value-of select="$name"/> </xsl:comment>
  &newline;
  <tr>
  <!-- cluster name -->
  <td>
    <xsl:choose>
    <xsl:when test="string-length($qstat_exists)">
      <!-- link to cluster/XXX/jobs -->
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$clusterDir"/>
          <xsl:text>/jobs</xsl:text>
          <xsl:value-of select="$urlExt"/>
        </xsl:attribute>
        <xsl:choose>
        <xsl:when test="$unnamed">
          <xsl:attribute name="title">default (unnamed) cluster</xsl:attribute>
          <xsl:value-of select="$unnamed"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="title">jobs</xsl:attribute>
          <xsl:value-of select="$name"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
      <xsl:when test="$unnamed">
        <acronym title="default (unnamed) cluster">
          <xsl:value-of select="$unnamed"/>
        </acronym>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$name"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
    </xsl:choose>
  </td>
  <td>
    <xsl:choose>
    <xsl:when test="
         string-length($qhost_exists)
      or string-length($qlicserver_exists)
      or string-length($qstat_exists)">

      &space;
      <xsl:if test="string-length($qstat_exists)">
        <!-- jobs -->
        <xsl:element name="a">
          <xsl:attribute name="title">jobs</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$clusterDir"/>
            <xsl:text>/jobs</xsl:text>
            <xsl:value-of select="$urlExt"/>
          </xsl:attribute>
          <img border="0"
              src="css/screen/icons/lorry_flatbed.png"
              alt="[jobs]"
          />
        </xsl:element>
      </xsl:if>

      <xsl:if test="string-length($qhost_exists)">
        <!-- queues?summary -->
        &space;
        <xsl:element name="a">
          <xsl:attribute name="title">queue summary</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$clusterDir"/>
            <xsl:text>/queues</xsl:text>
            <xsl:value-of select="$urlExt"/>?summary</xsl:attribute>
          <img border="0"
              src="css/screen/icons/sum.png"
              alt="[queue instances]"
          />
        </xsl:element>

        <!-- queues?free -->
        &space;
        <xsl:element name="a">
          <xsl:attribute name="title">queues free</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$clusterDir"/>
            <xsl:text>/queues</xsl:text>
            <xsl:value-of select="$urlExt"/>?free</xsl:attribute>
          <img border="0"
              src="css/screen/icons/tick.png"
              alt="[queues free]"
          />
        </xsl:element>

        <!-- queues?warn -->
        &space;
        <xsl:element name="a">
          <xsl:attribute name="title">queue warnings</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$clusterDir"/>
            <xsl:text>/queues</xsl:text>
            <xsl:value-of select="$urlExt"/>?warn</xsl:attribute>
          <img border="0"
              src="css/screen/icons/error.png"
              alt="[warn queue]"
          />
        </xsl:element>

        <!-- queues -->
        &space;
        <xsl:element name="a">
          <xsl:attribute name="title">queue listing</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$clusterDir"/>
            <xsl:text>/queues</xsl:text>
            <xsl:value-of select="$urlExt"/>
          </xsl:attribute>
          <img border="0"
              src="css/screen/icons/shape_align_left.png"
              alt="[queue instances]"
          />
        </xsl:element>
      </xsl:if>

      <xsl:if test="string-length($qlicserver_exists)">
        <!-- resources -->
        &space;
        <xsl:element name="a">
          <xsl:attribute name="title">resources</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$clusterDir"/>
            <xsl:text>/resources</xsl:text>
            <xsl:value-of select="$urlExt"/>
          </xsl:attribute>
          <img border="0"
              src="css/screen/icons/database_key.png"
              alt="[resources]"
          />
        </xsl:element>
      </xsl:if>

      <!-- job details -->
      <!-- disabled for now: can be fairly resource-intensive
      &space;
      <xsl:element name="a">
        <xsl:attribute name="title">job details</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="$clusterDir"/>
          <xsl:text>/jobinfo</xsl:text>
          <xsl:value-of select="$urlExt"/>
        </xsl:attribute>
        <img border="0"
            src="css/screen/icons/magnifier_zoom_in.png"
            alt="[job details]"
        />
      </xsl:element>
      -->

      <!-- list cache files -->
      &space;
      <xsl:element name="a">
        <xsl:attribute name="title">cached files</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="$clusterDir"/>
          <xsl:text>/cache</xsl:text>
        </xsl:attribute>
        <img border="0"
            src="css/screen/icons/folder_page.png"
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
    &space;
    <xsl:element name="a">
      <xsl:attribute name="title">jobs</xsl:attribute>
      <xsl:attribute name="href">jobs~<xsl:value-of select="$name"/>
        <xsl:value-of select="$urlExt"/>
      </xsl:attribute>
      <img border="0"
          src="css/screen/icons/lorry.png"
          alt="[xmlqstat]"
      />
    </xsl:element>

    <!-- queues: using qstat -f output (cached or direct) -->
    &space;
    <xsl:element name="a">
      <xsl:attribute name="title">queue listing</xsl:attribute>
      <xsl:attribute name="href">queues~<xsl:value-of select="$name"/>
        <xsl:value-of select="$urlExt"/>
      </xsl:attribute>
      <img border="0"
          src="css/screen/icons/shape_align_left.png"
          alt="[queue instances]"
      />
    </xsl:element>

    <!-- summary: using qstat -f output (cached or direct) -->
    &space;
    <xsl:element name="a">
      <xsl:attribute name="title">cluster summary</xsl:attribute>
      <xsl:attribute name="href">summary~<xsl:value-of select="$name"/>
        <xsl:value-of select="$urlExt"/>
      </xsl:attribute>
      <img border="0"
          src="css/screen/icons/sum.png"
          alt="[cluster summary]"
      />
    </xsl:element>

    <!-- resources -->
    <xsl:if test="string-length($qlicserver_exists)">
      &space;
      <xsl:element name="a">
        <xsl:attribute name="title">resources</xsl:attribute>
        <xsl:attribute name="href">resources~<xsl:value-of select="$name"/>
          <xsl:value-of select="$urlExt"/>
        </xsl:attribute>
        <img border="0"
            src="css/screen/icons/database_key.png"
            alt="[resources]"
        />
      </xsl:element>
    </xsl:if>

    <!-- view qstat -f xml : (cached or direct) -->
    &space;
    <xsl:choose>
    <xsl:when test="string-length($qstatf_exists)">
      <xsl:element name="a">
        <xsl:attribute name="title">cached qstat -f query</xsl:attribute>
        <xsl:attribute name="href">qstatf~<xsl:value-of select="$name"/>.xml</xsl:attribute>
        <img border="0"
            src="css/screen/icons/folder_page.png"
            alt="[cached qstat -f]"
        />
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="a">
        <xsl:attribute name="title">qstat -f -xml</xsl:attribute>
        <xsl:attribute name="href">qstatf~<xsl:value-of select="$name"/>.xml</xsl:attribute>
        <img border="0"
            src="css/screen/icons/tag.png"
            alt="[qstat -f -xml]"
        />
      </xsl:element>
    </xsl:otherwise>
    </xsl:choose>

  </td>

  <!-- sge root -->
  <td>
      <xsl:value-of select="$root"/>
  </td>
  <!-- sge cell -->
  <td>
      <xsl:value-of select="$cell"/>
  </td>

  </tr>
</xsl:template>


</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
