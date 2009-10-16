<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
>
<!--
   | process config/config.xml to generate an appropriate
   | xi:include element for querying jobs, which can be expanded later
   |
   | this is likely only useful for server-side transformations, thus
   | we don't bother with using pi-param to get at the xslt-params
-->

<!-- ======================= Imports / Includes =========================== -->
<!-- NONE -->
<xsl:include href="xmlqstat-templates.xsl"/>

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="clusterName"/>
<xsl:param name="resource"/>
<xsl:param name="request"/>
<xsl:param name="baseURL"/>

<!-- ======================= Internal Parameters ========================== -->
<!-- configuration parameters -->
<xsl:variable
    name="clusterNode"
    select="document('../config/config.xml')/config/clusters/cluster[@name=$clusterName]"/>

<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" version="1.0" encoding="UTF-8"/>


<!-- ============================ Matching ================================ -->

<!--
   create a query that can be evaluated later via xinclude
   typically something like
       http://<server>:<port>/xmlqstat/redirect.xml/~{sge_cell}/{sge_root}
-->
<xsl:template match="/">
  <xsl:processing-instruction name="echo-xslt-param">
    <xsl:text>name=&quot;clusterName&quot; </xsl:text>
    <xsl:text>value=&quot;</xsl:text>
      <xsl:value-of select="$clusterName" />
    <xsl:text>&quot;</xsl:text>
  </xsl:processing-instruction>

  <xsl:element name="xi:include">
    <xsl:attribute name="href">
      <xsl:choose>
      <xsl:when test="$clusterNode">
        <xsl:variable name="root" select="$clusterNode/@root" />
        <xsl:variable name="cell" select="$clusterNode/@cell" />
        <xsl:variable name="base" select="$clusterNode/@baseURL" />

        <xsl:choose>
        <xsl:when test="string-length($base)">
          <xsl:value-of select="$base"/>
          <xsl:value-of select="$resource"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$baseURL"/>
          <xsl:value-of select="$resource"/>

          <!-- append the cell - a missing cell value should be treated
               as 'default' in downstream operations
               -->
          <xsl:if test="string-length($cell)">
             <xsl:text>/~</xsl:text><xsl:value-of select="$cell" />
          </xsl:if>
          <!-- append the root path -->
          <xsl:value-of select="$root"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$baseURL"/>
        <xsl:value-of select="$resource"/>
      </xsl:otherwise>
      </xsl:choose>

      <!-- append any requests -->
      <xsl:if test="string-length($request)">
        <xsl:text>?</xsl:text>
        <xsl:value-of select="$request"/>
      </xsl:if>
    </xsl:attribute>
    <!-- <xsl:attribute name="parse">xml</xsl:attribute> -->
  </xsl:element>

</xsl:template>

</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
