<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- XSL output declarations -->
<xsl:output method="xhtml" indent="yes" version="4.01" encoding="ISO-8859-1"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

 <!-- XSL input parameters -->
  <xsl:param name="timestamp"/>
  <xsl:param name="real"/>
  <xsl:param name="outputFilter"/>
  <xsl:param name="timestamp"/>
  
<xsl:template match="/">

<!-- CALCULATE TOTAL PERCENTAGE OF JOB SLOTS IN USE CLUSTER-WIDE -->  
<xsl:variable name="slotsUsed"  select="sum(//Queue-List/slots_used)"/>
<xsl:variable name="slotsTotal" select="sum(//Queue-List/slots_total)"/>
<xsl:variable name="slotsPercent" select="($slotsUsed div $slotsTotal)*100" />
<!-- END CALCULATE SECTION -->

<!-- TOTAL NUMBER OF QUEUE INSTANCES -->
<xsl:variable name="queueInstances"  select="count(//Queue-List/name)"/>

<!-- COUNT UNUSUAL QUEUE LEVEL STATE INDICATORS --> 
<xsl:variable name="QI_state_a"   select="count(//job_info/queue_info/Queue-List[state[.='a']  ])"/>
<xsl:variable name="QI_state_d"   select="count(//job_info/queue_info/Queue-List[state[.='d']  ])"/>
<xsl:variable name="QI_state_o"   select="count(//job_info/queue_info/Queue-List[state[.='o']  ])"/>
<xsl:variable name="QI_state_c"   select="count(//job_info/queue_info/Queue-List[state[.='c']  ])"/>
<xsl:variable name="QI_state_C"   select="count(//job_info/queue_info/Queue-List[state[.='C']  ])"/>
<xsl:variable name="QI_state_D"   select="count(//job_info/queue_info/Queue-List[state[.='D']  ])"/>
<xsl:variable name="QI_state_s"   select="count(//job_info/queue_info/Queue-List[state[.='s']  ])"/>
<xsl:variable name="QI_state_S"   select="count(//job_info/queue_info/Queue-List[state[.='S']  ])"/>
<xsl:variable name="QI_state_E"   select="count(//job_info/queue_info/Queue-List[state[.='E']  ])"/>
<xsl:variable name="QI_state_au"  select="count(//job_info/queue_info/Queue-List[state[.='au'] ])"/>

<!--  Build a node set of all queues that are not usable for new or pending jobs                       -->
<!--  the intent here is that then we can sum(slots_total) to get the number of job                    -->
<!--  slots that are not usable. This is then used to build the adjusted alot availibility percentage  -->
<xsl:variable name="nodeSet-unusableQueues" select="//job_info/queue_info/Queue-List[state[.='au']] | //job_info/queue_info/Queue-List[state[.='d']] |
//job_info/queue_info/Queue-List[state[.='adu']] |
//job_info/queue_info/Queue-List[state[.='E']]"/> 
<xsl:variable name="unusableSlotCount" select="sum($nodeSet-unusableQueues/slots_total)" />
<xsl:variable name="nodeSet-unavailableQueues" select="//job_info/queue_info/Queue-List[state[.='au']] | //job_info/queue_info/Queue-List[state[.='d']] | //job_info/queue_info/Queue-List[state[.='E']] | //job_info/queue_info/Queue-List[state[.='a']] | //job_info/queue_info/Queue-List[state[.='A']] | //job_info/queue_info/Queue-List[state[.='D']]"/> 
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

<xsl:text>
</xsl:text>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<xsl:text>
</xsl:text>
<head> 
<xsl:text>
</xsl:text>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<xsl:text>
</xsl:text>
<title>xmlqstat</title>
<xsl:text>
</xsl:text>
<xsl:comment>Load dortch cookie utilities</xsl:comment>
<xsl:text>
</xsl:text>
<script language="JavaScript" type="text/javascript" src="javascript/cookie.js"></script>

<xsl:text>

