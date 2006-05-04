<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:dt="http://xsltsl.org/date-time"  
xmlns:str="http://xsltsl.org/string"
exclude-result-prefixes="dt str"
>

<!-- output declarations -->
<xsl:output method="xhtml" indent="yes" version="4.01" encoding="ISO-8859-1"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

<!-- Import the XSLTL library method -->
<xsl:include href="xsltl/stdlib.xsl"/>  

<!-- Prep our configuration XML file(s) -->
<xsl:variable name="configFile" select="document('../xml/CONFIG.xml')" />
<xsl:variable name="loadAlarmFile" 
 select="document('../xml/CONFIG_alarm-threshold.xml')" />


<!-- XSL Parameters        -->
<xsl:param name="real"/>
<xsl:param name="showQtable"/>
<xsl:param name="showAJtable"/>
<xsl:param name="enableResourceQueries"/>
<xsl:param name="showPJtable"/>
<xsl:param name="timestamp"/>
<xsl:param name="outputFilter"/>
<xsl:param name="perUserJobSort"/>

<xsl:param name="compatMode"><xsl:value-of select="$configFile/config/compat_mode"/></xsl:param>

<xsl:param name="useAlarmThresholds"><xsl:value-of select="$configFile/config/use_alarm-threshold_data"/></xsl:param>


<xsl:template match="/" >

<!-- 
  ================================================================================
   Author : Chris Dagdigian (chris@bioteam.net)                                   
    License: Creative Commons                                                      
       Rev :                               
    Purpose:                                    
   ================================================================================
   ALL OF THE FOLLOWING CONTENT IS AUTO GENERATED VIA XML-XLST TRANSFORMATION      
   ================================================================================
   Primarily this stylesheet expects output from the Grid Engine command:
     "qstat -xml -r -f -explain aAcE"
   ... along with some parameters (see above XSL Parameters section) that aid in 
   output and processing. 
   ================================================================================
-->
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
<link rel="alternate" type="application/atom+xml" href="feed/overview" title="xmlqstat" />
<xsl:text>
</xsl:text>
<xsl:comment> Load dortch cookie utilities</xsl:comment>
<xsl:text>
</xsl:text>
<script language="JavaScript" type="text/javascript" src="javascript/cookie.js"></script>
<xsl:text>
</xsl:text>
<xsl:comment> Load display altering code</xsl:comment>
<xsl:text>
</xsl:text>
<script language="JavaScript" type="text/javascript" src="javascript/displayStuff.js"></script>
<xsl:text>
</xsl:text>
<xsl:comment> showQtable = <xsl:value-of select="$showQtable" />
</xsl:comment>
<xsl:text>
</xsl:text>
<xsl:comment> showAJtable = <xsl:value-of select="$showAJtable" />
</xsl:comment>
<xsl:text>
</xsl:text>
<xsl:comment> showPJtable = <xsl:value-of select="$showPJtable" />
</xsl:comment>
<xsl:text>
</xsl:text>
<xsl:comment> enableResourceQueries = <xsl:value-of select="$enableResourceQueries" />
</xsl:comment>
<xsl:text>
</xsl:text>
<xsl:comment> perUserJobSort = <xsl:value-of select="$perUserJobSort" />
</xsl:comment>
<xsl:text>
</xsl:text>
<xsl:comment> CONFIG:use_alarm-threshold_data = <xsl:value-of select="$useAlarmThresholds" />
</xsl:comment>
<xsl:text>
</xsl:text>
<xsl:comment> CONFIG:compatMode = <xsl:value-of select="$compatMode" />
</xsl:comment>

<xsl:text>

</xsl:text>

<xsl:comment>Load our CSS from a file now ...</xsl:comment>
<xsl:text>
</xsl:text>
<link href="css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
<xsl:text>
</xsl:text>

<xsl:text>
</xsl:text>
<xsl:comment>BEGIN OVERRIDE CSS </xsl:comment>
<xsl:text>
</xsl:text>
 <style type="text/css">
<!-- DIFFERENT CSS STYLE DEPENDING ON USER COOKIE PREFERENCE PARAM(s) -->
<!-- Do we show the full queue status table? -->
<xsl:choose>
<xsl:when test="$showQtable = 'no'" >
.qstDiv { visibility: hidden; display: none;  }
</xsl:when>
<xsl:when test="$perUserJobSort != 'no'" >
.qstDiv { visibility: hidden; display: none;  }
</xsl:when>
<xsl:otherwise>
.qstDiv { visibility: visible; display: inline;   }
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<!-- Do we show the full active job status table? -->
<xsl:when test="$showAJtable = 'no'" >
.AJDiv { visibility: hidden; display: none;  }
</xsl:when>
<xsl:otherwise>
.AJDiv { visibility: visible; display: inline;   }
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<!-- Do we show the full pending job status table? -->
<xsl:when test="$showPJtable = 'no'" >
.PJDiv { visibility: hidden; display: none;  }
</xsl:when>
<xsl:otherwise>
.PJDiv { visibility: visible; display: inline;   }
</xsl:otherwise>
</xsl:choose>
<!-- END COOKIE DEPENDENT VARIABLE CSS STYLE OUTPUT -->
<xsl:text>
</xsl:text>   
</style>
<xsl:text>
</xsl:text>
<xsl:comment>END OVERRIDE CSS</xsl:comment>
<xsl:text>
</xsl:text>
</head>
<xsl:text>

