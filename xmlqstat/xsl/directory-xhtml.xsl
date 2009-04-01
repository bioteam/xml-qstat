<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
>
<!--
   | process the output from a directory generator
   | to create a list of hyperlinks
-->

<!-- output declarations -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

<!-- XSL Parameters  -->
<xsl:param name="dir"/>
<xsl:param name="prefix"/>


<xsl:template match="/" >
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Refresh" content="60" />
<link rel="icon" type="image/png" href="images/icons/silk/folder.png"/>
<title>dir - <xsl:value-of select="$dir"/></title>

<xsl:text>
</xsl:text>
</head><body>
<div class="main">
<strong>directory contents: <xsl:value-of select="$dir"/></strong>
<blockquote>
  <xsl:choose>
  <xsl:when test="/dir:directory">
    <xsl:apply-templates select="/dir:directory" />
  </xsl:when>
  <xsl:otherwise>
    directory does not exist or is empty
  </xsl:otherwise>
  </xsl:choose>
</blockquote>
<xsl:text>
</xsl:text>
</div>
</body></html>
</xsl:template>


<xsl:template match="/dir:directory">
  <xsl:element name="ul">

  <xsl:for-each select="dir:file">
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:if test="$prefix"><xsl:value-of select="$prefix"/>/</xsl:if>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
      </xsl:element>
    </xsl:element>
  </xsl:for-each>

  </xsl:element>
</xsl:template>

</xsl:stylesheet>