</xsl:text>
<xsl:comment>Load our CSS from a file now ...</xsl:comment>
<xsl:text>
</xsl:text>
<link href="css/xmlqstat-terse.css" media="screen" rel="Stylesheet" type="text/css" />
<xsl:text>

</xsl:text>
</head>
<xsl:text>
</xsl:text>
<body>
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
<p><img src="images/xml-qstat-logo.gif" width="150" alt="xml qstat logo" /></p>
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
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
     <span style="cursor:help;">
      <xsl:element name="acronym">
       <xsl:attribute name="title">Home</xsl:attribute>
       <a href="qstat.html"><img alt=""  src="images/icons/silk/house.png" border="0" /></a>
      </xsl:element>
     </span>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
     <span style="cursor:help;">
      <xsl:element name="acronym">
       <xsl:attribute name="title">Reload</xsl:attribute>
       <a href=""><img alt=""  src="images/icons/silk/arrow_rotate_clockwise.png" border="0" /></a>
      </xsl:element>
     </span>
<xsl:text>
</xsl:text>
      <img alt="*"  src="images/icons/silk/bullet_blue.png" />
     <span style="cursor:help;">
      <xsl:element name="acronym">
       <xsl:attribute name="title">View standard output format</xsl:attribute>
       <a href="qstat.html"><img alt=""  src="images/icons/silk/table_multiple.png" border="0" /></a>
      </xsl:element>
     </span>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
     <span style="cursor:help;">
      <xsl:element name="acronym">
       <xsl:attribute name="title">About</xsl:attribute>
       <a href="info/about.html"><img alt=""  src="images/icons/silk/information.png" border="0" /></a>
      </xsl:element>
     </span>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
     <span style="cursor:help;">
      <xsl:element name="acronym">
       <xsl:attribute name="title">Help</xsl:attribute>
       <a href="info/help.html"><img alt=""  src="images/icons/silk/help.png" border="0" /></a>
      </xsl:element>
     </span>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
      <span style="cursor:help;">
      <xsl:element name="acronym">
       <xsl:attribute name="title">Participate!</xsl:attribute>
       <a href="info/participate.html"><img alt=""  src="images/icons/silk/page_white_edit.png" border="0" /></a>
      </xsl:element>
     </span>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
<xsl:text>
</xsl:text> 
    </div>
<xsl:text>

</xsl:text>     
    <div id="upperBar">
<xsl:text>
</xsl:text>

<!-- disable demo mode 
    <xsl:choose>
    <xsl:when test="$real = 'no'">
    Switch to: <a href="/xmlqstat/qstat-terse.html">real data</a>
    </xsl:when>
    <xsl:otherwise>
    Switch to: <a href="/xmlqstat/demo/qstat-terse.html">large cluster (demo) data</a>
    </xsl:otherwise>
    </xsl:choose>
-->
<xsl:text>
</xsl:text> 
    </div>
<xsl:text>
</xsl:text> 
<blockquote>
<xsl:text>
</xsl:text> 
<table width="80%" class="qstat">
<xsl:text>
</xsl:text> 
<tbody>
<xsl:text>
</xsl:text> 
<tr>
<td valign="middle"><div class="tableDescriptorElement">Grid Engine Cluster Summary</div>
</td>
<xsl:text>
</xsl:text> 
</tr>
<xsl:text>
</xsl:text> 
</tbody>
<xsl:text>
</xsl:text> 
</table>
<xsl:text>

