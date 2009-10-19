<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!--
   | extract name/value processing instructions from documents
   | defaults to selecting mozilla-style xslt-param
   | For example,
   |
   | in main document:
   |   <?xslt-param name="title" value="my title"?>
   |   <?xml-stylesheet type="text/xml" href="foo.xsl"?>
   |
   | in stylesheet:
   |   <xsl:include href="pi-param.xsl"/>
   |   <xsl:param name="title">
   |     <xsl:call-template name="pi-param">
   |       <xsl:with-param  name="name"    select="'title'"/>
   |       <xsl:with-param  name="default" select="'default title'"/>
   |     </xsl:call-template>
   |   </xsl:param>
   -->

<!-- ========================= Named Templates ============================ -->

<!--
   |
   | extract attribute="..." from text
   |
-->
<xsl:template name="pi-parse-attribute">
  <xsl:param name="text" />
  <xsl:param name="attr" />

  <xsl:variable name="rest"
      select="substring-after($text, concat(' ', $attr, '='))"/>

  <xsl:value-of
      select="substring-before(substring($rest,2), substring($rest,1,1))"/>

</xsl:template>

<!--
   |
   |  hand-rolled parsing of <?xslt-param name=".." value=".." ?>
   |
-->
<xsl:template name="pi-param">
  <xsl:param name="pis" select="processing-instruction('xslt-param')" />
  <xsl:param name="name" />
  <xsl:param name="count">1</xsl:param>
  <xsl:param name="default" />

  <xsl:choose>
  <xsl:when test="$count &lt;= count($pis)">
    <xsl:variable
        name="text"
        select="concat(' ', normalize-space($pis[position()=$count]))"
    />

    <xsl:variable name="nameContent">
      <xsl:call-template name="pi-parse-attribute">
        <xsl:with-param name="text" select="$text"/>
        <xsl:with-param name="attr" select="'name'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
    <xsl:when test="$nameContent = $name">
      <xsl:call-template name="pi-parse-attribute">
        <xsl:with-param name="text" select="$text"/>
        <xsl:with-param name="attr" select="'value'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="pi-param">
        <xsl:with-param name="pis"   select="$pis" />
        <xsl:with-param name="name"  select="$name" />
        <xsl:with-param name="count" select="$count + 1" />
        <xsl:with-param name="default" select="$default" />
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <!-- nothing found: return the default -->
    <xsl:value-of select="$default"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
   |
   |  hand-rolled parsing of <?xxx foo=".." ?>
   |
-->
<xsl:template name="pi-named-param">
  <xsl:param name="pis" select="processing-instruction('xslt-param')" />
  <xsl:param name="name" />
  <xsl:param name="count">1</xsl:param>
  <xsl:param name="default" />

  <xsl:choose>
  <xsl:when test="$count &lt;= count($pis)">
    <xsl:variable
        name="text"
        select="concat(' ', normalize-space($pis[position()=$count]))"
    />

    <xsl:variable name="nameContent">
      <xsl:call-template name="pi-parse-attribute">
        <xsl:with-param name="text" select="$text"/>
        <xsl:with-param name="attr" select="$name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
    <xsl:when test="string-length($nameContent)">
      <xsl:value-of select="$nameContent"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="pi-named-param">
        <xsl:with-param name="pis"   select="$pis" />
        <xsl:with-param name="name"  select="$name" />
        <xsl:with-param name="count" select="$count + 1" />
        <xsl:with-param name="default" select="$default" />
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>

  </xsl:when>
  <xsl:otherwise>
    <!-- nothing found: return the default -->
    <xsl:value-of select="$default"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
