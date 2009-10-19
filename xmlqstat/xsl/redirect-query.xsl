<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
>
<!--
   | process config/config.xml to generate an appropriate
   | xi:include element for querying jobs, which can be expanded later
   |
   | this is likely only useful for server-side transformations
-->

<!-- ======================= Imports / Includes =========================== -->
<!-- Include our templates -->
<xsl:include href="xmlqstat-templates.xsl"/>

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="clusterName"/>
<xsl:param name="request"/>
<xsl:param name="mode"/>
<xsl:param name="resource" />
<xsl:param name="baseURL" />

<!-- ======================= Internal Parameters ========================== -->
<!-- configuration parameters -->
<xsl:variable
    name="configFile"
    select="document('../config/config.xml')/config" />
<xsl:variable
    name="jobinfo"
    select="$configFile/programs/jobinfo"/>
<xsl:variable
    name="clusterNode"
    select="$configFile/clusters/cluster[@name=$clusterName]"/>

<xsl:variable name="redirect">
  <xsl:value-of select="$baseURL" />
  <xsl:value-of select="$resource" />
</xsl:variable>

<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" version="1.0" encoding="UTF-8"/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/">
  <xsl:choose>
  <xsl:when test="$clusterNode">
    <xsl:choose>
    <xsl:when test="$mode = 'jobinfo' and string-length($jobinfo)">
      <!-- use jobinfo cgi script -->
      <xsl:apply-templates select="$clusterNode" mode="jobinfo"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- redirect (likely uses CommandGenerator) -->
      <xsl:apply-templates select="$clusterNode" mode="redirect"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <!-- provide default values -->
    <xsl:element name="xi:include">
      <xsl:attribute name="href">
        <xsl:choose>
        <xsl:when test="$mode = 'jobinfo' and string-length($jobinfo)">
          <!-- use jobinfo cgi script -->
          <xsl:value-of select="$jobinfo"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- redirect (likely uses CommandGenerator) -->
          <xsl:value-of select="$redirect"/>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length($request)">
          <xsl:text>?</xsl:text>
          <xsl:value-of select="$request"/>
        </xsl:if>
      </xsl:attribute>
    </xsl:element>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
   create a jobinfo query that can be evaluated later via xinclude
   typically something like
       http://<server>:<port>/xmlqstat/jobinfo?request
   the url is expected to handle a missing request
   and treat it like '-j *' (show all jobs)
-->
<xsl:template match="cluster" mode="jobinfo">
  <xsl:element name="xi:include">
    <xsl:attribute name="href">
      <xsl:value-of select="$jobinfo"/>
      <xsl:text>?</xsl:text>
      <xsl:call-template name="cgiParams">
        <xsl:with-param name="clusterNode" select="$clusterNode"/>
      </xsl:call-template>
      <xsl:if test="string-length($request)">
        <xsl:text>&amp;</xsl:text>
        <xsl:value-of select="$request"/>
      </xsl:if>
    </xsl:attribute>
  </xsl:element>
</xsl:template>


<!--
   create a qstat query that can be evaluated later via xinclude
   typically something like
       http://<server>:<port>/xmlqstat/redirect.xml/~{sge_cell}/{sge_root}
-->
<xsl:template match="cluster" mode="redirect">
  <xsl:element name="xi:include">
    <xsl:attribute name="href">
      <xsl:value-of select="$redirect"/>
      <xsl:if test="$clusterNode/@cell != 'default'">
        <xsl:text>/~</xsl:text>
        <xsl:value-of select="$clusterNode/@cell" />
      </xsl:if>
      <xsl:value-of select="$clusterNode/@root"/>
      <xsl:if test="string-length($request)">
        <xsl:text>?</xsl:text>
        <xsl:value-of select="$request"/>
      </xsl:if>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