</xsl:text> 
<div class="qstDiv" id="queueStatusTable">
<xsl:text>
</xsl:text> 
<table class="qstat" width="80%">
<xsl:text>
</xsl:text> 
<tr>
<xsl:text>
</xsl:text> 
<th>Slot Utilization</th>
<td>
</td>
<td> 
     <!-- BAR GRAPH OF TOTAL CLUSTER SLOT UTILIZATION -->
     <div class="progbarOuter" style="width:100px;">
      <xsl:element name="div">
       <xsl:attribute name="class">progbarInner</xsl:attribute>
       <xsl:attribute name="style">
        width:<xsl:value-of select="format-number($slotsPercent,'##0.#') "/>%;
       </xsl:attribute>
       <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title">Currently <xsl:value-of select="$slotsUsed"/> of <xsl:value-of select="$slotsTotal"/> total cluster job slots are in use</xsl:attribute>
          <xsl:value-of select="format-number($slotsPercent,'##0.#') "/>%
         </xsl:element>
        </span>       
       </div>
      </xsl:element>
     </div>     
    <!-- END BAR GRAPH -->
     <!-- BAR GRAPH OF TOTAL CLUSTER SLOT UTILIZATION -->
     <div class="progbarOuter" style="width:100px;">
      <xsl:element name="div">
       <xsl:attribute name="class">progbarInner</xsl:attribute>
       <xsl:attribute name="style">
        width:<xsl:value-of select="format-number($AdjSlotsPercent, '##0.#') "/>%;
       </xsl:attribute>
       <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title">Currently <xsl:value-of select="$slotsUsed"/> of <xsl:value-of select="($slotsTotal - $unusableSlotCount) "/> USABLE cluster job slots are in use</xsl:attribute>
          <xsl:value-of select="format-number($AdjSlotsPercent,'##0.#') "/>%
         </xsl:element>
        </span>       
       </div>
      </xsl:element>
     </div>     
    <!-- END BAR GRAPH -->    
</td>
<td class="boldcode">This cluster has <xsl:value-of select="format-number($queueInstances,'###,###,###')"/> queue instances offering up 
<xsl:value-of select="format-number($slotsTotal,'###,###,###')"/> total job slots. 
There are <xsl:value-of select="$slotsUsed"/> active job slots currently in use.
With <xsl:value-of select="$unusableSlotCount"/> slots belonging to queue instances that are administratively disabled or in an unusable state,
the adjusted slot utilization percentage is <xsl:value-of select="format-number($AdjSlotsPercent,'##0.#') "/>%.
</td>
</tr>
<tr>
<th>Queue Availibility</th>
<td>
<xsl:choose>
<xsl:when test="$unavailable-all-Percent >= 50" >
  <img src="images/icons/silk/exclamation.png" />
</xsl:when>
<xsl:when test="$unavailable-all-Percent >= 10" >
   <img src="images/icons/silk/error.png" />
</xsl:when>
<xsl:otherwise>
<!-- do nothing -->
</xsl:otherwise>
</xsl:choose>

</td>
<td>
     <!-- BAR GRAPH OF TOTAL CLUSTER SLOT UTILIZATION -->
     <div class="progbarOuter" style="width:100px;">
      <xsl:element name="div">
       <xsl:attribute name="class">progbarInner</xsl:attribute>
       <xsl:attribute name="style">
        width:<xsl:value-of select="format-number($unavailable-all-Percent, '##0.#') "/>%;
       </xsl:attribute>
       <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title"> <xsl:value-of select="$unavailableQueueInstanceCount"/> out of <xsl:value-of select="$queueInstances"/> queue instances are not available.</xsl:attribute>
          <xsl:value-of select="format-number($unavailable-all-Percent,'##0.#') "/>%
         </xsl:element>
        </span>       
       </div>
      </xsl:element>
     </div>     
    <!-- END BAR GRAPH -->    
    
         <!-- BAR GRAPH OF TOTAL CLUSTER SLOT UTILIZATION -->
     <div class="progbarOuter" style="width:50px;">
      <xsl:element name="div">
       <xsl:attribute name="class">progbarInner</xsl:attribute>
       <xsl:attribute name="style">
        width:<xsl:value-of select="format-number($unavailable-load-Percent, '##0.#') "/>%;
       </xsl:attribute>
       <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title"> <xsl:value-of select="count($nodeSet-loadAlarmQueues)"/> queue instances unavailable for LOAD related reasons</xsl:attribute>
          <xsl:value-of select="format-number($unavailable-load-Percent,'##0.#') "/>%
         </xsl:element>
        </span>       
       </div>
      </xsl:element>
     </div>     
    <!-- END BAR GRAPH --> 
    
     <!-- BAR GRAPH OF TOTAL CLUSTER SLOT UTILIZATION -->
     <div class="progbarOuter" style="width:50px;">
      <xsl:element name="div">
       <xsl:attribute name="class">progbarInner</xsl:attribute>
       <xsl:attribute name="style">
        width:<xsl:value-of select="format-number($unavailable-dEau-Percent, '##0.#') "/>%;
       </xsl:attribute>
       <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title"><xsl:value-of select="count($nodeSet-dEauQueues)"/> queue instance unavailable for ALARM, ERROR or ADMIN related reasons </xsl:attribute>
          <xsl:value-of select="format-number($unavailable-dEau-Percent,'##0.#') "/>%
         </xsl:element>
        </span>       
       </div>
      </xsl:element>
     </div>     
    <!-- END BAR GRAPH -->
    </td>
