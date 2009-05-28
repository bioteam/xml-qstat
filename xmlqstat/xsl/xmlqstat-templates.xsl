<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dt="http://xsltsl.org/date-time"
    xmlns:str="http://xsltsl.org/string"
    exclude-result-prefixes="dt str"
>
<!--
   | A collection of named templates with various useful
   | functions
-->

<!-- output declarations -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

<!--
   |
   | count the number of tokens in a delimited list
   |
   -->
<xsl:template name="count-tokens">
  <xsl:param name="string"/>
  <xsl:param name="delim"/>
  <xsl:choose>
  <xsl:when test="contains($string, $delim)">
    <xsl:variable name="summation">
      <xsl:call-template name="count-tokens">
        <xsl:with-param name="string" select="substring-after($string, $delim)" />
        <xsl:with-param name="delim" select="$delim" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="1 + $summation"/>
  </xsl:when>
  <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
   |
   | count the number of slots multiplied by the task information
   |
   -->
<xsl:template name="count-slots">
  <xsl:param name="nodeList"/>
  <xsl:choose>
  <xsl:when test="count($nodeList)">
    <xsl:variable name="first" select="$nodeList[1]"/>
    <xsl:variable name="summation">
      <xsl:call-template name="count-slots">
        <xsl:with-param name="nodeList" select="$nodeList[position()!=1]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="slots" select="$first/slots"/>
    <xsl:variable name="tasks" select="$first/tasks"/>
    <xsl:variable name="nTasks">
      <xsl:choose>
      <xsl:when test="contains($tasks, ':')">
        <!-- handle n-m:s -->
        <xsl:variable name="min"  select="substring-before($tasks,'-')"/>
        <xsl:variable name="max"  select="substring-before(substring-after($tasks,'-'), ':')"/>
        <xsl:variable name="step" select="substring-after($tasks,':')"/>
        <xsl:choose>
        <xsl:when test="$step &gt; 1">
          <!-- eg 2-6:2 = 3 -->
          <xsl:value-of select="1 + ($max - $min) div $step"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- safety: step-size 1 (or missing?), eg 2-7:1 = 6 -->
          <xsl:value-of select="1 + ($max - $min)"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="contains($tasks, ',')">
        <!-- comma-separated list: count the tokens -->
        <xsl:call-template name="count-tokens">
          <xsl:with-param name="string" select="$tasks" />
          <xsl:with-param name="delim" select="','" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$slots * $nTasks + $summation"/>
  </xsl:when>
  <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- show/hide a particular 'div' element -->
<xsl:template name="toggleElementVisibility">
  <xsl:param name="name" />

  <div class="toggleVisibility">
    <xsl:element name="a">
      <xsl:attribute name="href">#</xsl:attribute>
      <xsl:attribute name="onclick">javascript:setDiv('<xsl:value-of select="$name"/>',false)</xsl:attribute>
<!--
      <img border="0" src="images/uparrow.gif" alt="[hide]" title="hide" />
      <img border="0" src="images/icons/silk/delete.png" alt="[hide]" title="hide" />
-->
      <img border="0" src="images/icons/silk/bullet_toggle_minus.png" alt="[hide]" title="hide" />
    </xsl:element>
    <xsl:element name="a">
      <xsl:attribute name="href">#</xsl:attribute>
      <xsl:attribute name="onclick">javascript:setDiv('<xsl:value-of select="$name"/>',true)</xsl:attribute>
<!--
      <img border="0" src="images/dnarrow.gif" alt="[show]" title="show" />
      <img border="0" src="images/icons/silk/add.png" alt="[show]" title="show" />
-->
      <img border="0" src="images/icons/silk/bullet_toggle_plus.png" alt="[show]" title="show" />
    </xsl:element>
  </div>

</xsl:template>

<!--
   | progressBar with size 'percent'
   | title (mouse help) and label
   -->
<xsl:template name="progressBar">
  <xsl:param name="title" />
  <xsl:param name="label" />
  <xsl:param name="percent" />
  <xsl:param name="background" />

  <div class="progbarOuter" style="width:100px;">
    <xsl:element name="div">
      <xsl:if test="$percent &gt; 0">
        <xsl:attribute name="class">progbarInner</xsl:attribute>
        <xsl:attribute name="style">
          width: <xsl:value-of select="format-number($percent,'##0.#')"/>%;
          <xsl:if test="$background">
            background: <xsl:value-of select="$background"/>;
          </xsl:if>
        </xsl:attribute>
      </xsl:if>
      <div class="progbarFont">
        <xsl:choose>
        <xsl:when test="$title">
          <span style="cursor:help;">
            <xsl:element name="acronym">
              <xsl:attribute name="title"><xsl:value-of select="$title"/></xsl:attribute>
              <xsl:value-of select="$label" />
            </xsl:element>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$label" />
        </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:element>
  </div>
