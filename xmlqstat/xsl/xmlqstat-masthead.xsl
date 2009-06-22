<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dt="http://xsltsl.org/date-time"
    xmlns:str="http://xsltsl.org/string"
    exclude-result-prefixes="dt str"
>
<!--
   | Logo and uniform naviation buttons that can be customized as required
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


<!-- define a standard (corporate, institutional) logo to use -->
<xsl:template name="topLogo">
  <xsl:param name="relPath" />
  <div class="topLogo" style="clear:both; text-align:left;">
    <!-- getting the image info (brute-force): -->
    <xsl:if test="document('../config/config.xml')/config/topLogo/@src">
    <p>
      <xsl:element name="a">
        <xsl:if test="document('../config/config.xml')/config/topLogo/@href">
          <xsl:attribute name="href"><xsl:value-of select="document('../config/config.xml')/config/topLogo/@href"/></xsl:attribute>
        </xsl:if>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:if test="$relPath">
              <xsl:value-of select="$relPath"/>
            </xsl:if>
            <xsl:value-of select="document('../config/config.xml')/config/topLogo/@src"/>
          </xsl:attribute>
          <xsl:if test="document('../config/config.xml')/config/topLogo/@width">
            <xsl:attribute name="width"><xsl:value-of select="document('../config/config.xml')/config/topLogo/@width"/></xsl:attribute>
          </xsl:if>
          <xsl:attribute name="alt">logo</xsl:attribute>
          <xsl:attribute name="border">0</xsl:attribute>
        </xsl:element>
      </xsl:element>
    </p>
    </xsl:if>
  </div>
</xsl:template>


<!-- define a default xmlqstat local -->
<xsl:template name="xmlqstatLogo">
  <xsl:param name="relPath" />
  <div class="topLogo" style="clear:both; text-align:left;">
    <p>
      <xsl:element name="img">
        <xsl:attribute name="src"><xsl:if
          test="$relPath"><xsl:value-of
          select="$relPath"/></xsl:if>images/xml-qstat-logo.png</xsl:attribute>
        <xsl:attribute name="width">150</xsl:attribute>
        <xsl:attribute name="alt">logo</xsl:attribute>
      </xsl:element>
    </p>
  </div>
</xsl:template>


<!-- define top menu bar for navigation
     this version is optimized for use with qlicserver output
-->
<xsl:template name="topMenu">
  <xsl:param name="jobinfo" />
  <div id="menu">
    <a href="../../" title="clusters" class="leftSpace"><img
        src="images/icons/silk/house.png"
        alt="[home]"
    /></a>

    <!-- jobs -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="jobs" title="jobs"><img
        src="images/icons/silk/lorry_flatbed.png"
        alt="[jobs]"
    /></a>

    <!-- queues?summary -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="queues?summary" title="queue summary"><img
        src="images/icons/silk/sum.png"
        alt="[queues summary]"
    /></a>

    <!-- queues?free -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="queues?free" title="queues free"><img
        src="images/icons/silk/tick.png"
        alt="[queues free]"
    /></a>

    <!-- queues?warn -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="queues?warn" title="warn queues"><img
        src="images/icons/silk/error.png"
        alt="[warn queues]"
    /></a>

    <!-- queues -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="queues" title="queue instances"><img
        src="images/icons/silk/shape_align_left.png"
        alt="[queues]"
    /></a>

  <xsl:if test="$config_qlicserver = 'yes'">
    <!-- resources -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="resources" title="resources" ><img
        src="images/icons/silk/database_key.png"
        alt="[resources]"
    /></a>
  </xsl:if>

    <!-- jobinfo: toggle between more/less views -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:choose>
    <xsl:when test="$jobinfo = 'less'">
      <a href="jobs" title="jobs"><img
          src="images/icons/silk/magnifier_zoom_out.png"
          alt="[jobs]"
      /></a>
    </xsl:when>
    <xsl:otherwise>
      <a href="jobinfo" title="job details"><img
          src="images/icons/silk/magnifier_zoom_in.png"
          alt="[job details]"
      /></a>
    </xsl:otherwise>
    </xsl:choose>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="" title="reload"><img
        src="images/icons/silk/arrow_refresh_small.png"
        alt="[reload]"
    /></a>
  </div>
</xsl:template>


<!-- define top menu bar for navigation
     this version is for the traditional xmlqstat navigation
     (using qstat -f output)
-->
<xsl:template name="xmlqstatMenu">
  <xsl:param name="clusterSuffix" />
  <xsl:param name="jobinfo" />
  <xsl:param name="path" />

  <div id="menu">
    <a href="./" title="home" class="leftSpace"><img
        src="images/icons/silk/house.png"
        alt="[home]"
    /></a>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">jobs</xsl:attribute>
      <xsl:attribute name="href">jobs<xsl:value-of select="$clusterSuffix"/></xsl:attribute>
      <img
        src="images/icons/silk/table_gear.png"
        alt="[jobs]"
      />
    </xsl:element>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">queue instances</xsl:attribute>
      <xsl:attribute name="href">queues<xsl:value-of select="$clusterSuffix"/></xsl:attribute>
      <img
        src="images/icons/silk/shape_align_left.png"
        alt="[queue instances]"
      />
    </xsl:element>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">cluster summary</xsl:attribute>
      <xsl:attribute name="href">summary<xsl:value-of select="$clusterSuffix"/></xsl:attribute>
      <img
        src="images/icons/silk/sum.png"
        alt="[cluster summary]"
      />
    </xsl:element>

    <!-- jobinfo: toggle between more/less views -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:choose>
    <xsl:when test="$jobinfo = 'less'">
      <xsl:element name="a">
        <xsl:attribute name="title">jobs</xsl:attribute>
        <xsl:attribute name="href">jobs<xsl:value-of select="$clusterSuffix"/></xsl:attribute>
        <img
          src="images/icons/silk/magnifier_zoom_out.png"
          alt="[jobs]"
        />
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="a">
        <xsl:attribute name="title">job details</xsl:attribute>
        <xsl:attribute name="href">jobinfo<xsl:value-of select="$clusterSuffix"/></xsl:attribute>
        <img
          src="images/icons/silk/magnifier_zoom_in.png"
          alt="[jobs]"
        />
      </xsl:element>
    </xsl:otherwise>
    </xsl:choose>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="info/about.html" title="about"><img
        src="images/icons/silk/information.png"
        alt="[about]"
    /></a>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="info/links.html" title="links"><img
        src="images/icons/silk/link.png"
        alt="[help]"
    /></a>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="" title="reload"><img
        src="images/icons/silk/arrow_refresh_small.png"
        alt="[reload]"
    /></a>
  </div>
</xsl:template>


<!-- bottom status bar with timestamp -->
<xsl:template name="bottomStatusBar">
<xsl:param name="timestamp" />

  <xsl:text>
  </xsl:text>
  <xsl:comment> Bottom status bar </xsl:comment>
  <xsl:text>
  </xsl:text>
  <xsl:if test="$timestamp">
    <div class="dividerBarAbove">
      Rendered: <xsl:value-of select="$timestamp"/>
    </div>
    <xsl:text>
    </xsl:text>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