<td class="boldcode"> <xsl:value-of select="format-number($unavailable-all-Percent,'##0.#') "/>% of configured grid queue instances are closed to new jobs due to
 load threshold alarms, errors or administrative action.
</td>
</tr>
<tr>
<th>Queue Alerts</th>
<td>
<xsl:choose>
<xsl:when test="$QI_state_au > 0">
  <img src="images/icons/silk/exclamation.png" />
</xsl:when>
<xsl:when test="$QI_state_S > 0">
  <img src="images/icons/silk/exclamation.png" />
</xsl:when>
</xsl:choose>
</td>
<td colspan="2" class="boldcode">
<ul>
<xsl:if test="$QI_state_au > 0">
  <li> <xsl:value-of select="$QI_state_au"/> queue instance(s) report alarm/unreachable alarm state 'au'</li>
</xsl:if>
<xsl:if test="$QI_state_a > 0">
  <li> <xsl:value-of select="$QI_state_a"/> queue instance(s) report load threshold alarm state 'a'</li>
</xsl:if>
<xsl:if test="$QI_state_d > 0">
  <li> <xsl:value-of select="$QI_state_d"/> queue instance(s) report admin disabled state 'd'</li>
</xsl:if>
<xsl:if test="$QI_state_S > 0" > 
  <li> <xsl:value-of select="$QI_state_S"/> queue instance(s) report subordinate state 'S' </li>
</xsl:if>
</ul>
</td>
</tr>
<tr>
<th>Active Jobs</th>
<td>
</td>
<td colspan="2" class="boldcode">
<ul>
<xsl:choose>
<xsl:when test="$AJ_total > 0" >
 <li> <xsl:value-of select="$AJ_total"/> active jobs (sum does not include parallel or array sub-tasks) </li>
</xsl:when>
<xsl:otherwise>
<li>There are no active jobs</li>
</xsl:otherwise>
</xsl:choose>

</ul>
</td>
</tr>
<tr>
<th>Pending Jobs</th>
<td>
</td>
<td colspan="2" class="boldcode">
<ul>
<xsl:if test="$PJ_total > 0" >
 <li> <xsl:value-of select="$PJ_total"/> jobs (sum does not include parallel or array sub-tasks) </li>
</xsl:if>
<ul>
<xsl:if test="$PJ_state_qw > 0" >
 <li> <xsl:value-of select="$PJ_state_qw"/> reporting state 'qw' </li>
</xsl:if>
<xsl:if test="$PJ_state_hqw > 0" >
 <li> <xsl:value-of select="$PJ_state_hqw"/> reporting state 'hqw' </li>
</xsl:if>
</ul>
</ul>
</td>
</tr>
</table>
</div>
</blockquote>

<xsl:choose>
<!-- DO THIS WHEN THERE ARE ACTIVE RUNNING/TRANSFERRING JOBS -->
<xsl:when test="//Queue-List/job_list">
     
<blockquote>
<table class="qstat" width="100%">
 <tbody>
  <tr><td valign="middle">
    <div class="tableDescriptorElement">Active Jobs (max. 200 listed)</div>
