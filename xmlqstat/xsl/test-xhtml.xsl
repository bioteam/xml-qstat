<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
<!ENTITY  newline "<xsl:text>&#x0a;</xsl:text>">
<!ENTITY  space   "<xsl:text> </xsl:text>">
<!ENTITY  nbsp    "&#xa0;">
]>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<!--
   | misc browser/javascript tests
   |
   |
   | expected input:
   |   - any xml junk
   |
   | uses external files:
   |  - config/config.xml
   -->

<!-- ======================= Imports / Includes =========================== -->
<!-- Include our masthead and templates -->
<xsl:include href="xmlqstat-masthead.xsl"/>
<xsl:include href="xmlqstat-templates.xsl"/>
<!-- Include processor-instruction parsing -->
<xsl:include href="pi-param.xsl"/>

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="timestamp">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'timestamp'"/>
  </xsl:call-template>
</xsl:param>


<!-- ======================= Internal Parameters ========================== -->
<!-- NONE -->


<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="icon" type="image/png" href="css/screen/icons/information.png"/>
<title>test transformation</title>

&newline;
<xsl:comment> load javascript </xsl:comment>
&newline;
<!-- NB: <script> .. </script> needs some (any) content -->
<script src="javascript/cookie.js" type="text/javascript">
  // Dortch cookies
</script>
<script src="javascript/xmlqstat.js" type="text/javascript">
  // display altering code
</script>
&newline;
<!-- load css -->
<link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
</head>
&newline;


<!-- begin body -->
<body>

&newline;
<xsl:comment>Main body content</xsl:comment>
&newline;

<div id="main">
<!-- Topomost Logo Div -->
<blockquote>
  <b>If you see this text, the xslt transform has been applied.</b>
  <div id="javascript"/>
  <noscript>
    <div>javascript is not active</div>
  </noscript>
</blockquote>
<!-- Top Menu Bar -->
<div id="menu">
  <a href="./" title="home" class="leftSpace"><img
      src="css/screen/icons/house.png"
      alt="[home]"
  /></a>

  <img alt=" | " src="css/screen/icon_divider.png" />
  <a href="" title="reload"><img
      src="css/screen/icons/arrow_refresh_small.png"
      alt="[reload]"
  /></a>
</div>
&newline;

<xsl:call-template name="vendorInfoTable"/>

<xsl:call-template name="createTestTable">
  <xsl:with-param name="name"  select="'activeJobTable'"/>
</xsl:call-template>

<xsl:call-template name="createTestTable">
  <xsl:with-param name="name"  select="'pendingJobTable'"/>
</xsl:call-template>

&newline;
</div>
&newline;
<xsl:comment>This is the end of main content </xsl:comment>
&newline;

</body>
<!-- javascript tricks -->
<script type="text/javascript">
  // <![CDATA[
  {
      var text = 'javascript appears to be active; ';
      var cookies = document.cookie;
      if (cookies == null)
      {
         text += 'no cookies found';
      }
      else
      {
         text += 'cookie length=' + document.cookie.length;
      }
      text += '; activeJobTable=' + GetCookie('activeJobTable');
      text += '; pendingJobTable=' + GetCookie('pendingJobTable');

      document.getElementById('javascript').innerHTML = text;

      hideDivFromCookie('activeJobTable');
      hideDivFromCookie('pendingJobTable');
  }
  // ]]>
</script>

</html>
<!-- end body/html -->
</xsl:template>


<!--
  create vendor info table
 -->
<xsl:template name="vendorInfoTable">

  &newline;
  <blockquote>
  <table class="listing">
    <tr valign="middle">
    <td>
      <div class="tableCaption">
        Information about xslt transformation
      </div>
    </td>
    </tr>
  </table>
  &newline;
  <table class="listing">
  <tr>
    <th>xslt version</th>
    <th>vendor</th>
    <th>vendor url</th>
  </tr>
  &newline;
  <tr>
    <td>
       <xsl:value-of select="format-number(number(system-property('xsl:version')), '0.0')" />
    </td>
    <td><xsl:value-of select="system-property('xsl:vendor')"/></td>
    <td><xsl:value-of select="system-property('xsl:vendor-url')"/></td>
  </tr>
  </table>
  </blockquote>

</xsl:template>

<!--
  create test table
 -->
<xsl:template name="createTestTable">
  <xsl:param name="name" />

  &newline;
  <blockquote>

  <div>
     The table below should normally have 3 rows.
     <ul>
     <li>
       The table caption, with -/+ buttons (if javascript is enabled)
     </li>
     <li>The table headings</li>
     <li>The table contents</li>
     </ul>
     If only the table caption is visible, try toggling the visibility
     with the -/+ buttons.
     If only the table caption is visible and there are no buttons,
     this means the cookie was set and we cannot use javascript to
     turn it back off (buggy behaviour).
  </div>

  <table class="listing">
    <tr valign="middle">
    <td>
      <div class="tableCaption">
        test <xsl:value-of select="$name"/> display
      </div>
      <!-- show/hide activeJobTable via javascript -->
      <xsl:call-template name="toggleElementVisibility">
        <xsl:with-param name="name"  select="$name"/>
      </xsl:call-template>
    </td>
    </tr>
  </table>

  &newline;
  <div>
    <xsl:attribute name="id"><xsl:value-of select="$name"/></xsl:attribute>
    <table class="listing">
    <tr>
      <th>table name</th>
      <th>head2</th>
      <th>head3</th>
      <th>head4</th>
    </tr>
    &newline;
    <tr>
      <td><xsl:value-of select="$name"/></td>
      <td><xsl:value-of select="$name"/></td>
      <td><xsl:value-of select="$name"/></td>
      <td><xsl:value-of select="$name"/></td>
    </tr>
    </table>
  </div>
  </blockquote>
  &newline;
</xsl:template>


</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