</xsl:text>
  
  <!-- CALCULATE TOTAL PERCENTAGE OF JOB SLOTS IN USE CLUSTER-WIDE -->  
  <xsl:variable name="slotsUsed"  select="sum(//Queue-List/slots_used)"/>
  <xsl:variable name="slotsTotal" select="sum(//Queue-List/slots_total)"/>
  <xsl:variable name="slotsPercent" select="($slotsUsed div $slotsTotal)*100" />

<!-- Active job stuff -->
<xsl:variable name="AJ_total"  select="count(//job_info/queue_info/Queue-List/job_list)"/>

<!-- Pending Job Stuff -->
<xsl:variable name="PJ_total"     select="count(//job_info/job_list[@state='pending'])"/>
<xsl:variable name="PJ_state_qw"  select="count(//job_info/job_list[state[.='qw'] ])"/>
<xsl:variable name="PJ_state_hqw"  select="count(//job_info/job_list[state[.='hqw'] ])"/>


  <!-- END CALCULATE SECTION -->
  

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
<img alt="*" src="images/icons/silk/bullet_blue.png" />
<a href="qstat.html" title="Home" ><img alt=""  src="images/icons/silk/house.png" border="0" /></a>
<xsl:text>
</xsl:text>
<img alt="*"  src="images/icons/silk/bullet_blue.png" />
<a href="" title="Reload" ><img alt=""  src="images/icons/silk/arrow_rotate_clockwise.png" border="0" /></a>
<xsl:text>
</xsl:text>
      <img alt="*"  src="images/icons/silk/bullet_blue.png" />
       <a href="qstat-terse.html" title="View terse output format" ><img alt=""  src="images/icons/silk/table.png" border="0" /></a>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
       <a href="info/about.html" title="About"><img alt=""  src="images/icons/silk/information.png" border="0" /></a>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
       <a href="info/help.html" title="Help"><img alt=""  src="images/icons/silk/help.png" border="0" /></a>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
       <a href="info/participate.html" title="Participate" ><img alt=""  src="images/icons/silk/page_white_edit.png" border="0" /></a>
<xsl:text>
</xsl:text>
     <img alt="*"  src="images/icons/silk/bullet_blue.png" />
<xsl:text>
</xsl:text> 
    </div>
<xsl:text>

</xsl:text> 
<xsl:comment> Top dotted line bar (holds the demo link currently)</xsl:comment>
<xsl:text>
</xsl:text>
    <div id="upperBar"><xsl:text> </xsl:text>

<!-- DISABLE THE DEMO TEST LINKS 
    <xsl:choose>
    <xsl:when test="$real = 'no'">
    Switch to: <a href="/xmlqstat/qstat.html">real data</a>
    </xsl:when>
    <xsl:otherwise>
    Switch to: <a href="/xmlqstat/demo/qstat.html">large cluster (demo) data</a>
    </xsl:otherwise>
    </xsl:choose>
-->

<xsl:text>
</xsl:text> 
    </div>
<xsl:text>

</xsl:text>    
<xsl:comment>This table is for SGE queues and running jobs</xsl:comment>
<xsl:text>
</xsl:text>    
    <blockquote>
<xsl:text>
</xsl:text>      
     <xsl:comment> This mini table shows and hides the queue status table </xsl:comment>
<xsl:text>
</xsl:text>      
     <table width="100%" class="qstat">
<xsl:text>
</xsl:text> 
      <tbody>
       <tr>
        <td valign="middle">
         <div class="tableDescriptorElement">Cluster Queue Status</div>
         <div class="tableDescriptorElement" id="summaryGraph">
     <!-- BAR GRAPH OF TOTAL CLUSTER SLOT UTILIZATION -->
     <div class="progbarOuter" style="width:100px;">
      <xsl:element name="div">
       <xsl:attribute name="class">progbarInner</xsl:attribute>
       <xsl:attribute name="style">
        width:<xsl:value-of select="format-number($slotsPercent,'##0.#')"/>%;
       </xsl:attribute>
       <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title">Currently <xsl:value-of select="$slotsUsed"/> of <xsl:value-of select="$slotsTotal"/> total cluster job slots are in use</xsl:attribute>
          <xsl:value-of select="format-number($slotsPercent,'##0.#')"/>%
         </xsl:element>
        </span>       
       </div>
      </xsl:element>
     </div>     
    </div>
    <!-- END BAR GRAPH -->


         <div class="visToggleElement">
          <a href="#" onclick="hideQueueStatus()">
           <img border="0" src="images/uparrow.gif" alt="Hide Table " />
          </a>
          <a href="#" onclick="showQueueStatus()"> 
           <img border="0" src="images/dnarrow.gif" alt=" Show Table" />
          </a>
         </div>
        </td>
       </tr>
      </tbody>
