<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
>

<!-- output declarations -->
<xsl:output method="xml" version="1.0" encoding="UTF-8"/>

<!-- Import our templates -->
<xsl:include href="xmlqstat-templates.xsl"/>

<!-- Prep our configuration XML file(s) -->
<xsl:variable name="configFile" select="document('../config/config.xml')" />

<!-- XSL Parameters  -->
<xsl:param name="cluster"/>
<xsl:param name="query"/>

<!-- get specific configuration parameters -->
<xsl:param name="program"><xsl:value-of select="$configFile/config/jobinfoProgram"/></xsl:param>

<xsl:template match="/">
  <xsl:choose>
  <xsl:when test="count(//clusters/cluster[@name=$cluster])">
    <xsl:apply-templates select="//clusters/cluster[@name=$cluster]"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:element name="none"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cluster">

<!-- somewhat mimic the structure of aggregated qlicserver.xml + qstat.xml -->
<xsl:element name="aggregated">
  <xsl:element name="query">
    <xsl:element name="cluster">
      <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
      <xsl:attribute name="root"><xsl:value-of select="@root"/></xsl:attribute>
      <xsl:attribute name="cell"><xsl:value-of select="@cell"/></xsl:attribute>
    </xsl:element>
  </xsl:element>

  <xsl:element name="xi:include">
    <xsl:attribute name="href">
    <xsl:value-of select="//config/jobinfoProgram"/>?<xsl:if
      test="string-length($query)"><xsl:value-of
      select="$query"/>&amp;</xsl:if>SGE_ROOT=<xsl:value-of
      select="@root"/><xsl:if
      test="@cell != 'default'"
      ><xsl:text>&amp;</xsl:text>SGE_CELL=<xsl:value-of select="@cell"
      /></xsl:if>
    </xsl:attribute>
  </xsl:element>

</xsl:element>

</xsl:template>

</xsl:stylesheet>

