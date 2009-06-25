<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
>
<!--
   | process config/config.xml and extract the matching cluster paths
   | also generate an xi:include element for querying jobs
   | the xi:include can be expanded (or not) later
-->

<!-- output declarations -->
<xsl:output method="xml" version="1.0" encoding="UTF-8"/>

<!-- XSL Parameters  -->
<xsl:param name="clusterName"/>
<xsl:param name="request"/>

<!-- get specific configuration parameters -->
<xsl:param name="clusterNode" select="//clusters/cluster[@name=$clusterName]"/>


<xsl:template match="/">
  <!-- mimic an aggregated structure -->
  <xsl:element name="aggregated">
    <xsl:element name="config">
      <xsl:copy-of select="$clusterNode"/>
      <xsl:copy-of select="//config/programs"/>
    </xsl:element>
    <xsl:apply-templates select="$clusterNode" mode="jobinfo"/>
  </xsl:element>
</xsl:template>


<!-- create a query that can be evaluated later via xinclude -->
<xsl:template match="cluster" mode="jobinfo">
  <xsl:param name="jobinfo" select="//config/programs/jobinfo"/>
  <xsl:if test="$jobinfo">
  <xsl:element name="xi:include">
    <xsl:attribute name="href">
    <xsl:value-of select="$jobinfo"/>?<xsl:if
      test="string-length($request)"><xsl:value-of
      select="$request"/>&amp;</xsl:if>ROOT=<xsl:value-of
      select="@root"/><xsl:if
      test="@cell != 'default'"
      ><xsl:text>&amp;</xsl:text>CELL=<xsl:value-of select="@cell"
      /></xsl:if>
    </xsl:attribute>
  </xsl:element>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>