<!-- 
         <div class="visToggleElement">
          <a href="#" border="0" onclick="hideActiveStatus()">
           <img border="0" src="static/uparrow.gif" alt="Hide Table " />
          </a>
          <a href="#" border="0" onclick="showActiveStatus()"> 
           <img  border="0" src="static/dnarrow.gif" alt=" Show Table" />
          </a>
         </div>
 -->
</td></tr></tbody></table>
<xsl:text>


</xsl:text><xsl:comment>Active job info </xsl:comment>
<xsl:text>
</xsl:text>
<div class="scrollableDIV" id="activeJobTable">
<table class="qstat" width="100%">
        <tr>
         <th>Priority</th>
         <th>
          Job ID
         </th>
         <th>
          Active Queue Instance
         </th>
         <th>
          Job Owner
         </th>
         <th>
          Job Name
         </th>
         <th>
          Slots Requested
         </th>
         <th>
          Array Tasks
         </th>
         <th>
          StartTime
         </th>
         <th>State</th>
        </tr>
        <tbody>

          <!-- potential bug here - we need to research all possible non-pending states that could be reported -->
          <!--  as we currently only catch items marked as running or transferring ...                         -->
          
          <xsl:variable name="nodeList-activeJobs" select="//job_list[@state='running'] | //job_list[@state='transferring'] " />
          
          <!-- Match only the first 100 active jobs -->
          <xsl:apply-templates select="$nodeList-activeJobs[position() &lt;= 200]"/>

        </tbody>
       </table>
       </div>

      </blockquote>
     </xsl:when>
     <xsl:otherwise>
      <!-- OTHERWISE - DO NOT SHOW ACTIVE JOB TABLE -->
     </xsl:otherwise>
    </xsl:choose>

    <!--     We don't want to print out a table for pending items that do not exist  -->
    <!--     so we'll wrap the pending HTML table output in a XSL conditional        -->
    <!--     "xsl:choose/when/otherwise" test!                                       -->
    
    
    <xsl:choose>
     <!-- DO THIS WHEN THERE ARE PENDING JOBS -->
     <xsl:when test="//job_list[@state='pending']">
     <xsl:text>


</xsl:text><xsl:comment>Pending job info </xsl:comment>
<xsl:text>
</xsl:text>
      <blockquote>
<table class="qstat" width="100%">
 <tbody>
  <tr><td valign="middle">
    <div class="tableDescriptorElement">Highest priority pending jobs (max. 200 listed)</div>
<!-- 
         <div class="visToggleElement">
          <a href="#" border="0" onclick="hidePendingStatus()">
           <img border="0" src="static/uparrow.gif" alt="Hide Table " />
          </a>
          <a href="#" border="0" onclick="showPendingStatus()"> 
           <img  border="0" src="static/dnarrow.gif" alt=" Show Table" />
          </a>
         </div>
 -->
</td></tr></tbody></table>
<div class="scrollableDIV" id="pendingJobTable">      
      
       <table class="qstat" width="100%">
        <tr>
         <th>Priority</th>
         <th>
          Job ID
         </th>
         <th>
          Job Owner
         </th>
         <th>
          Job Name
         </th>
         <th>
          Slots Requested
         </th>
         <th>
          Array Tasks
         </th>
         <th>
          Submission Time
         </th>
         <th>State</th>
        </tr>
        <tbody>
         
         <xsl:apply-templates select="//job_list[@state='pending'][position() &lt;=200] "/>
         
        </tbody>
       </table>
       </div>
      </blockquote>
     </xsl:when>
     <xsl:otherwise>
      <!-- OTHERWISE - DO THIS WHEN THERE ARE NO PENDING JOBS -->
      <blockquote>
       <span class="pendheader">There are no pending jobs</span>
      </blockquote>
     </xsl:otherwise>
    </xsl:choose>

<xsl:text>

</xsl:text>
<xsl:comment>Bottom status bar</xsl:comment>
<xsl:text>

</xsl:text>
<div id="bottomBar"><xsl:text> </xsl:text>
     Rendered: <xsl:value-of select="$timestamp"/>
