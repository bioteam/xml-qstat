<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
>
<!--
   | process the output from a directory generator
   | to create a list of hyperlinks
-->

<!-- ============================= Imports ================================ -->
<!-- Import our masthead -->
<xsl:import href="xmlqstat-masthead.xsl"/>


<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="dir"/>
<xsl:param name="prefix"/>


<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xhtml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/" >
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta http-equiv="Refresh" content="60" />
  <link rel="icon" type="image/png" href="images/icons/silk/folder.png"/>
  <link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
  <title>dir - <xsl:value-of select="$dir"/></title>

  <xsl:comment> Load CSS from a file </xsl:comment>
  <xsl:text>
  </xsl:text>
  <link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />

  <xsl:text>
  </xsl:text>
</head>

<!-- begin body -->
<body>
<xsl:text>
</xsl:text>
<div id="main">
<!-- Topomost Logo Div -->
<xsl:call-template name="topLogo"/>

<xsl:text>
</xsl:text>

<!-- Top Menu Bar -->
<div id="menu">
  <img class="leftSpace rightSpace"
      src="images/icons/silk/folder.png"
      alt="[folder]"
  />
  <strong><xsl:value-of select="$dir"/>/</strong>
</div>

<ul>
  <xsl:choose>
  <xsl:when test="/dir:directory">
    <xsl:apply-templates select="/dir:directory" />
  </xsl:when>
  <xsl:otherwise>
    <li>directory does not exist or is empty</li>
  </xsl:otherwise>
  </xsl:choose>
</ul>
<xsl:text>
</xsl:text>
</div>
</body></html>
<!-- end body/html -->
</xsl:template>


<xsl:template match="/dir:directory">
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
</xsl:template>

</xsl:stylesheet>
