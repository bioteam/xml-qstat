<!DOCTYPE stylesheet [
<!ENTITY  newline "<xsl:text>&#x0a;</xsl:text>">
<!ENTITY  space   "<xsl:text> </xsl:text>">
]>

<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/2005/Atom"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<!-- ======================= Imports / Includes =========================== -->
<!-- Include processor-instruction parsing -->
<xsl:include href="pi-param.xsl"/>

<!-- ======================== Passed Parameters =========================== -->
<xsl:param name="isoTimestamp">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'isoTimestamp'"/>
  </xsl:call-template>
</xsl:param>
<xsl:param name="baseURL">
  <xsl:call-template name="pi-param">
    <xsl:with-param  name="name"    select="'baseURL'"/>
  </xsl:call-template>
</xsl:param>


<!-- ======================= Internal Parameters ========================== -->
<!-- Read UTC TimeZone offset from the configuration XML file -->

<xsl:variable name="atom-timestamp">
  <xsl:value-of select="$isoTimestamp"/>
  <xsl:value-of
      select="document('../config/config.xml')/config/UTC_TZ_offset"/>
</xsl:variable>


<!-- ========================== Sorting Keys ============================== -->
<xsl:key
    name="jstate"
    match="job_list"
    use="normalize-space(state)"
/>


<!-- ======================= Output Declaration =========================== -->
<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>


<!-- ============================ Matching ================================ -->
<xsl:template match="/">

<!-- CALCULATE TOTAL PERCENTAGE OF JOB SLOTS IN USE CLUSTER-WIDE -->
<xsl:variable name="slotsUsed"  select="sum(//Queue-List/slots_used)"/>
<xsl:variable name="slotsTotal" select="sum(//Queue-List/slots_total)"/>
<xsl:variable name="slotsPercent" select="($slotsUsed div $slotsTotal)*100" />
<!-- END CALCULATE SECTION -->

<!-- TOTAL NUMBER OF QUEUE INSTANCES -->
<xsl:variable name="queueInstances"  select="count(//Queue-List/name)"/>

<!-- COUNT UNUSUAL QUEUE LEVEL STATE INDICATORS -->
<xsl:variable name="QI_state_a"   select="count(//job_info/queue_info/Queue-List[state[.='a'] ])"/>
<xsl:variable name="QI_state_d"   select="count(//job_info/queue_info/Queue-List[state[.='d'] ])"/>
<xsl:variable name="QI_state_adu" select="count(//job_info/queue_info/Queue-List[state[.='adu'] ])"/>
<xsl:variable name="QI_state_o"   select="count(//job_info/queue_info/Queue-List[state[.='o'] ])"/>
<xsl:variable name="QI_state_c"   select="count(//job_info/queue_info/Queue-List[state[.='c'] ])"/>
<xsl:variable name="QI_state_C"   select="count(//job_info/queue_info/Queue-List[state[.='C'] ])"/>
<xsl:variable name="QI_state_D"   select="count(//job_info/queue_info/Queue-List[state[.='D'] ])"/>
<xsl:variable name="QI_state_s"   select="count(//job_info/queue_info/Queue-List[state[.='s'] ])"/>
<xsl:variable name="QI_state_S"   select="count(//job_info/queue_info/Queue-List[state[.='S'] ])"/>
<xsl:variable name="QI_state_E"   select="count(//job_info/queue_info/Queue-List[state[.='E'] ])"/>
<xsl:variable name="QI_state_au"  select="count(//job_info/queue_info/Queue-List[state[.='au'] ])"/>

<!-- SUM THE OCCURANCES OF UNUSUAL QUEUE STATE INDICATORS
     (so we can decide to throw a warning in the main overview
      view...)
-->
<xsl:variable name="QI_unusual_statecount"
    select="$QI_state_a + $QI_state_d + $QI_state_adu"
/>

<!-- COUNT UNUSUAL JOB LEVEL STATE INDICATORS -->

<!--
  Build a node set of all queues that are not usable for new or pending jobs
  the intent here is that then we can sum(slots_total) to get the number of job
  slots that are not usable.
  This is then used to build the adjusted alot availibility percentage