<xsl:text>
</xsl:text> 
     </table>
<xsl:text>

</xsl:text>           
  <div class="qstDiv" id="queueStatusTable">
<xsl:text>
</xsl:text> 
<table class="qstat" width="100%">
<xsl:text>
</xsl:text> 
  <tr>
<xsl:text>
</xsl:text> 
    <th colspan="2"></th>
<xsl:text>
</xsl:text> 
   <th>Type</th>
<xsl:text>
</xsl:text> 
   <th>Slot Usage</th>
<xsl:text>
</xsl:text> 
   <th>Load Avg.</th>

<!-- conditional: insert a new table header if useAlarmThresholds=yes -->
<xsl:if test="$useAlarmThresholds = 'yes'" >
<xsl:text>
</xsl:text> 
   <th>Load Ratio</th>
   
</xsl:if>
<xsl:text>
</xsl:text> 
   <th>System Type</th>
<xsl:text>
</xsl:text> 
   <th>State</th>
<xsl:text>
</xsl:text> 
  </tr>
<xsl:text>
</xsl:text> 

<!-- <tbody> XHTML validation complained about this-->
<xsl:text>
</xsl:text>         

<!-- 
We want to select everything in the Queue-List element EXCEPT for the active job info which is to be displayed in a different table ... 
-->                
        <xsl:apply-templates select="//Queue-List" />         

<!-- </tbody> XHTML validation complained about this -->

<xsl:text>
</xsl:text> 
 </table>
<xsl:text>
</xsl:text> 
</div>
<xsl:text>

</xsl:text>      
     <!-- hidden layer for resource and debug data -->
     <xsl:choose>
      <xsl:when test="//Queue-List/resource">
       <div id="ResourceDetailLayer" class="ResourceDetailLayer">
        <span style="font-family: monospace">
         &gt;&gt;<a href="ss-qstat.cgi" onclick="hideResourceDetailLayer()">hide</a><p/>
         Full Resource List:<p/>
        </span>
        <xsl:apply-templates select="//Queue-List/resource"/>
        <br/>
        <span style="font-family: monospace">
         &gt;&gt;<a href="ss-qstat.cgi" onclick="hideResourceDetailLayer()"  >hide</a><br/>
        </span>
       </div>
      </xsl:when>
      <xsl:otherwise>
<xsl:text>
</xsl:text>
       <div id="DebugDetailLayer1" class="DebugDetailLayer">
<xsl:text>
</xsl:text>
        <div class="floatheader">
         <a href="#" onclick="hideDebugDetailLayer()">
          <img border="0" src="static/x.gif" alt="hide"/>
          
         </a>
        </div>
<xsl:text>
</xsl:text>
<pre>
<span id="DebugDetailLayerSpan"> Testing 1,2,3</span>
</pre>
<xsl:text>
</xsl:text>        
        <div class="floatheader">
         <a href="#" onclick="hideDebugDetailLayer()">
          <img border="0" src="static/x.gif" alt="hide"/>
          
         </a>
        </div>
<xsl:text>
</xsl:text>
       </div>
<xsl:text>

</xsl:text>
      </xsl:otherwise>
     </xsl:choose>
     <!-- hidden layer for resource and debug data -->
     
     
    </blockquote>
<xsl:text>
</xsl:text>    
    
<!-- 
     Active job table starting
     Need to figure out if we want *all* active jobs
     or *active jobs belonging to a particular user*
-->



    
<xsl:choose>
<!-- DO THIS WHEN THERE ARE ACTIVE RUNNING/TRANSFERRING JOBS -->
<xsl:when test="//Queue-List/job_list">
     
<blockquote>
<table class="qstat" width="100%">
 <tbody>
  <tr><td valign="middle">
  
<xsl:choose>
<xsl:when test="$perUserJobSort != 'no'" >
    <div class="tableDescriptorElement"><xsl:value-of select="$AJ_total"/> Active Jobs for User: <xsl:value-of select="$perUserJobSort"/>
    </div>
</xsl:when>
<xsl:otherwise>
    <div class="tableDescriptorElement">Active Jobs: <xsl:value-of select="$AJ_total"/></div>
</xsl:otherwise>
</xsl:choose>

         <div class="visToggleElement">
          <a href="#" onclick="hideActiveStatus()">
           <img border="0" src="images/uparrow.gif" alt="Hide Table " />
          </a>
          <a href="#" onclick="showActiveStatus()"> 
           <img  border="0" src="images/dnarrow.gif" alt=" Show Table" />
          </a>
         </div>
</td></tr></tbody></table>
<xsl:text>


</xsl:text><xsl:comment>Active job info </xsl:comment>
<xsl:text>
</xsl:text>
<div class="AJDiv" id="activeJobTable">
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
          Slots
         </th>
         <th>
          Array Task
         </th>
         <th>
          StartTime
         </th>
         <th>State</th>
        </tr>
<!--        <tbody> XHTML validation complained about this -->

<!-- potential bug here - we need to research all possible non-pending states that could be reported -->
<!--  as we currently only catch items marked as running or transferring ...                         -->

