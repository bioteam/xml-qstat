<!DOCTYPE stylesheet [
<!ENTITY  newline "<xsl:text>&#x0a;</xsl:text>">
<!ENTITY  space   "<xsl:text> </xsl:text>">
<!ENTITY  nbsp    "&#xa0;">
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
   | - extract @src, @href and @height or @width attributes
-->
<xsl:template name="topLogo">
  <xsl:param name="relPath" />

  <xsl:variable
      name="topLogo"
      select="document('../config/config.xml')/config/topLogo"
      />

  &newline;
  <xsl:comment> standard (corporate/institutional) logo </xsl:comment>
  &newline;

  <div class="topLogo" style="clear:both; text-align:left;">
  <p>
    <xsl:element name="a">
      <!-- a href -->
      <xsl:attribute name="href">
        <xsl:choose>
        <xsl:when test="$topLogo/@href">
          <xsl:value-of select="$topLogo/@href"/>
        </xsl:when>
        <xsl:otherwise>#</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:element name="img">
        <!-- img src -->
        <xsl:attribute name="src">
          <xsl:if test="$relPath"><xsl:value-of select="$relPath"/></xsl:if>
          <xsl:choose>
          <xsl:when test="$topLogo/@src">
            <xsl:value-of select="$topLogo/@src"/>
          </xsl:when>
          <xsl:otherwise>config/logo.png</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <!-- img alt -->
        <xsl:attribute name="alt">logo</xsl:attribute>
        <xsl:attribute name="border">0</xsl:attribute>

        <!-- img height -->
        <xsl:if test="$topLogo/@height">
          <xsl:attribute name="height">
            <xsl:value-of select="$topLogo/@height" />
          </xsl:attribute>
        </xsl:if>
        <!-- img width -->
        <xsl:if test="$topLogo/@width">
          <xsl:attribute name="width">
            <xsl:value-of select="$topLogo/@width" />
          </xsl:attribute>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </p>
  </div>
  &newline;

</xsl:template>


<!-- define top menu bar for navigation
     this version is optimized for use with qlicserver cache files
-->
<xsl:template name="topMenu">
  <xsl:param name="jobinfo" />
  <xsl:param name="urlExt" />

  <xsl:variable name="qlicserverAllowed">
    <xsl:choose>
    <xsl:when test="document('../config/config.xml')/config/qlicserver
      and document('../config/config.xml')/config/qlicserver != 'no'
      ">yes</xsl:when>
    <xsl:otherwise>
      <xsl:text>yes</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div id="menu">
    <xsl:element name="a">
      <xsl:attribute name="title">cluster listing</xsl:attribute>
      <xsl:attribute name="href">../../cluster<xsl:value-of
        select="$urlExt"/></xsl:attribute>
      <xsl:attribute name="class">leftSpace</xsl:attribute>
      <img
        src="css/screen/icons/house.png"
        alt="[home]"
      />
    </xsl:element>

    <!-- jobs -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">jobs</xsl:attribute>
      <xsl:attribute name="href">jobs<xsl:value-of
        select="$urlExt"/></xsl:attribute>
      <img
        src="css/screen/icons/lorry_flatbed.png"
        alt="[jobs]"
      />
    </xsl:element>

    <!-- queues?summary -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">queue summary</xsl:attribute>
      <xsl:attribute name="href">queues<xsl:value-of
        select="$urlExt"/>?summary</xsl:attribute>
      <img
        src="css/screen/icons/sum.png"
        alt="[queues summary]"
      />
    </xsl:element>

    <!-- queues?free -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">queue free</xsl:attribute>
      <xsl:attribute name="href">queues<xsl:value-of
        select="$urlExt"/>?free</xsl:attribute>
      <img
        src="css/screen/icons/tick.png"
        alt="[queues free]"
      />
    </xsl:element>

    <!-- queues?warn -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">queue warn</xsl:attribute>
      <xsl:attribute name="href">queues<xsl:value-of
        select="$urlExt"/>?warn</xsl:attribute>
      <img
        src="css/screen/icons/error.png"
        alt="[warn queues]"
      />
    </xsl:element>

    <!-- queues -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">queue instances</xsl:attribute>
      <xsl:attribute name="href">queues<xsl:value-of
        select="$urlExt"/></xsl:attribute>
      <img
        src="css/screen/icons/shape_align_left.png"
        alt="[queues]"
      />
    </xsl:element>

  <xsl:if test="$qlicserverAllowed = 'yes'">
    <!-- resources -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">resources</xsl:attribute>
      <xsl:attribute name="href">resources<xsl:value-of
        select="$urlExt"/></xsl:attribute>
      <img
        src="css/screen/icons/database_key.png"
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
        <xsl:attribute name="href">jobs<xsl:value-of
          select="$urlExt"/></xsl:attribute>
        <img
          src="css/screen/icons/magnifier_zoom_out.png"
          alt="[jobs]"
        />
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="a">
        <xsl:attribute name="title">job details</xsl:attribute>
        <xsl:attribute name="href">jobinfo<xsl:value-of
          select="$urlExt"/></xsl:attribute>
        <img
          src="css/screen/icons/magnifier_zoom_in.png"
          alt="[job details]"
        />
      </xsl:element>
    </xsl:otherwise>
    </xsl:choose>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="" title="reload"><img
        src="css/screen/icons/arrow_refresh_small.png"
        alt="[reload]"
    /></a>
  </div>
</xsl:template>


<!-- define top menu bar for navigation
     this version is for the traditional xmlqstat navigation
     (using qstat -f output)
-->
<xsl:template name="qstatfMenu">
  <xsl:param name="clusterSuffix" />
  <xsl:param name="jobinfo" />
  <xsl:param name="urlExt" />

  <xsl:variable name="qlicserverAllowed">
    <xsl:choose>
    <xsl:when test="document('../config/config.xml')/config/qlicserver
      and document('../config/config.xml')/config/qlicserver != 'no'
      ">yes</xsl:when>
    <xsl:otherwise>
      <xsl:text>yes</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <div id="menu">
    <xsl:element name="a">
      <xsl:attribute name="title">clusters</xsl:attribute>
      <xsl:attribute name="href">cluster<xsl:value-of
        select="$urlExt"/></xsl:attribute>
      <xsl:attribute name="class">leftSpace</xsl:attribute>
      <img
        src="css/screen/icons/house.png"
        alt="[home]"
      />
    </xsl:element>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">jobs</xsl:attribute>
      <xsl:attribute name="href">jobs<xsl:value-of select="$clusterSuffix"/>
        <xsl:value-of select="$urlExt"/>
      </xsl:attribute>
      <img
        src="css/screen/icons/lorry.png"
        alt="[jobs]"
      />
    </xsl:element>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">queue instances</xsl:attribute>
      <xsl:attribute name="href">queues<xsl:value-of select="$clusterSuffix"/>
        <xsl:value-of select="$urlExt"/>
      </xsl:attribute>
      <img
        src="css/screen/icons/shape_align_left.png"
        alt="[queue instances]"
      />
    </xsl:element>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">cluster summary</xsl:attribute>
      <xsl:attribute name="href">summary<xsl:value-of select="$clusterSuffix"/>
        <xsl:value-of select="$urlExt"/>
      </xsl:attribute>
      <img
        src="css/screen/icons/sum.png"
        alt="[cluster summary]"
      />
    </xsl:element>

  <xsl:if test="$qlicserverAllowed = 'yes'">
    <!-- resources -->
    <img alt=" | " src="css/screen/icon_divider.png" />
    <xsl:element name="a">
      <xsl:attribute name="title">resources</xsl:attribute>
      <xsl:attribute name="href">resources<xsl:value-of select="$clusterSuffix"/>
        <xsl:value-of select="$urlExt"/>
      </xsl:attribute>
      <img
        src="css/screen/icons/database_key.png"
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
        <xsl:attribute name="href">jobs<xsl:value-of select="$clusterSuffix"/>
          <xsl:value-of select="$urlExt"/>
        </xsl:attribute>
        <img
          src="css/screen/icons/magnifier_zoom_out.png"
          alt="[jobs]"
        />
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="a">
        <xsl:attribute name="title">job details</xsl:attribute>
        <xsl:attribute name="href">jobinfo<xsl:value-of select="$clusterSuffix"/>
          <xsl:value-of select="$urlExt"/>
        </xsl:attribute>
        <img
          src="css/screen/icons/magnifier_zoom_in.png"
          alt="[jobs]"
        />
      </xsl:element>
    </xsl:otherwise>
    </xsl:choose>

    <img alt=" | " src="css/screen/icon_divider.png" />
    <a href="" title="reload"><img
        src="css/screen/icons/arrow_refresh_small.png"
        alt="[reload]"
    /></a>
  </div>
</xsl:template>


<!-- bottom status bar with timestamp -->
<xsl:template name="bottomStatusBar">
  <xsl:param name="timestamp" />

  <xsl:if test="$timestamp">
    &newline;
    <xsl:comment> Bottom status bar </xsl:comment>
    &newline;

    <div class="dividerBarAbove">
      <!-- Rendered: with acronym showing the XSLT version and vendor name -->
      <xsl:element name="acronym">
        <xsl:attribute name="title">
          <xsl:text>XSLT </xsl:text>
          <xsl:value-of select="format-number(number(system-property('xsl:version')), '0.0')" />
          <xsl:text> (</xsl:text>
          <xsl:value-of select="system-property('xsl:vendor')"/>
          <xsl:text>)</xsl:text>
        </xsl:attribute>
        <xsl:text>Rendered</xsl:text>
      </xsl:element>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="$timestamp"/>
    </div>
    &newline;
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
