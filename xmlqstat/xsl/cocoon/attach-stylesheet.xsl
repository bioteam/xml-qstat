<xsl:stylesheet version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!--
   | attach processing-instructions and stylesheet to incoming xml document
   -->

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="stylesheet"/>
<xsl:param name="xslt-parameters"/>
<xsl:param name="rawxml"/>

<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>

<!-- ============================ Matching ================================ -->

<xsl:template match="/">
  <!-- echo input xslt-param -->
  <!--
  <xsl:call-template name="echo-xslt-param">
    <xsl:with-param name="name"  select="'rawxml'"/>
    <xsl:with-param name="value" select="$rawxml"/>
  </xsl:call-template>
  <xsl:call-template name="echo-xslt-param">
    <xsl:with-param name="name"  select="'stylesheet'"/>
    <xsl:with-param name="value" select="$stylesheet"/>
  </xsl:call-template>
  -->

  <!-- extract xslt-parameters into xslt-param processing-instructions -->
  <xsl:if test="$xslt-parameters">
    <xsl:call-template name="create-pis">
      <xsl:with-param name="text" select="normalize-space($xslt-parameters)" />
    </xsl:call-template>
  </xsl:if>

  <!-- add stylesheet -->
  <xsl:if test="$stylesheet">
    <xsl:choose>
    <xsl:when test="$rawxml">
      <xsl:processing-instruction name="disabled-xml-stylesheet">
        <xsl:text>type="text/xml" href="</xsl:text>
        <xsl:value-of select="$stylesheet"/><xsl:text>"</xsl:text>
      </xsl:processing-instruction>
    </xsl:when>
    <xsl:otherwise>
      <xsl:processing-instruction name="xml-stylesheet">
        <xsl:text>type="text/xml" href="</xsl:text>
        <xsl:value-of select="$stylesheet"/><xsl:text>"</xsl:text>
      </xsl:processing-instruction>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

  <xsl:copy-of select="."/>
</xsl:template>

<!--
  echo xslt-param for debugging purposes
-->
<xsl:template name="echo-xslt-param">
  <xsl:param name="name" />
  <xsl:param name="value" />

  <xsl:processing-instruction name="echo-xslt-param">
     <!-- emit name="..." -->
     <xsl:text>name=&quot;</xsl:text>
       <xsl:value-of select="$name" />
     <xsl:text>&quot; </xsl:text>
     <!-- emit value="..." -->
     <xsl:text>value=&quot;</xsl:text>
       <xsl:value-of select="$value" />
     <xsl:text>&quot;</xsl:text>
  </xsl:processing-instruction>

</xsl:template>


<!--
  extract name="" value="" pairs from text
  and emit an <?xslt-param name="" value=""?> processing-instruction for each
-->
<xsl:template name="create-pi">
  <xsl:param name="text" />

  <xsl:variable name="rest" select="$text"/>
  <xsl:variable name="attr" select="'name='"/>

  <!-- string starts with name=.. -->
  <xsl:if test="starts-with($rest, $attr)">
    <xsl:variable name="len"   select="string-length($attr) + 1"/>
    <xsl:variable name="quote" select="substring($rest,$len,1)"/>

    <xsl:variable name="name"
        select="concat(substring($rest,1,$len),
           substring-before(substring($rest,$len+1),
           $quote), $quote)"
        />

    <xsl:variable name="rest"
      select="normalize-space(substring-after(substring($rest,$len+1), $quote))"/>

    <!-- string starts with value=.. -->
    <xsl:variable name="attr" select="'value='"/>
    <xsl:if test="starts-with($rest, $attr)">
      <xsl:variable name="len"   select="string-length($attr) + 1"/>
      <xsl:variable name="quote" select="substring($rest,7,1)"/>

      <xsl:variable name="value"
          select="concat(substring($rest,1,$len),
            normalize-space(substring-before(substring($rest,$len+1), $quote)),
            $quote)"
        />

      <xsl:variable name="rest"
         select="normalize-space(substring-after(substring($rest,$len+1), $quote))"/>

      <xsl:processing-instruction name="xslt-param">
         <xsl:value-of select="$name" />
         <xsl:text> </xsl:text>
         <xsl:value-of select="$value" />
      </xsl:processing-instruction>

      <xsl:call-template name="create-pi">
        <xsl:with-param name="text" select="$rest" />
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

</xsl:template>

<!--
  extract foo="value1" bar="value2" pairs from text
  and emit <?xslt-param name="foo" value="value1"?> etc, processing-instructions
-->
<xsl:template name="create-pis">
  <xsl:param name="text" />

  <xsl:variable name="rest" select="$text"/>
  <xsl:variable name="name" select="substring-before($rest,'=')"/>
  <xsl:variable name="len"  select="string-length($name) + 2"/>

  <!-- string started with foo=.. -->
  <xsl:if test="$len &gt; 2">
    <xsl:variable name="quote" select="substring($rest,$len,1)"/>

    <xsl:variable name="value"
        select="normalize-space(substring-before(substring($rest,$len+1), $quote))"
        />

    <xsl:variable name="rest"
      select="normalize-space(substring-after(substring($rest,$len+1), $quote))"/>

    <!-- do not output empty value strings -->
    <xsl:if test="string-length($value)">
      <xsl:processing-instruction name="xslt-param">
         <!-- emit name="..." -->
         <xsl:text>name=&quot;</xsl:text>
           <xsl:value-of select="$name" />
         <xsl:text>&quot; </xsl:text>
         <!-- emit value="..." -->
         <xsl:text>value=</xsl:text>
         <xsl:value-of select="$quote" />
           <xsl:value-of select="$value" />
         <xsl:value-of select="$quote" />
      </xsl:processing-instruction>
    </xsl:if>

    <xsl:call-template name="create-pis">
      <xsl:with-param name="text" select="$rest" />
    </xsl:call-template>
  </xsl:if>

</xsl:template>


</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