</xsl:template>



<!--
   | simple means of handling memory with a 'G', 'M' and 'K' suffix
   | and displaying a progressBar (slider)
   -->
<xsl:template name="memoryCalculate">
  <xsl:param name="memUsed" />
  <xsl:param name="memTotal" />

  <xsl:param name="memoryUsed">
    <xsl:choose>
      <xsl:when test="contains($memUsed, '-')">
        0
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$memUsed" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:param name="memoryTotal">
    <xsl:choose>
      <xsl:when test="contains($memTotal, '-')">
        0
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$memTotal" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:variable
      name="rawSuffix"
      select="substring($memoryUsed, string-length($memoryUsed))"
  />

  <!-- suffix (G, M, K) -->
  <xsl:variable name="suffixUsed">
    <xsl:choose>
    <xsl:when test="contains($rawSuffix, 'G')">
      <xsl:value-of select="$rawSuffix"/>
    </xsl:when>
    <xsl:when test="contains($rawSuffix, 'M')">
      <xsl:value-of select="$rawSuffix"/>
    </xsl:when>
    <xsl:when test="contains($rawSuffix, 'K')">
      <xsl:value-of select="$rawSuffix"/>
    </xsl:when>
    <xsl:otherwise>
      0
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable
      name="rawSuffix"
      select="substring($memoryTotal, string-length($memoryTotal))"
  />

  <xsl:variable name="suffixTotal">
    <xsl:choose>
    <xsl:when test="contains($rawSuffix, 'G')">
      <xsl:value-of select="$rawSuffix"/>
    </xsl:when>
    <xsl:when test="contains($rawSuffix, 'M')">
      <xsl:value-of select="$rawSuffix"/>
    </xsl:when>
    <xsl:when test="contains($rawSuffix, 'K')">
      <xsl:value-of select="$rawSuffix"/>
    </xsl:when>
    <xsl:otherwise>
      0
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- prefix (value) -->
  <xsl:variable name="valueUsed">
    <xsl:choose>
    <xsl:when test="$suffixUsed">
      <xsl:value-of
          select="substring($memoryUsed, 0, string-length($memoryUsed))"
      />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$memoryUsed"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- prefix (value) -->
  <xsl:variable name="valueTotal">
    <xsl:choose>
    <xsl:when test="$suffixTotal">
      <xsl:value-of
          select="substring($memoryTotal, 0, string-length($memoryTotal))"
      />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$memoryTotal"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$suffixUsed = $suffixTotal">
    <xsl:call-template name="progressBar">
      <xsl:with-param name="title" select="concat($memoryUsed, ' used')" />
      <xsl:with-param name="label" select="$memoryTotal" />
      <xsl:with-param name="percent"
        select="($valueUsed div $valueTotal)*100"
      />
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="($suffixTotal = 'G' and $suffixUsed = 'M') or ($suffixTotal = 'M' and $suffixUsed = 'K')">
    <xsl:call-template name="progressBar">
      <xsl:with-param name="title" select="concat($memoryUsed,' used')" />
      <xsl:with-param name="label" select="$memoryTotal" />
      <xsl:with-param name="percent"
        select="($valueUsed div ($valueTotal * 1024)) * 100"
      />
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="progressBar">
      <xsl:with-param name="title" select="concat($memoryUsed,' used')" />
      <xsl:with-param name="label" select="$memoryTotal" />
      <xsl:with-param name="percent" select="0" />
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
    change the style (background color, font) based on the queue status
-->
<xsl:template name="queue-state-style">
  <xsl:param name="state"/>
  <xsl:choose>
  <!-- 'u' unavailable state : alarm state -->
  <xsl:when test="contains($state, 'u')" >
    <xsl:attribute name="class">alarmState</xsl:attribute>
  </xsl:when>
  <!-- 'E' error : error state -->
  <xsl:when test="contains($state, 'E')" >
    <xsl:attribute name="class">errorState</xsl:attribute>
  </xsl:when>
  <!-- 'a' alarm state : warn color -->
  <xsl:when test="contains($state, 'a')" >
    <xsl:attribute name="class">warnState</xsl:attribute>
  </xsl:when>
  <!-- 'd' disabled state : empty color -->
  <xsl:when test="contains($state, 'd')" >
    <xsl:attribute name="class">disableState</xsl:attribute>
  </xsl:when>
  <!-- 'S' suspended -->
  <xsl:when test="contains($state, 'S')" >
    <xsl:attribute name="class">suspendState</xsl:attribute>
  </xsl:when>
  </xsl:choose>