-->

<xsl:variable name="nodeSet-unusableQueues" select="//job_info/queue_info/Queue-List[state[.='au']] | //job_info/queue_info/Queue-List[state[.='d']] |
//job_info/queue_info/Queue-List[state[.='adu']] |
//job_info/queue_info/Queue-List[state[.='E']]"/>

<xsl:variable name="unusableSlotCount" select="sum($nodeSet-unusableQueues/slots_total)" />

<xsl:variable name="nodeSet-unavailableQueues" select="//job_info/queue_info/Queue-List[state[.='au']] | //job_info/queue_info/Queue-List[state[.='d']] | //job_info/queue_info/Queue-List[state[.='E']] | //job_info/queue_info/Queue-List[state[.='a']] |
//job_info/queue_info/Queue-List[state[.='adu']] |
//job_info/queue_info/Queue-List[state[.='A']] | //job_info/queue_info/Queue-List[state[.='D']]"/>

<xsl:variable name="nodeSet-loadAlarmQueues" select="//job_info/queue_info/Queue-List[state[.='a']] | //job_info/queue_info/Queue-List[state[.='A']] "/>

<xsl:variable name="nodeSet-dEauQueues" select="//job_info/queue_info/Queue-List[state[.='d']] | //job_info/queue_info/Queue-List[state[.='au']] | //job_info/queue_info/Queue-List[state[.='E']] "/>

<xsl:variable name="unavailableQueueInstanceCount" select="count($nodeSet-unavailableQueues)" />

<xsl:variable name="AdjSlotsPercent"          select="($slotsUsed div ($slotsTotal - $unusableSlotCount) ) *100" />
<xsl:variable name="unavailable-all-Percent"  select="($unavailableQueueInstanceCount div $queueInstances) *100" />
<xsl:variable name="unavailable-load-Percent" select="(count($nodeSet-loadAlarmQueues) div $queueInstances)*100" />
<xsl:variable name="unavailable-dEau-Percent" select="(count($nodeSet-dEauQueues) div $queueInstances)     *100" />

<!-- Active job stuff -->
<xsl:variable name="AJ_total"  select="count(//job_info/queue_info/Queue-List/job_list)"/>

<!-- Pending Job Stuff -->
<xsl:variable name="PJ_total"     select="count(//job_info/job_list[@state='pending'])"/>
<xsl:variable name="PJ_state_qw"  select="count(//job_info/job_list[state[.='qw'] ])"/>
<xsl:variable name="PJ_state_hqw"  select="count(//job_info/job_list[state[.='hqw'] ])"/>

<feed xmlns="http://www.w3.org/2005/Atom">

  <title>Overview Feed</title>

<!--
  The XML needs to look like this in order to validate as Atom 1.0 ...
  <link rel="self" href="http://workgroupcluster.apple.com/xmlqstat/feed/overview" />
-->
<xsl:element name="link">
 <xsl:attribute name="rel">self</xsl:attribute>
 <xsl:attribute name="href"><xsl:value-of select="$baseURL"/>feed/overview</xsl:attribute>
</xsl:element>

  <updated><xsl:value-of select="$atom-timestamp"/></updated>
  <author>
    <name>xmlqstat</name>
  </author>
  <generator uri="/xmlqstat" version="1.0">xmlqstat</generator>
  <subtitle>Overview of Grid Engine state and status.</subtitle>
  <!-- <logo>/config/logo.png</logo> -->
  <id>urn:uuid:xmlqstat-atomfeed-overview</id>

  <entry>
    <title>Grid Engine Cluster Summary</title>
    <xsl:element name="link">
      <xsl:attribute name="href"><xsl:value-of select="$baseURL"/>jobs</xsl:attribute>
    </xsl:element>
    <!-- we want an unchanging URN with a single ENTRY that
         has its UPDATED timestamp altered. Otherwise we end up
         generating infinite articles...
    -->
    <id>urn:uuid:xmlqstat-atomfeed-overview-summary</id>
    <updated><xsl:value-of select="$atom-timestamp"/></updated>
    <summary>
     Grid Engine Status.
    </summary>

    <content type="xml">

