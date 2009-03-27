<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns="http://www.w3.org/1999/xhtml"
>

<!-- output declarations -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

<!-- XSL Parameters  -->
<xsl:param name="parentDir"/>


<xsl:template match="/" >
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Refresh" content="30" />
<title>cache - <xsl:value-of select="$parentDir"/></title>

<xsl:text>
</xsl:text>
</head>
<xsl:text>
</xsl:text>

<body>

<xsl:apply-templates select="/dir:directory" />

<xsl:text>
</xsl:text>

</body></html>
</xsl:template>


<xsl:template match="/dir:directory">

  <xsl:element name="ul">

  <xsl:for-each select="dir:file">
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href"><xsl:value-of select="$parentDir"/>/<xsl:value-of select="@name"/></xsl:attribute>
        <xsl:value-of select="@name"/>
      </xsl:element>
    </xsl:element>

  </xsl:for-each>

  </xsl:element>

</xsl:template>

</xsl:stylesheet>
