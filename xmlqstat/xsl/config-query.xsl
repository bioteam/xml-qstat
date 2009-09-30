<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
>
<!--
   | process config/config.xml and extract the matching cluster paths
   | also generate an xi:include element for querying jobs
   | the xi:include can be expanded (or not) later
-->

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="clusterName"/>
<xsl:param name="redirect"/>
<xsl:param name="request"/>
<xsl:param name="mode"/>

<!-- ======================= Internal Parameters ========================== -->
<!-- configuration parameters -->
<xsl:param name="clusterNode" select="//clusters/cluster[@name=$clusterName]"/>
<xsl:param name="jobinfo" select="//config/programs/jobinfo"/>

<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" version="1.0" encoding="UTF-8"/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/">
  <!-- mimic an aggregated structure -->
  <xsl:element name="aggregated">
    <xsl:element name="config">
      <xsl:copy-of select="$clusterNode"/>
      <xsl:copy-of select="//config/programs"/>
    </xsl:element>

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

  </xsl:element>
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
      <xsl:text>?ROOT=</xsl:text><xsl:value-of select="@root"/>
      <xsl:if test="@cell != 'default'">
        <xsl:text>&amp;CELL=</xsl:text>
        <xsl:value-of select="@cell"/>
      </xsl:if>
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
      <xsl:if test="@cell != 'default'">
        <xsl:text>/~</xsl:text>
        <xsl:value-of select="@cell" />
      </xsl:if>
      <xsl:value-of select="@root"/>
      <xsl:if test="string-length($request)">
        <xsl:text>?</xsl:text>
        <xsl:value-of select="$request"/>
      </xsl:if>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