</div>
<xsl:text>

</xsl:text>
</div> <!-- main content -->
<xsl:text>
</xsl:text><xsl:comment>bottom box section </xsl:comment>
<xsl:text>
</xsl:text>

<div class="bottomBox">
<xsl:text>
</xsl:text>
<a href="psp/qstat.html" title="Format for Sony PSP Web Browser"><img alt="XHTML-PSP" src="images/sonyPSP.gif" border="0" /></a>
<xsl:text>
</xsl:text> 
<a href="info/rss-feeds.html" title="List RSS Feeds"><img alt="RSS-Feeds" src="images/rssAvailable.gif" border="0" /></a>
</div>

<xsl:text>
</xsl:text>
</body>
<xsl:text>
</xsl:text>
</html>
<xsl:text>
</xsl:text>
</xsl:template>


 <xsl:template match="Queue-List/job_list">
  <tr>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JAT_prio" />
     </xsl:element>
   </td>
   <td class="boldcode">
   
<!-- 
   <xsl:element name="a">
     <xsl:attribute name="href">
      ss-qstat.cgi?jo=<xsl:value-of select="JB_job_number"/>
     </xsl:attribute>
     <xsl:element name="code">
      <xsl:value-of select="JB_job_number"/>      
     </xsl:element>
    </xsl:element>
 -->
    <xsl:element name="code"><xsl:value-of select="JB_job_number"/>    </xsl:element>
    
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="../name"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JB_owner"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JB_name"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="slots"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="tasks"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JAT_start_time"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
        <xsl:choose>
      <xsl:when test="state='r'">r
<!--
              <span style="cursor:help;">
               <acronym title="Running"> 
               <img src="images/icons/silk/script_gear.png" /> </acronym>
              </span>
-->
      </xsl:when>
      <xsl:when test="state='S'">
              <span style="cursor:help;">
               <acronym title="Job in (S)ubordinate suspend state"> 
               <img src="images/icons/silk/error.png" /> </acronym>
              </span>
      </xsl:when>      
     <xsl:otherwise>
       <xsl:value-of select="state"></xsl:value-of>
     </xsl:otherwise>
    </xsl:choose>
    </xsl:element>
   </td>
  </tr>
 </xsl:template>

 <xsl:template match="job_list[@state='pending']">
  <tr>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JAT_prio"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
   
<!-- 
   <xsl:element name="a">
     <xsl:attribute name="href">
      ss-qstat.cgi?jo=<xsl:value-of select="JB_job_number"/>
     </xsl:attribute>
     <xsl:element name="code">
      <xsl:value-of select="JB_job_number"/>
     </xsl:element>
    </xsl:element>
-->
    <xsl:element name="code">
      <xsl:value-of select="JB_job_number"/>
     </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JB_owner"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JB_name"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="slots"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="tasks"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JB_submission_time"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
    <xsl:choose>
      <xsl:when test="state='qw'">qw
<!--
              <span style="cursor:help;">
               <acronym title="Pending (qw)"> 
               <img src="images/icons/silk/time.png" /> </acronym>
              </span>
-->
      </xsl:when>
      <xsl:when test="state='hqw'">
              <span style="cursor:help;">
               <acronym title="Pending with hold state (hqw)"> 
               <img src="images/icons/silk/time_add.png" /> </acronym>
              </span>
      </xsl:when>      
     <xsl:otherwise>
       <xsl:value-of select="state"></xsl:value-of>
     </xsl:otherwise>
    </xsl:choose>
    </xsl:element>
   </td>
  </tr>
  
  <!-- output info about any resources that were specifically requested ... -->
  <xsl:choose>
   <xsl:when test="hard_request">
    <tr>
     <td colspan="8" align="right" class="alarmcode">hard_request:  
      <xsl:apply-templates select="hard_request"/>
     </td>
    </tr>
   </xsl:when>
  </xsl:choose>
  
 </xsl:template>
 
</xsl:stylesheet>

