<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
>
<!--
   | process config/config.xml to generate an appropriate
   | xi:include element for querying jobs, which can be expanded later
   |
   | this is likely only useful for server-side transformations
   |
   | any xml expected - the relevant information is from the config file
   |
   | uses external files:
   |  - config/config.xml
   -->

<!-- ======================= Imports / Includes =========================== -->
<!-- Include our templates : needed for cgi-params -->
<xsl:include href="../xmlqstat-templates.xsl"/>

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
    select="document('../../config/config.xml')/config" />
<xsl:variable
    name="jobinfo"
    select="$configFile/programs/jobinfo"/>
<xsl:variable
    name="clusterNode"
    select="$configFile/clusters/cluster[@name=$clusterName]"/>

<xsl:variable name="root" select="$clusterNode/@root" />
<xsl:variable name="cell" select="$clusterNode/@cell" />
<xsl:variable name="base" select="$clusterNode/@baseURL" />

<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" version="1.0" encoding="UTF-8"/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/">

  <!-- define the redirect url -->
  <xsl:variable name="redirect">
    <xsl:choose>
    <xsl:when test="string-length($base)">
      <xsl:value-of select="$base" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$baseURL" />
    </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$resource" />
  </xsl:variable>


  <xsl:element name="xi:include">
  <xsl:attribute name="href">
    <xsl:choose>
    <xsl:when test="$mode = 'jobinfo' and string-length($jobinfo)">
      <!-- use jobinfo cgi script -->
      <!--
          | typically something like
          | http://<server>:<port>/xmlqstat/jobinfo?request
          | the url is expected to handle a missing request
          |   and treat it like '-j *' (show all jobs)
          -->
      <xsl:value-of select="$jobinfo"/>
      <xsl:text>?</xsl:text>
      <xsl:if test="$clusterNode">
        <xsl:call-template name="cgi-params">
          <xsl:with-param name="clusterNode" select="$clusterNode"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
    <!-- redirect (likely uses CommandGenerator) -->
    <!--
        | create a qstat query that can be evaluated later via xinclude
        | typically something like
        | http://<server>:<port>/xmlqstat/redirect.xml/~{sge_cell}/{sge_root}
        -->
      <xsl:value-of select="$redirect"/>
        <xsl:if test="not(string-length($base))">
          <xsl:if test="string-length($root)">
            <xsl:if test="$cell">
              <xsl:text>/~</xsl:text>
              <xsl:value-of select="$cell" />
            </xsl:if>
            <xsl:value-of select="$root"/>
          </xsl:if>
        </xsl:if>
      <xsl:text>?</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($request)">
      <xsl:text>&amp;</xsl:text>
      <xsl:value-of select="$request"/>
    </xsl:if>
  </xsl:attribute>
  </xsl:element>

</xsl:template>


</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
