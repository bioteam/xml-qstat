<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
>

<!-- output declarations -->
<xsl:output method="xhtml" indent="yes" version="4.01" encoding="ISO-8859-1"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

<!-- XSL Parameters   -->
<xsl:param name="timestamp"/>


<xsl:template match="/">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<xsl:text>
</xsl:text>
<head> 
<xsl:text>
</xsl:text>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<xsl:text>
</xsl:text>
<title><xsl:value-of select="/content/title"/></title>
<xsl:text>

</xsl:text>

<xsl:comment>Load our CSS from a file now ...</xsl:comment>
<xsl:text>
</xsl:text>
<link href="../css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
<xsl:text>
</xsl:text>
<xsl:comment>Locally override some CSS settings ...</xsl:comment>
<xsl:text>
</xsl:text>
<style type="text/css">
#main ul {
	list-style-image: url(../images/icons/silk/bullet_blue.png);
}	
</style>
<xsl:text>
</xsl:text>
</head>
<xsl:text>
</xsl:text>
<body>
<xsl:text>
</xsl:text>

<xsl:text>
</xsl:text>   
<xsl:comment>Main body content</xsl:comment>
<xsl:text>
</xsl:text>
<div id="main"> 
<xsl:text>

</xsl:text>
<xsl:comment>Topomost Logo Div</xsl:comment>
<xsl:text>
</xsl:text>
<div class="unnamed1" id="test1" style="clear:both;text-align:middle;">
<xsl:text>
</xsl:text> 
<p><img src="../images/xml-qstat-logo.gif" width="150" alt="xml qstat logo" /></p>
<xsl:text>
</xsl:text>
   </div>     
<xsl:text>

</xsl:text>
<xsl:text>
</xsl:text> 
<xsl:comment>Top Menu Bar </xsl:comment>
<xsl:text>
</xsl:text>
    <div id="menu" style="text-align:middle;">
<xsl:text>
</xsl:text>
<img alt="*" src="../images/icons/silk/bullet_blue.png" />
<a href="../qstat.html" title="Home" ><img alt=""  src="../images/icons/silk/house.png" border="0" /></a>
<xsl:text>
</xsl:text>
<img alt="*"  src="../images/icons/silk/bullet_blue.png" />
<a href="" title="Reload" ><img alt=""  src="../images/icons/silk/arrow_rotate_clockwise.png" border="0" /></a>
<xsl:text>
</xsl:text>
      <img alt="*"  src="../images/icons/silk/bullet_blue.png" />
       <a href="../qstat-terse.html" title="View terse output format" ><img alt=""  src="../images/icons/silk/table.png" border="0" /></a>
<xsl:text>
</xsl:text>
     <img alt="*"  src="../images/icons/silk/bullet_blue.png" />
       <a href="../info/about.html" title="About"><img alt=""  src="../images/icons/silk/information.png" border="0" /></a>
<xsl:text>
</xsl:text>
     <img alt="*"  src="../images/icons/silk/bullet_blue.png" />
       <a href="../info/help.html" title="Help"><img alt=""  src="../images/icons/silk/help.png" border="0" /></a>
<xsl:text>
</xsl:text>
     <img alt="*"  src="../images/icons/silk/bullet_blue.png" />
       <a href="../info/participate.html" title="Participate" ><img alt=""  src="../images/icons/silk/page_white_edit.png" border="0" /></a>
<xsl:text>
</xsl:text>
     <img alt="*"  src="../images/icons/silk/bullet_blue.png" />
<xsl:text>
</xsl:text> 
    </div>
<xsl:text>

</xsl:text> 
<xsl:comment> Top dotted line bar</xsl:comment>
<xsl:text>
</xsl:text>
    <div id="upperBar"><xsl:text> </xsl:text>
<xsl:text>
</xsl:text> 
    </div>
<xsl:text>
</xsl:text>


<!-- stuff above is XHTML boilerplate for the basic page layout-->

<!-- BEGIN INFO STUFF HERE  -->

<blockquote>
<h2 class="infoHeading"><xsl:value-of select="/content/heading"/></h2>
</blockquote>


<!-- create a table of contents -->
<blockquote>
<ul>
 <xsl:apply-templates select="//section" mode="toc" />
</ul>
</blockquote>


<!-- now we process each paragraph of our intended content -->
<blockquote>
<xsl:apply-templates select="//section"/>
</blockquote>

<!-- END INFO STUFF HERE -->


<!-- stuff below is XHTML boilerplate for the basic page layout -->

<xsl:text>

</xsl:text>
<xsl:comment>Bottom status bar</xsl:comment>
<xsl:text>
</xsl:text>
<div id="bottomBar">
     Rendered: <xsl:value-of select="$timestamp"/>
</div>
<xsl:text>

</xsl:text>
</div> <xsl:comment>This is the end of main content </xsl:comment>
<xsl:text>

</xsl:text><xsl:comment>bottom box section </xsl:comment>
<xsl:text>
</xsl:text>
<div class="bottomBox">
 <a href="../psp/qstat.html" title="Format for Sony PSP Web Browser"><img alt="XHTML-PSP" src="../images/sonyPSP.gif" border="0" /></a>
<xsl:text>
</xsl:text> 
<a href="../info/rss-feeds.html" title="List RSS Feeds"><img alt="RSS-Feeds" src="../images/rssAvailable.gif" border="0" /></a> 
</div>
<xsl:text>
</xsl:text>   
</body>  
<xsl:text>
</xsl:text>
</html>
</xsl:template>

<xsl:template match="section" mode="toc">
<li><xsl:element name="a"><xsl:attribute name="href">#<xsl:value-of select="position()"/></xsl:attribute><xsl:value-of select="sectionHead"/></xsl:element></li>
</xsl:template>


<xsl:template match="section"  >

<!-- create a name anchor we can use if we ever get around to 
     automatically makinga table of contents 
-->
<xsl:element name="a"><xsl:attribute name="name"><xsl:value-of select="position()"/></xsl:attribute></xsl:element>
 
 <h3 class="infoSectionHead"><xsl:value-of select="sectionHead"/></h3>
 <xsl:apply-templates select="./para"/>
 
</xsl:template>

<xsl:template match="para"  >

<xsl:text>
</xsl:text>
<div class="infoPara" ><br/>
 <xsl:value-of select="." disable-output-escaping="yes" />
<xsl:text>
</xsl:text>
</div>
<xsl:text>
</xsl:text>


</xsl:template>


</xsl:stylesheet>