<!-- select running or transferring jobs -->
<xsl:apply-templates select="//job_list[@state='running'] | //job_list[@state='transferring'] "/>


<!--        </tbody> XHTML validation complained about this -->

       </table>
       </div>
      </blockquote>
     </xsl:when>
     <xsl:otherwise>
      <!-- OTHERWISE - DO NOT SHOW ACTIVE JOB TABLE -->
<xsl:text>
</xsl:text>
<xsl:comment> NO ACTIVE JOBS </xsl:comment>
<xsl:text>
</xsl:text>
      <blockquote>
       <span class="actheader"> <img alt="*"  align="absmiddle" src="images/icons/silk/bullet_blue.png" />There are no active jobs</span>
      </blockquote>
<xsl:text>
</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
    

<!-- We don't want to print out a table for pending items that do not exist  -->
<!-- so we'll wrap the pending HTML table output in a XSL conditional        -->
<!-- "xsl:choose/when/otherwise" test!                                       -->

    
    <xsl:choose>
     <!-- DO THIS WHEN THERE ARE PENDING JOBS -->
     <xsl:when test="//job_list[@state='pending']">
     <xsl:text>


</xsl:text><xsl:comment>Pending job info </xsl:comment>
<xsl:text>
</xsl:text>
      <blockquote>
<xsl:text>
</xsl:text>
<table class="qstat" width="100%">
<xsl:text>
</xsl:text>
 <tbody>
<xsl:text>
</xsl:text>
  <tr><td valign="middle">
  
<xsl:choose>
<xsl:when test="$perUserJobSort != 'no'" >  
<xsl:text>
</xsl:text>
    <div class="tableDescriptorElement"> <xsl:value-of select="$PJ_total"/> Pending Jobs for User: <xsl:value-of select="$perUserJobSort"/></div>
<xsl:text>
</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>
</xsl:text>
    <div class="tableDescriptorElement">Pending Jobs: <xsl:value-of select="$PJ_total"/></div>
</xsl:otherwise>
</xsl:choose>

<xsl:text>
</xsl:text>    
         <div class="visToggleElement">
          <a href="#" onclick="hidePendingStatus()"> 
      <img border="0" src="images/uparrow.gif" alt="Hide Table " /> 
          </a>
          <a href="#" onclick="showPendingStatus()">  
          <img  border="0" src="images/dnarrow.gif" alt="Show Table" />

          </a>
         </div>
</td></tr></tbody></table>
<xsl:text>
</xsl:text>
<div class="PJDiv" id="pendingJobTable">      
<xsl:text>
</xsl:text>      
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
         
         <xsl:apply-templates select="//job_list[@state='pending']"/>
         
<xsl:text>
</xsl:text>

<xsl:text>
</xsl:text>
       </table>
<xsl:text>
</xsl:text>
       </div>
<xsl:text>
</xsl:text>
      </blockquote>
<xsl:text>
</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <!-- OTHERWISE - DO THIS WHEN THERE ARE NO PENDING JOBS -->
<xsl:text>
</xsl:text>
<xsl:comment> NO PENDING JOBS </xsl:comment>
<xsl:text>
</xsl:text>
      <blockquote>
       <span class="pendheader"><img alt="*"  align="absmiddle" src="images/icons/silk/bullet_blue.png" />There are no pending jobs</span>
      </blockquote>
<xsl:text>
</xsl:text>
     </xsl:otherwise>
    </xsl:choose>


<xsl:text>

</xsl:text>
<xsl:comment>Bottom status bar</xsl:comment>
<xsl:text>
</xsl:text>
<div id="bottomBar">
     Rendered: <xsl:value-of select="$timestamp"/>
<xsl:text>
</xsl:text> 

</div>
<xsl:text>

</xsl:text>
</div> <xsl:comment>This is the end of main content </xsl:comment>
<xsl:text>

</xsl:text><xsl:comment>bottom box section </xsl:comment>
<xsl:text>
</xsl:text>
<div class="bottomBox">
<a href="psp/qstat.html" title="Format for Sony PSP Web Browser"><img alt="XHTML-PSP" src="images/sonyPSP.gif" border="0" /></a>
<xsl:text>
</xsl:text> 
<a href="info/rss-feeds.html" title="List RSS Feeds"><img alt="RSS-Feeds" src="images/rssAvailable.gif" border="0" /></a> 
<xsl:text>
</xsl:text> 

<!-- note: this is a development aid; should remove from SVN because
     real users will be behind firewalls and grid status should not leak
     outside the organization. 
-->
<a href="http://validator.w3.org/check/referer" title="Validate this page" >
<img alt="XML Validation" src="images/xml-validate.gif" border="0" /></a>
<xsl:text>
</xsl:text> 


</div>
<xsl:text>
</xsl:text>   
  </body>  
<xsl:text>
</xsl:text>
  </html>
 </xsl:template>
 
<!-- 
 THIS LARGE BLOCK DOES THE INDIVIDUAL ROWS WITHIN THE INITIAL QUEUE STATUS TABLE -->

 <xsl:template match="Queue-List">