</xsl:template>


<!--
   choose an appropriate icon based on the status of queues
-->
<xsl:template name="queue-state-icon">
  <xsl:param name="state"/>
  <xsl:choose>
  <!-- 'u' unavailable state : alarm color -->
  <xsl:when test="contains($state, 'u')" >
    <img alt="(u)" src="images/icons/silk/exclamation.png"/>
  </xsl:when>
  <xsl:when test="contains($state, 'E')" >
    <img alt="(E)" src="images/icons/silk/exclamation.png"/>
  </xsl:when>
  <!-- 'a' alarm state : warn color -->
  <xsl:when test="contains($state, 'a')" >
    <img alt="(a)" src="images/icons/silk/error.png"/>
  </xsl:when>
  <!-- 'd' disabled state : empty color -->
  <xsl:when test="contains($state, 'd')" >
    <img alt="(d)" src="images/icons/silk/cancel.png" />
  </xsl:when>
  <!-- 'S' suspended -->
  <xsl:when test="contains($state, 'S')" >
    <img alt="(S)" src="images/icons/silk/control_pause.png" />
  </xsl:when>
  <!-- default -->
  <xsl:otherwise>
    <!-- <img alt="" src="images/icons-silk-empty.png" /> -->
    <img alt="(ok)" src="images/icons/silk/tick.png" />
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
    display the queue status with brief explanation
-->
<xsl:template name="queue-state-explain">
  <xsl:param name="state"/>

  <xsl:choose>
  <!-- 'u' unavailable state : alarm color -->
  <xsl:when test="contains($state, 'u')" >
    <span style="cursor:help;">
      <acronym title="This queue instance is in ALARM/UNREACHABLE state. Is SGE running on this node?">
        <xsl:value-of select="$state"/>
      </acronym>
    </span>
  </xsl:when>
  <!-- 'E' error : alarm color -->
  <xsl:when test="contains($state, 'E')" >
    <span style="cursor:help;">
      <acronym title="This queue instance is in ERROR state. Check node!">
        <xsl:value-of select="$state"/>
      </acronym>
    </span>
  </xsl:when>
  <!-- 'a' alarm state : warn color -->
  <xsl:when test="contains($state, 'a')" >
    <span style="cursor:help;">
      <acronym title="This queue instance is in ALARM state.">
        <xsl:value-of select="$state"/>
      </acronym>
    </span>
  </xsl:when>
  <!-- 'd' disabled state : empty color -->
  <xsl:when test="contains($state, 'd')" >
    <span style="cursor:help;">
      <acronym title="This queue has been disabled by a grid administrator">
        <xsl:value-of select="$state"/>
      </acronym>
    </span>
  </xsl:when>
  <!-- 'S' suspended -->
  <xsl:when test="contains($state, 'S')" >
    <span style="cursor:help;">
      <acronym title="Queue is (S)uspended">
        <xsl:value-of select="$state"/>
      </acronym>
    </span>
  </xsl:when>
  <!-- default -->
  <xsl:otherwise>
    <xsl:value-of select="$state"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
    transform 'queue@host.domain.name' to 'queue@hostname'
-->
<xsl:template name="unqualifiedQueue">
  <xsl:param name="queue" />
  <xsl:choose>
  <xsl:when test="contains($queue, '@@')">
    <!-- change queue@@hostgroup untouched -->
    <xsl:value-of select="$queue"/>
  </xsl:when>
  <xsl:when test="contains($queue, '@')">
    <!-- change queue@host.domain.name to queue@host -->
    <xsl:value-of
        select="substring-before($queue, '@')"
    />@<xsl:value-of
        select="substring-before(substring-after($queue,'@'),'.')"
    />
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$queue"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
    transform 'host.domain.name' to 'hostname'
-->
<xsl:template name="unqualifiedHost">
  <xsl:param name="host" />
  <xsl:value-of select="substring-before($host,'.')"/>
</xsl:template>

<!--
  display a shorter name with the longer name via mouseover
-->
<xsl:template name="shortName">
  <xsl:param name="name" />
  <xsl:param name="length" select="24"/>

  <xsl:choose>
  <xsl:when test="string-length($name) &gt; $length">
    <span style="cursor:help;">
    <xsl:element name="acronym">
      <xsl:attribute name="title">
        <xsl:value-of select="$name" />
      </xsl:attribute>
      <xsl:value-of select="substring($name,0,$length)" /> ...
    </xsl:element>
    </span>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$name" />
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
