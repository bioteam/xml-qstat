<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
<!ENTITY  newline "<xsl:text>&#x0a;</xsl:text>">
<!ENTITY  space   "<xsl:text> </xsl:text>">
<!ENTITY  nbsp    "&#xa0;">
]>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0"
>
<!--
   | process output from a cocoon request generator:
   | In Apache Cocoon
   |   <map:generate type="request"/>
   |
   | extract <h:request target="..." >
   |
   | produce a custom "resource not found" page
   |
   -->

<!-- ======================= Imports / Includes =========================== -->
<!-- NONE -->

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="server-info" />

<!-- ======================= Internal Parameters ========================== -->
<!-- NONE -->


<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/" >
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
&newline;
<title> Resource Not Found </title>
</head>
&newline;

<body>
&newline;

<h1>Resource Not Found</h1>
Cannot resolve resource <b><xsl:value-of select="/h:request/@target"/></b>
<br/>
<hr/>
&newline;
<small><xsl:value-of select="$server-info"/></small>

&newline;
</body></html>
<!-- end body/html -->
</xsl:template>

</xsl:stylesheet>
<!-- =========================== End of File ============================== -->
