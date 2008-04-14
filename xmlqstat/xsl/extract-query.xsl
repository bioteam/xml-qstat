<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<!-- output declarations -->
<xsl:output method="xml" version="1.0" encoding="UTF-8"/>

<xsl:template match="/">
  <xsl:apply-templates select="//detailed_job_info" />
  <xsl:apply-templates select="//query" />
</xsl:template>

<!-- Transcribe everything else verbatim -->
<xsl:template match="*|@*|comment()|text()">
  <xsl:copy><xsl:apply-templates/></xsl:copy>
</xsl:template>

</xsl:stylesheet>
