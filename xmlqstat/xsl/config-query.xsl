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
<xsl:param name="queryURL"/>

<!-- get specific configuration parameters -->
<xsl:param name="clusterNode" select="//clusters/cluster[@name=$clusterName]"/>


<xsl:template match="/">
  <!-- mimic an aggregated structure -->
  <xsl:element name="aggregated">
    <xsl:element name="config">
      <xsl:copy-of select="$clusterNode"/>
    </xsl:element>
    <xsl:apply-templates select="$clusterNode" mode="qstatf"/>
  </xsl:element>
</xsl:template>


<!-- create a query that can be evaluated later via xinclude -->
<xsl:template match="cluster" mode="qstatf">
  <xsl:element name="xi:include">
    <xsl:attribute name="href">
    <xsl:value-of select="$queryURL"/><xsl:if
      test="@cell != 'default'"
      ><xsl:text>/~</xsl:text><xsl:value-of select="@cell"
      /></xsl:if><xsl:value-of
      select="@root"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>


</xsl:stylesheet>

