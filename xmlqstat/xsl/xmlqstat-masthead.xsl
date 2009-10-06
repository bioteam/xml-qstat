<!DOCTYPE stylesheet [
<!ENTITY  newline "<xsl:text>&#x0a;</xsl:text>">
<!ENTITY  space   "<xsl:text> </xsl:text>">
]>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
>

<!--
   | Logo and uniform naviation buttons that can be customized as required
-->

<!-- ======================= Internal Parameters ========================== -->

<!-- ========================= Named Templates ============================ -->

<!--
   | define a standard (corporate, institutional) logo to use
   | - extract @src, @width and @href attributes
-->
<xsl:template name="topLogo">
  <xsl:param name="relPath" />

  <xsl:variable
      name="topLogo"
      select="document('../config/config.xml')/config/topLogo"
      />

  <xsl:choose>
  <xsl:when test="$topLogo/@src">
    &newline;
    <xsl:comment> define standard (corporate/institutional) logo </xsl:comment>
    &newline;

    <div class="topLogo" style="clear:both; text-align:left;">
    <p>
      <xsl:element name="a">
        <xsl:if test="$topLogo/@href">
          <xsl:attribute name="href">
            <xsl:value-of select="$topLogo/@href"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:if test="$relPath"><xsl:value-of select="$relPath"/></xsl:if>
            <xsl:value-of select="$topLogo/@src"/>
          </xsl:attribute>
          <xsl:if test="$topLogo/@width">
            <xsl:attribute name="width">
              <xsl:value-of select="$topLogo/@width" />
            </xsl:attribute>
          </xsl:if>
          <xsl:attribute name="alt">logo</xsl:attribute>
          <xsl:attribute name="border">0</xsl:attribute>
        </xsl:element>
      </xsl:element>
    </p>
    </div>
    &newline;
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="topLogoDefault">
      <xsl:with-param name="relPath" select="$relPath" />
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<!-- define a default xmlqstat logo -->
<xsl:template name="topLogoDefault">
  <xsl:param name="relPath" />

  &newline;
  <xsl:comment> define standard xmlqstat logo </xsl:comment>
  &newline;
  <div class="topLogo" style="clear:both; text-align:left;">
    <p>
      <xsl:element name="img">
        <xsl:attribute name="src">
          <xsl:if test="$relPath"><xsl:value-of select="$relPath"/></xsl:if>
          <xsl:text>images/xml-qstat-logo.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="width">150</xsl:attribute>
        <xsl:attribute name="alt">logo</xsl:attribute>
        <xsl:attribute name="border">0</xsl:attribute>
      </xsl:element>
    </p>
  </div>
  &newline;

</xsl:template>


<!-- define top menu bar for navigation
     this version is optimized for use with qlicserver output
-->
<xsl:template name="topMenu">
  <xsl:param name="jobinfo" />

  <xsl:variable name="qlicserverOk">
    <xsl:if test="document('../config/config.xml')/config/qlicserver = 'yes'">yes</xsl:if>
  </xsl:variable>

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

  <xsl:if test="$qlicserverOk = 'yes'">
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

  <xsl:variable name="qlicserverOk">
    <xsl:if test="document('../config/config.xml')/config/qlicserver = 'yes'">yes</xsl:if>
  </xsl:variable>


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
        src="images/icons/silk/lorry.png"
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

  <xsl:if test="$qlicserverOk = 'yes'">
    <!-- resources -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">resources</xsl:attribute>
      <xsl:attribute name="href">resources<xsl:value-of select="$clusterSuffix"/></xsl:attribute>
      <img
        src="images/icons/silk/database_key.png"
        alt="[resources]"
      />
    </xsl:element>
  </xsl:if>

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

<!-- =========================== End of File ============================== -->
