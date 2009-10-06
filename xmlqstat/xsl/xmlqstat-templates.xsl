<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
>
<!--
   | A collection of Named Templates with various useful functions
-->


<!-- ========================= Named Templates ============================ -->

<!--
   |
   | extract @root @cell from clusterNode
   | format into "&ROOT=@root&CELL=@cell" for cgi queries
   -->
<xsl:template name="cgiParams">
  <xsl:param name="clusterNode"/>

  <xsl:if test="$clusterNode/@root"
    >&amp;ROOT=<xsl:value-of
    select="$clusterNode/@root"/><xsl:if
    test="$clusterNode/@cell != 'default'"
    >&amp;CELL=<xsl:value-of select="$clusterNode/@cell"/></xsl:if>
  </xsl:if>
</xsl:template>


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
        <xsl:with-param name="delim"  select="$delim" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="1 + $summation"/>
  </xsl:when>
  <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
   |
   | count the number of jobs
   | use string-length as a cheap hack to summarize the values
   |
   -->
<xsl:template name="count-jobs">
  <xsl:param name="nodeList"/>

  <xsl:variable name="count">
    <xsl:for-each select="$nodeList">
      <xsl:variable name="jobId" select="JB_job_number"/>
      <xsl:variable name="thisNode" select="generate-id(.)"/>
      <xsl:variable name="allNodes" select="key('job-summary', $jobId)"/>
      <xsl:variable name="firstNode" select="generate-id($allNodes[1])"/>
      <xsl:choose>
      <xsl:when test="$thisNode = $firstNode">1</xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  <xsl:value-of select="string-length($count)"/>
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
        <xsl:variable name="min"  select="number(substring-before($tasks,'-'))"/>
        <xsl:variable name="max"  select="number(substring-before(substring-after($tasks,'-'), ':'))"/>
        <xsl:variable name="step" select="number(substring-after($tasks,':'))" />
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
      <img border="0" src="images/icons/silk/bullet_toggle_minus.png" alt="[hide]" title="hide" />
    </xsl:element>
    <xsl:element name="a">
      <xsl:attribute name="href">#</xsl:attribute>
      <xsl:attribute name="onclick">javascript:setDiv('<xsl:value-of select="$name"/>',true)</xsl:attribute>
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
  <xsl:param name="class" />

  <div class="progbarOuter" style="width:100px;">
    <xsl:element name="div">
      <xsl:if test="$percent &gt; 0">
        <xsl:attribute name="class">progbarInner <xsl:if test="$class"><xsl:value-of select="$class"/></xsl:if></xsl:attribute>
        <xsl:attribute name="style">width:<xsl:value-of select="format-number($percent,'##0.#')"/>%;</xsl:attribute>
      </xsl:if>
      <xsl:choose>
      <xsl:when test="$title">
        <xsl:element name="acronym">
          <xsl:attribute name="title"><xsl:value-of select="$title"/></xsl:attribute>
          <xsl:value-of select="$label" />
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$label" />
      </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </div>
</xsl:template>


<!--
   | simple means of handling memory with a 'G', 'M' and 'K' suffix
   | and displaying a progressBar (slider)
   -->
<xsl:template name="memoryUsed">
  <xsl:param name="used" />
  <xsl:param name="total" />

  <xsl:param name="memoryUsed">
    <xsl:choose>
    <xsl:when test="contains($used, '-')">0</xsl:when>
    <xsl:otherwise><xsl:value-of select="$used" /></xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:param name="memoryTotal">
    <xsl:choose>
    <xsl:when test="contains($total, '-')">0</xsl:when>
    <xsl:otherwise><xsl:value-of select="$total" /></xsl:otherwise>
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
    <xsl:otherwise>0</xsl:otherwise>
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
    <xsl:otherwise>0</xsl:otherwise>
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
  <xsl:when test="
      ($suffixTotal = 'G' and $suffixUsed = 'M') or
      ($suffixTotal = 'M' and $suffixUsed = 'K')">
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
  <xsl:when test="contains($state, 'u')">
    <xsl:attribute name="class">alarmState</xsl:attribute>
  </xsl:when>
  <xsl:when test="contains($state, 'E')">
    <xsl:attribute name="class">errorState</xsl:attribute>
  </xsl:when>
  <xsl:when test="contains($state, 'a')">
    <xsl:attribute name="class">warnState</xsl:attribute>
  </xsl:when>
  <xsl:when test="contains($state, 'd')">
    <xsl:attribute name="class">disableState</xsl:attribute>
  </xsl:when>
  <xsl:when test="contains($state, 'S')">
    <xsl:attribute name="class">suspendState</xsl:attribute>
  </xsl:when>
  </xsl:choose>