<xsl:comment>begin-queue-overview-row</xsl:comment>
<xsl:text>
</xsl:text>
  <tr>
<xsl:text>
</xsl:text>
   <!-- QUEUE NAME -->
   <td colspan="2" class="boldcode">   
<xsl:choose>
<xsl:when test="$enableResourceQueries = 'yes' ">
    <span style="cursor: help;">
     <xsl:element name="acronym">
      <xsl:attribute name="title">View ALL queue resources</xsl:attribute>
      <xsl:element name="a">
       <xsl:attribute name="href">#</xsl:attribute>
       <xsl:attribute name="onclick">
        <xsl:text>resourceList('</xsl:text><xsl:value-of select="name"/>
        <xsl:text>','')</xsl:text>
       </xsl:attribute>
       <img src="images/r_d.gif" border="0"/>
      </xsl:element>
     </xsl:element>
    </span>
    <xsl:text>  </xsl:text>
</xsl:when>
</xsl:choose>

<!--
    <span style="cursor: help;">
     <xsl:element name="acronym">
      <xsl:attribute name="title">View execd spool messages from this machine</xsl:attribute>
      <xsl:element name="a">
       <xsl:attribute name="href">#</xsl:attribute>
       <xsl:attribute name="oncDebugDetailLayerSpanlick">
        <xsl:text disable-output-escaping="yes">spoolMessages('execd&amp;h=</xsl:text><xsl:value-of select="name"/>
        <xsl:text>','')</xsl:text>
       </xsl:attribute>
       <img src="static/e_d.gif" border="0"/>
      </xsl:element>
     </xsl:element>
    </span>
-->
    <!-- queue name -->
    <xsl:value-of select="name"/>
   </td>
<xsl:text>
</xsl:text>   
   <!-- QUEUE TYPE -->
   <td class="boldcode">  
    <span style="cursor:help;">
     <xsl:element name="acronym">
      <xsl:attribute name="title">Defines if this queue supports (B)atch, (I)nteractive or (P)arallel job types</xsl:attribute>
      <span style="font-size:smaller;"><xsl:value-of select="qtype"/></span>
     </xsl:element>
    </span>    
   </td>
<xsl:text>
</xsl:text>   
   <!-- QUEUE SLOTS -->
   <!-- Slots used/total inside one TD table element-->  
   <xsl:choose>
<xsl:when test='slots_used=0'>
     <td class="boldcode"> <div class="progbarOuter">
       <div class="progbarInner" style="width:0%;">
       <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title"><xsl:value-of select="slots_used"/> of <xsl:value-of select="slots_total"/> slots in use</xsl:attribute>0%</xsl:element>
        </span>       
       </div></div></div>
     </td>
<xsl:text>
</xsl:text>
</xsl:when>
    <xsl:when test='slots_total=slots_used'>
     <td class="boldcode">
      <div class="progbarOuter">
       <div class="progbarInner" style="width:100%;">
       <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title"><xsl:value-of select="slots_used"/> of <xsl:value-of select="slots_total"/> slots in use</xsl:attribute>100%</xsl:element>
        </span>        
       </div></div></div>
     </td>
<xsl:text>
</xsl:text>
    </xsl:when>
    <xsl:otherwise>    
     <xsl:variable name="QIslotsUsed"  select="slots_used"/>
     <xsl:variable name="QIslotsTotal" select="slots_total"/>
     <xsl:variable name="QIslotsPercent" select="($QIslotsUsed div $QIslotsTotal)*100"/>
     
     <!-- This does the bar graph of job slot usage when values are not 0% or 100% -->
     <td class="boldcode">
      <div class="progbarOuter">
       <xsl:element name="div">
        <xsl:attribute name="class">progbarInner</xsl:attribute>
        <xsl:attribute name="style">width:<xsl:value-of select="$QIslotsPercent"/>%;</xsl:attribute>
        <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title"><xsl:value-of select="slots_used"/> of <xsl:value-of select="slots_total"/> slots in use</xsl:attribute>        
        <xsl:value-of select="format-number($QIslotsPercent,'##0.#') "/>% </xsl:element>
        </span>          
        </div>
       </xsl:element>
      </div>
      <!-- end bar graph of job slot usage -->
     </td>
<xsl:text>
</xsl:text>     
    </xsl:otherwise>
   </xsl:choose>
<!--   
When queues are in state 'au' there is NO <load_avg/> element in the xml output     
this screws up our table formatting because arch ends up in the wrong table column

  so below we have a conditional XSL statement within the arch pattern match            .. if no load_avg element is detected, an extra <td></td> placeholder is               inserted in the HTML table to fix the layout                                        -->  
   <xsl:choose>
    <xsl:when test="load_avg">
     <!-- When load_avg is reported, output as usual -->
     <td class="boldcode">
      <xsl:element name="code"><xsl:value-of select="load_avg"/></xsl:element>
     </td>
    </xsl:when>
    <xsl:otherwise>
     <!-- otherwise, add a placeholder table entry for missing load_avg -->
     <td class="alarmcode">unknown</td> 
    </xsl:otherwise>
   </xsl:choose>

<!-- CONDITIONAL: USE LOAD THRESHOLD ALARM DATA ? -->
<xsl:if test="$useAlarmThresholds = 'yes'" >
<xsl:text>
</xsl:text>

<!-- set some variables; compute a percentage -->
<xsl:variable name="qname"><xsl:value-of select="name"/></xsl:variable>
<xsl:variable name="thresh"><xsl:value-of select="$loadAlarmFile/config/load_alarm_threshold/qi[@name=$qname]/@np_load_alarm" /></xsl:variable>
<xsl:variable name="load"><xsl:value-of select="load_avg"/></xsl:variable>
<xsl:variable name="alarmPercent" select="($load div $thresh)*100"/>
 <td>
 <xsl:choose>
 <xsl:when test="load_avg">
 <!-- this test is needed because load_avg does not exist when queues are
      in state 'au' or otherwise unreachable ...
      
      Debug:
       (<xsl:value-of select="$thresh" />)
       (<xsl:value-of select="$alarmPercent"/>)

 -->
       <div class="progbarOuter">
       <xsl:element name="div">
        <xsl:attribute name="class">progbarInner</xsl:attribute>
        <xsl:if test="$alarmPercent &lt; 100">
        <xsl:attribute name="style">width:<xsl:value-of select="$alarmPercent"/>%;</xsl:attribute>
        </xsl:if>
        <xsl:if test="$alarmPercent &gt;= 100">
                <xsl:attribute name="style">width:100%;background-color:#FF6600;</xsl:attribute>
        </xsl:if>
        <div class="progbarFont">
        <span style="cursor:help;">
         <xsl:element name="acronym">
          <xsl:attribute name="title">CPU normalized load: <xsl:value-of select="$load"/> vs. configured alarm threshold:  <xsl:value-of select="$thresh"/></xsl:attribute>
        <xsl:choose>
        <xsl:when test="$thresh = 0.0">
        100%
        </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="format-number($alarmPercent,'##0.#') "/>%
        </xsl:otherwise>
        </xsl:choose>
        </xsl:element>
        
        </span>          
        </div>
       </xsl:element><xsl:text>  </xsl:text>
      </div>
      <!-- end bar graph of load alarm ratio -->
   </xsl:when>
   <xsl:otherwise>
    <!-- do nothing for now, no sense in displaying the threshold
         if no load_avg data is being reported ...
    -->
   </xsl:otherwise>
   </xsl:choose>
 </td>
</xsl:if>


   <!-- SYSTEM ARCH for QUEUE -->
<xsl:text>
</xsl:text>
   <td class="boldcode" >
   <span style="font-size:smaller;"><xsl:value-of select="arch"/></span>
   </td>

   <!-- QUEUE STATE -->  
<xsl:text>
</xsl:text>
   <!-- had to remove id=statecolumn need to fix in CSS, maybe special boldcode .. -->
   <td class="boldcode"  >
    <xsl:element name="code">      
     <!-- Embedd a mouseover popup that lists the contents of any load-alarm-reason data we've recieved -->
     <xsl:choose>      <xsl:when test="load-alarm-reason">
       <span style="cursor: help;">
        <xsl:element name="acronym"> 
         <xsl:attribute name="title">STATE=(<xsl:value-of select="state"/>) <xsl:value-of select="load-alarm-reason"/></xsl:attribute>
<!--         <xsl:value-of select="state"/>  -->
         <img alt="" width="14" src="images/icons/silk/error.png" />
        </xsl:element><xsl:text> </xsl:text><xsl:value-of select="state"/>
       </span>       
      </xsl:when>
      <xsl:otherwise>
       <xsl:choose>
        <xsl:when test="state">
         <xsl:choose>
          <!-- Note: This block is never used because state au comes with load_alarm_reason which we test for above... -->
          <xsl:when test="state='au'">
              <span style="cursor:help;">
               <acronym title="This queue instance is in ALARM/UNREACHABLE state. Is SGE running on this node?"> <img alt="" width="14" src="images/icons/silk/link_error.png" /> </acronym><xsl:text> </xsl:text><xsl:value-of select="state"/>
              </span>
          </xsl:when>
          <xsl:when test="state='S'">
              <span style="cursor:help;">
               <acronym title="Queue is (S)uspended"> <img alt="" width="14" src="images/icons/silk/error.png" /> </acronym><xsl:text> </xsl:text><xsl:value-of select="state"/>
              </span>
          </xsl:when>
          <xsl:when test="state='d'">
              <span style="cursor:help;">
               <acronym title="This queue has been disabled by a grid administrator"> <img width="14" src="images/icons/silk/cancel.png" alt="" /> </acronym><xsl:text> </xsl:text><xsl:value-of select="state"/>
              </span>
          </xsl:when>
          <xsl:otherwise>
           <xsl:value-of select="state"/>
          </xsl:otherwise>
         </xsl:choose>
        </xsl:when>
        <xsl:otherwise>


<span style="cursor:help;">
<acronym title="Queue instance is in normal state"> <img width="14" src="images/icons/silk/accept.png" alt="" /> </acronym>
</span>

        </xsl:otherwise>
       </xsl:choose>
      </xsl:otherwise>
     </xsl:choose>
     
    </xsl:element>
   </td>
<xsl:text>
</xsl:text>   
  </tr>
<xsl:text>
</xsl:text>
  <xsl:comment>end-queue-overview-row</xsl:comment>
<xsl:text>
</xsl:text>  
 </xsl:template>
 <!-- END BLOCK DEALING WITH ROWS OF QUEUE STATUS INFO -->  
 
 
 
 
 <!-- Commenting out the seperate row for alarm reasons since we now have -->
 <!-- that info contained in a mouseover popup thingie...                 -->
 <!--                                                                     -->
 <xsl:template match="Queue-List/load-alarm-reason">              
  <!--    <tr class="alarmcode" >                                          -->
  <!--      <td colspan="8" align="right">                                 -->
  <!--        <xsl:apply-templates/>                                       -->
  <!--      </td>                                                          -->
  <!--    </tr>                                                            -->
 </xsl:template>
 
 
 
 
 <xsl:template match="Queue-List/resource">
  <xsl:element name="code">
   <xsl:value-of select="@name"/>=<xsl:value-of select="."/>
   <br/>
  </xsl:element>
 </xsl:template>
 
 
 <xsl:template match="job_list[@state='pending']">
 
 <!-- per user sort: BEGIN -->
<xsl:if test="$perUserJobSort='no' or JB_owner=$perUserJobSort ">

<xsl:text>
</xsl:text><xsl:comment>Begin Pending Job Row</xsl:comment>
<xsl:text>
</xsl:text>


  <tr>
<xsl:text>
</xsl:text>
   <td class="boldcode">
<xsl:text>
</xsl:text>
    <xsl:element name="code">
     <xsl:value-of select="JAT_prio"></xsl:value-of>
    </xsl:element>
   </td>
<xsl:text>
</xsl:text>   
   <td class="boldcode">
   <xsl:element name="a">
     <xsl:attribute name="href">job/<xsl:value-of select="JB_job_number"/>.html</xsl:attribute> 
     <xsl:attribute name="title">View information about job <xsl:value-of select="JB_job_number"/></xsl:attribute>
     </xsl:element>
     <xsl:element name="code">
      <xsl:value-of select="JB_job_number"/>    
     </xsl:element>
     
<!--    </xsl:element> -->
    
   </td>
<xsl:text>
</xsl:text>
   <td class="boldcode">
    <xsl:element name="code">

    <!-- Link Owner names to "(user)-jobs.html" with mouseover acronym -->
    <span style="cursor:help;">
	   <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="JB_owner"/>-jobs.html</xsl:attribute>
        <xsl:element name="acronym">
          <xsl:attribute name="title">View jobs owned by user <xsl:value-of select="JB_owner"/> </xsl:attribute>
         <xsl:value-of select="JB_owner"></xsl:value-of>
         </xsl:element>
       </xsl:element>
    </span>  
     
     
    </xsl:element> <!-- code -->
    
   </td>
<xsl:text>
</xsl:text>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JB_name"></xsl:value-of>
    </xsl:element>
   </td>
<xsl:text>
</xsl:text>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="slots"></xsl:value-of>
    </xsl:element>
   </td>
<xsl:text>
</xsl:text>
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="tasks"></xsl:value-of>
    </xsl:element>
   </td>
<xsl:text>
</xsl:text>
   <td class="boldcode">
    <xsl:element name="code">

<xsl:choose>
<xsl:when test="$compatMode='no'">

<!-- XSD:DATE (6.0u7 and later) date-time formatting -->
<xsl:call-template name="dt:format-date-time">
  <xsl:with-param name="xsd-date-time">
     <xsl:value-of select="JB_submission_time" />
  </xsl:with-param>
  <xsl:with-param name="format" select="'%I:%M:%S %P, %b %d'"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
  <!-- old style date/time here -->
  <xsl:value-of select="JB_submission_time"/>
</xsl:otherwise>
</xsl:choose>

    </xsl:element>
   </td>
<xsl:text>
</xsl:text>
   <td class="boldcode">
    <xsl:element name="code"> 

<!-- disable icons in pending state column until we can make them smaller

    <xsl:choose>
      <xsl:when test="state='qw'">
              <span style="cursor:help;">
               <acronym title="Pending (qw)"> 
               <img src="images/icons/silk/time.png" /> </acronym>
              </span>
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
-->

<xsl:value-of select="state"></xsl:value-of>
  
    </xsl:element>
   </td>
<xsl:text>
</xsl:text>
  </tr>
  
  <!-- output info about any resources that were specifically requested ... -->
  <xsl:choose>
   <xsl:when test="hard_request">
<xsl:text>
</xsl:text>   
    <tr class="hardRequest">
<xsl:text>
</xsl:text>
     <td colspan="8" align="right" class="alarmcode" id="hardRequest" >
     Job <xsl:value-of select="JB_job_number"/> Hard Request:  
      <xsl:apply-templates select="hard_request"/>
     </td>
<xsl:text>
</xsl:text>
    </tr>
<xsl:text>
</xsl:text>
   </xsl:when>
  </xsl:choose>
  
</xsl:if>   <!-- per user sort: END -->
  
 </xsl:template>
 
 
 
 
 
 <!-- Hard Resource Request Strings -->
 <xsl:template match="hard_request">
  <xsl:value-of select="@name"/>=<xsl:value-of select="."/>
  <xsl:text> </xsl:text>
 </xsl:template>
 
 

<!-- ACTIVE JOB  TABLE ENTRIES ... -->

 <xsl:template match="Queue-List/job_list">

<!-- need a position to do even/odd CSS class tagging ... -->
 <xsl:variable name="position" select="position()" />
 
<!-- per user sort: BEGIN -->
<xsl:if test="$perUserJobSort='no' or JB_owner=$perUserJobSort ">

<xsl:text>
</xsl:text><xsl:comment>Begin Active Job Row</xsl:comment>
<xsl:text>
</xsl:text>

<xsl:choose>
 <!-- this is a horrible way of outputting table rows with even/odd
      class names
 -->    
  <xsl:when test="$position mod 2 = 1">
    <xsl:text disable-output-escaping="yes"><![CDATA[<tr class="even">]]>
    </xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text disable-output-escaping="yes"><![CDATA[<tr class="odd">]]>
    </xsl:text>
  </xsl:otherwise>
</xsl:choose>

   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="JAT_prio"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">


   <xsl:element name="a">
     <xsl:attribute name="href">job/<xsl:value-of select="JB_job_number"/>.html</xsl:attribute> 
     <xsl:attribute name="title">View information about job <xsl:value-of select="JB_job_number"/></xsl:attribute>

     <xsl:element name="code">
      <xsl:value-of select="JB_job_number"/>      
     </xsl:element>
     
   </xsl:element>
   </td>
   
   <td class="boldcode">
    <xsl:element name="code">
     <xsl:value-of select="../name"></xsl:value-of>
    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
    
    <!-- Link Owner names to "(user)-jobs.html" with mouseover acronym -->
    <span style="cursor:help;">
	   <xsl:element name="a">
        <xsl:attribute name="href"><xsl:value-of select="JB_owner"/>-jobs.html</xsl:attribute>
        <xsl:element name="acronym">
          <xsl:attribute name="title">View jobs owned by user <xsl:value-of select="JB_owner"/> </xsl:attribute>
         <xsl:value-of select="JB_owner"></xsl:value-of>
         </xsl:element>
       </xsl:element>
    </span>  
     
     
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
 
    <xsl:element name="a">
     <xsl:attribute name="href">job/<xsl:value-of select="JB_job_number"/>:<xsl:value-of select="tasks"/>.html</xsl:attribute> 
     <xsl:attribute name="title">View information about job <xsl:value-of select="JB_job_number"/>, task <xsl:value-of select="tasks"/></xsl:attribute>
    <xsl:element name="code">
     <xsl:value-of select="tasks"></xsl:value-of>
    </xsl:element>
 </xsl:element> 
 </td>
   <td class="boldcode">
    <xsl:element name="code">
    
<xsl:choose>
<xsl:when test="$compatMode='no'">
<!-- date-time formatting -->
<xsl:call-template name="dt:format-date-time">
  <xsl:with-param name="xsd-date-time">
     <xsl:value-of select="JAT_start_time" />
  </xsl:with-param>
  <xsl:with-param name="format" select="'%I:%M:%S %P, %b %d'"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
  <!-- old style date/time here -->
  <xsl:value-of select="JAT_start_time"/>
</xsl:otherwise>
</xsl:choose>

    </xsl:element>
   </td>
   <td class="boldcode">
    <xsl:element name="code">
        <xsl:choose>
      <xsl:when test="state='r'">r</xsl:when>
<!--
              <span style="cursor:help;">
               <acronym title="Running"> 
               <img src="images/icons/silk/script_gear.png" /> </acronym>
              </span>
-->              
      <xsl:when test="state='S'">
              <span style="cursor:help;">
               <acronym title="Job in (S)ubordinate suspend state"> 
               <img alt="" src="images/icons/silk/error.png" /> </acronym>
              </span>
      </xsl:when>      
     <xsl:otherwise>
       <xsl:value-of select="state"></xsl:value-of>
     </xsl:otherwise>
    </xsl:choose> 
   </xsl:element>
   </td>
<!-- horrible way of closing out a row but necessary because
     of the choose stuff above where we do even/odd class naming
-->
<xsl:text disable-output-escaping="yes">
<![CDATA[</tr>]]>
</xsl:text>

  
</xsl:if> <!-- per user sort: END -->  

</xsl:template>
 
 <!-- need to formally match and do nothing with Queue-List/slots_total so it does not pollute HTML output -->
 <!-- (we use the value of slots_total in our match for Queue-List/slots_used template                     -->
 <xsl:template match="Queue-List/slots_total"/>
 
 
</xsl:stylesheet>