<div xmlns="http://www.w3.org/1999/xhtml" >
<hr width="80%" />
<blockquote>
		<div id="queueInstances">
Queue Instances: <xsl:value-of select="format-number($queueInstances,'###,###,###')"/>
		</div>
<div id="activeJobs">
Jobs Active/Pending: <xsl:value-of select="$AJ_total"/> / <xsl:value-of select="$PJ_total"/>
</div>

<div id="slotsTotal">
Slots Total/Active: <xsl:value-of select="format-number($slotsTotal,'###,###,###')"/> / <xsl:value-of select="$AJ_total"/>
</div>

<div id="slotsAvail">
<xsl:choose>
<xsl:when test="$unavailable-all-Percent >= 50" >
 <!--nothing now -->
</xsl:when>
<xsl:when test="$unavailable-all-Percent >= 10" >
 <!--nothing now -->
</xsl:when>
<xsl:otherwise>
<!-- do nothing -->
</xsl:otherwise>
</xsl:choose>

Slots Available/Unavailable: <xsl:value-of select="$slotsTotal - $unusableSlotCount"/> / <xsl:value-of select="$unusableSlotCount"/>
</div>

<xsl:if test="$QI_state_au &gt; 0">
&newline;
<div>Queue Info: <xsl:value-of select="$QI_state_au"/> alarm/unreachable state 'au'</div>
</xsl:if>

<xsl:if test="$QI_state_adu &gt; 0">
&newline;
<div>Queue Info: <xsl:value-of select="$QI_state_adu"/> alarm/unreachable/disabled alarm state 'adu'</div>
</xsl:if>

<xsl:if test="$QI_state_a &gt; 0">
&newline;
<div>Queue Info: <xsl:value-of select="$QI_state_a"/> load threshold alarm state 'a'</div>
</xsl:if>

<xsl:if test="$QI_state_d &gt; 0">
&newline;
<div>Queue Info: <xsl:value-of select="$QI_state_d"/> admin disabled state 'd'</div>
</xsl:if>

<xsl:if test="$QI_state_S &gt; 0">
&newline;
<div>Queue Info: <xsl:value-of select="$QI_state_S"/> subordinate state 'S' </div>
</xsl:if>

<!-- GENERATE A UNIQUE LIST OF ACTIVE JOB STATES THAT MAY BE OF INTEREST -->
<xsl:for-each select="/job_info/queue_info/Queue-List/job_list [generate-id() = generate-id( key('jstate',normalize-space(state))[1] )]">
  <!-- Skip state=running (because its boring and OK, we want other states) -->
  <xsl:if test="./state != 'r'">
    <div class="sentence">
      Job Info: At least 1 job is reporting state=<xsl:value-of select="./state"/>
    </div>
  </xsl:if>
</xsl:for-each>

</blockquote>
<hr width="80%" />

<blockquote>

<div id="unusualQueueStates">
<xsl:choose>
<xsl:when test="$QI_unusual_statecount &gt; 0">
Some unusual Queue Instance states have been detected.
</xsl:when>
<xsl:otherwise>
 <!-- no unusual states detected -->
No unusual Queue Instance states have been detected.
</xsl:otherwise>
</xsl:choose>
Click here for <xsl:element name="a">
<xsl:attribute name="href"><xsl:value-of select="$baseURL"/>jobs</xsl:attribute>
Detailed information.
</xsl:element><br/>
</div>

<div class="sentence">
With <xsl:value-of select="$unusableSlotCount"/> slots belonging to queue instances that are administratively disabled or in an unusable state,
the adjusted slot utilization percentage is <xsl:value-of select="format-number($AdjSlotsPercent,'##0.#') "/>%.
Currently, <xsl:value-of select="format-number($unavailable-all-Percent,'##0.#') "/>% of configured grid queue instances are closed to new jobs due to
 load threshold alarms, errors or administrative action.
</div>

</blockquote>

</div>
    </content>
  </entry>

</feed>

</xsl:template>
</xsl:stylesheet>

<!-- =========================== End of File ============================== -->
