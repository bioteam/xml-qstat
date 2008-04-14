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

<!-- define a standard (corporate, institutional) logo to use -->
<xsl:template name="topLogo">
<div class="topLogo" style="clear:both; align=right;">
  <p>
<!--    <img src="images/emconTech.png" width="370" alt="logo" /> -->
    <img src="images/xml-qstat-logo.gif" width="150" alt="logo" />
  </p>
</div>
</xsl:template>

<!-- define a default xmlqstat local -->
<xsl:template name="xmlqstatLogo">
<div class="topLogo" style="clear:both; align=right;">
  <p>
    <img src="images/xml-qstat-logo.gif" width="150" alt="logo" />
  </p>
</div>
</xsl:template>

<!-- define top menu bar for navigation
     this version is optimized for use with qlicserver output
-->
<xsl:template name="topMenu">
  <xsl:param name="jobinfo" />
  <xsl:param name="hostinfo" />
  <xsl:param name="queueinfo" />

  <div id="menu" style="text-align:left;">
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="jobs.html" title="jobs"><img border="0"
        src="images/icons/silk/house.png"
        alt="[jobs]"
    /></a>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <!-- queueinfo: toggle between normal/more/less views -->
    <xsl:choose>
    <xsl:when test="$queueinfo = 'more'">
      <a href="queues.html" title="queue instances"><img border="0"
          src="images/icons/silk/chart_organisation_add.png"
          alt="[queue instances]"
      /></a>
    </xsl:when>
    <xsl:when test="$queueinfo = 'less'">
      <a href="queues.html?summary" title="queue summary"><img border="0"
          src="images/icons/silk/chart_organisation_delete.png"
          alt="[queue summary]"
      /></a>
    </xsl:when>
    <xsl:otherwise>
      <a href="queues.html?summary" title="queue summary"><img border="0"
          src="images/icons/silk/chart_organisation.png"
          alt="[queue summary]"
      /></a>
    </xsl:otherwise>
    </xsl:choose>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="resources.html" title="resources" ><img border="0"
        src="images/icons/silk/folder_database.png"
        alt="[resources]"
    /></a>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <!-- hostinfo: toggle between default/warn views -->
    <xsl:choose>
    <xsl:when test="$hostinfo = 'more'">
      <a href="queues.html" title="all queues"><img border="0"
          src="images/icons/silk/error_add.png"
          alt="[all queues]"
      /></a>
    </xsl:when>
    <xsl:when test="$hostinfo = 'less'">
      <a href="queues.html?warn" title="warn queues"><img border="0"
          src="images/icons/silk/error_delete.png"
          alt="[warn queues]"
      /></a>
    </xsl:when>
    <xsl:otherwise>
      <a href="queues.html?warn" title="warn queues"><img border="0"
          src="images/icons/silk/error.png"
          alt="[warn queues]"
      /></a>
    </xsl:otherwise>
    </xsl:choose>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <!-- jobinfo: toggle between more/less views -->
    <xsl:choose>
    <xsl:when test="$jobinfo = 'less'">
      <a href="jobs.html" title="jobs"><img border="0"
          src="images/icons/silk/magnifier_zoom_out.png"
          alt="[overview]"
      /></a>
    </xsl:when>
    <xsl:otherwise>
      <a href="jobinfo.html" title="job details"><img border="0"
          src="images/icons/silk/magnifier_zoom_in.png"
          alt="[job details]"
      /></a>
    </xsl:otherwise>
    </xsl:choose>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="" title="reload"><img border="0"
        src="images/icons/silk/arrow_refresh_small.png"
        alt="[reload]"
    /></a>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
  </div>
</xsl:template>

<!-- define top menu bar for navigation
     this version is works with the traditional xmlqstat navigation
     (using qstat -f output)
-->
<xsl:template name="xmlqstatMenu">
  <xsl:param name="path" />

  <div id="menu" style="text-align:middle;">
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="qstat-jobs.html" title="home" ><img border="0"
        src="images/icons/silk/house.png"
        alt="[jobs]"
    /></a>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="qstat-full.html" title="queue instances"><img border="0"
        src="images/icons/silk/server_chart.png"
        alt="[queue instances]"
    /></a>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="qstat-resources.html" title="resources" ><img border="0"
        src="images/icons/silk/folder_database.png"
        alt="[resources]"
    /></a>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="qstat-terse.html" title="cluster summary"><img border="0"
        src="images/icons/silk/layout.png"
        alt="[cluster summary]"
    /></a>
    <img alt="*"  src="images/icons/silk/bullet_blue.png" />
    <a href="info/about.html" title="about"><img border="0"
        src="images/icons/silk/information.png"
        alt="[about]"
    /></a>
    <!-- not yet written
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="info/help.html" title="help"><img border="0"
        src="images/icons/silk/help.png"
        alt="[help]"
    /></a>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="info/participate.html" title="participate"><img border="0"
        src="images/icons/silk/page_white_edit.png"
        alt="[notes]"
    /></a>
    -->
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
    <a href="" title="reload"><img border="0"
        src="images/icons/silk/arrow_refresh_small.png"
        alt="[reload]"
    /></a>
    <img alt="*" src="images/icons/silk/bullet_blue.png" />
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
    <div id="bottomBar">
      Rendered: <xsl:value-of select="$timestamp"/>
    </div>
    <xsl:text>
    </xsl:text>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