</xsl:template>


<!--
   choose an appropriate icon based on the status of queues
-->
<xsl:template name="queue-state-icon">
  <xsl:param name="state"/>

  <xsl:element name="img">
    <xsl:attribute name="title"><xsl:value-of select="$state"/></xsl:attribute>
    <xsl:attribute name="alt">(<xsl:value-of select="$state"/>) </xsl:attribute>
    <xsl:attribute name="src">images/icons/silk/<xsl:choose>
      <xsl:when test="contains($state, 'd')">delete.png</xsl:when>
      <xsl:when test="contains($state, 'E')">exclamation.png</xsl:when>
      <xsl:when test="contains($state, 'u')">cross.png</xsl:when>
      <xsl:when test="contains($state, 'a')">error.png</xsl:when>
      <xsl:when test="contains($state, 'S')">control_pause.png</xsl:when>
      <xsl:otherwise>tick.png</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:element>
</xsl:template>


<!--
    display the queue status with brief explanation
-->
<xsl:template name="queue-state-explain">
  <xsl:param name="state"/>

  <xsl:choose>
  <xsl:when test="contains($state, 'u')" >
    <!-- 'u' unavailable state : alarm color -->
    <acronym title="This queue instance is in ALARM/UNREACHABLE state. Is SGE running on this node?">
      <xsl:value-of select="$state"/>
    </acronym>
  </xsl:when>
  <xsl:when test="contains($state, 'E')" >
    <!-- 'E' error : alarm color -->
    <acronym title="This queue instance is in ERROR state. Check node!">
      <xsl:value-of select="$state"/>
    </acronym>
  </xsl:when>
  <xsl:when test="contains($state, 'a')" >
    <!-- 'a' alarm state : warn color -->
    <acronym title="This queue instance is in ALARM state.">
      <xsl:value-of select="$state"/>
    </acronym>
  </xsl:when>
  <xsl:when test="contains($state, 'd')" >
    <!-- 'd' disabled state : empty color -->
    <acronym title="This queue has been disabled by a grid administrator">
      <xsl:value-of select="$state"/>
    </acronym>
  </xsl:when>
  <xsl:when test="contains($state, 'S')" >
    <!-- 'S' suspended -->
    <acronym title="Queue is (S)uspended">
      <xsl:value-of select="$state"/>
    </acronym>
  </xsl:when>
  <xsl:otherwise>
    <!-- default -->
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
    <xsl:value-of select="substring-before($queue, '@')"/>
    <xsl:text>@</xsl:text>
    <xsl:variable name="trailing" select="substring-after($queue,'@')"/>
    <xsl:choose>
    <xsl:when test="contains($trailing, '.')">
      <xsl:value-of select="substring-before($trailing,'.')"/>
    </xsl:when>
    <xsl:otherwise>
       <xsl:value-of select="$trailing"/>
    </xsl:otherwise>
    </xsl:choose>
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

  <xsl:choose>
  <xsl:when test="contains($host, '.')">
    <xsl:value-of select="substring-before($host,'.')"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$host"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
  display a shorter name with the longer name via mouseover
-->
<xsl:template name="shortName">
  <xsl:param name="name" />
  <xsl:param name="length" select="32"/>

  <xsl:choose>
  <xsl:when test="string-length($name) &gt; $length">
    <xsl:element name="acronym">
      <xsl:attribute name="title">
        <xsl:value-of select="$name" />
      </xsl:attribute>
      <xsl:value-of select="substring($name,0,$length)" /> ...
    </xsl:element>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$name" />
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
