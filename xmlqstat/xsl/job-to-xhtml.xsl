<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:date="http://exslt.org/dates-and-times"
xmlns:datetime="http://exslt.org/dates-and-times"
xmlns="http://www.w3.org/1999/xhtml"
extension-element-prefixes="date"
>

<!-- output declarations -->
<xsl:output method="xhtml" indent="yes" version="4.01" encoding="ISO-8859-1"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>

<!-- XSL Parameters   -->
<xsl:param name="timestamp"/>
<xsl:param name="jobID"/>

<!-- Import the XSLTL library methods -->
<xsl:include href="exslt-templates/date.add-duration.function.xsl"/>  
<xsl:include href="exslt-templates/date.add.template.xsl"/>  
<xsl:include href="exslt-templates/date.duration.template.xsl"/> 


<!-- Read in our configuration XML file -->
<xsl:variable name="configFile" select="document('../xml/CONFIG.xml')" />

<!-- Read in our bitmask translation XML config file -->
<xsl:variable name="codeFile" select="document('../xml/CONFIG_statusCodes.xml')" />



<!-- pull useful bits of info out of the bit XML file -->
<xsl:variable 
name="jobID" select="/detailed_job_info/djob_info/qmaster_response/JB_job_number" 
/>
<xsl:variable 
name="onQueue" select="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/ulong_sublist/JAT_granted_destin_identifier_list/element/JG_qname" 
/>

<xsl:variable name="metaType" select="count(//JG_qname)"/>



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
<title>Details for Job: <xsl:value-of select="$jobID"/></title>
<xsl:text>

</xsl:text>
<xsl:text>
</xsl:text>
<xsl:comment> Load dortch cookie utilities</xsl:comment>
<xsl:text>
</xsl:text>
<script language="JavaScript" type="text/javascript" src="../javascript/cookie.js"></script>
<xsl:text>
</xsl:text>
<xsl:comment> Load display altering code</xsl:comment>
<xsl:text>
</xsl:text>
<script language="JavaScript" type="text/javascript" src="../javascript/displayStuff.js"></script>
<xsl:text>
</xsl:text>
<xsl:comment>Load our CSS from a file now ...</xsl:comment>
<xsl:text>
</xsl:text>
<link href="../css/xmlqstat.css" media="screen" rel="Stylesheet" type="text/css" />
<xsl:text>
</xsl:text>
<xsl:text>
</xsl:text>
<link href="../css/jobDetail.css" media="screen" rel="Stylesheet" type="text/css" />
<xsl:text>
</xsl:text>
<xsl:comment>Locally override some CSS settings ...</xsl:comment>
<xsl:text>
</xsl:text>
<style>
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


<xsl:text>

</xsl:text>    
<xsl:comment>Basic Job Data</xsl:comment>
<xsl:text>
</xsl:text>    
    <blockquote>
<xsl:text>
</xsl:text>      
     <xsl:comment> This mini table shows and hides the basic status table </xsl:comment>
<xsl:text>
</xsl:text>      
     <table width="100%" class="qstat">
<xsl:text>
</xsl:text> 
      <tbody>
       <tr>
        <td valign="middle">
         <div class="tableDescriptorElement">Overview: 
         <xsl:choose>
         <xsl:when test="$metaType = 0">
          <!-- if metaType is zero, job is pending/holding -->
           <span id="jbOverviewHeader"> 
           Job <xsl:value-of select="$jobID"/> </span>
         </xsl:when>
         <xsl:otherwise>
         <!-- most likely an active Job -->
         <span id="jbOverviewHeader"> Job <xsl:value-of select="$jobID"/> active on <xsl:value-of select="$onQueue"/> </span>
         </xsl:otherwise>
         </xsl:choose>
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
    <th>State</th>
<xsl:text>
</xsl:text> 
   <th>Owner</th>
<xsl:text>
</xsl:text> 
<th>Name</th>
<xsl:text>
</xsl:text> 
   <th>Submitted</th>
<xsl:text>
</xsl:text> 
   <th>Script</th>
<xsl:text>
</xsl:text> 
   <th>Exec. File</th>
<xsl:text>
</xsl:text> 
   <th>uid</th>
<xsl:text>
</xsl:text> 
   <th>gid</th>
<xsl:text>
</xsl:text> 
   <th>group</th>
<xsl:text>
</xsl:text>
  </tr>
<xsl:text>
</xsl:text> 
<tbody>
<xsl:text>
</xsl:text>         
 <!-- end of table header row, start filling in those TDs now ... -->
<xsl:text>
</xsl:text>         
<td><!-- STATE --> 
<!-- STATE XPATH IS DIFFERENT FOR ACTIVE VS PENDING/HELD JOBS !!!!!!! -->

<xsl:choose>
<xsl:when test="$metaType = 0">
<xsl:variable name="state">
<xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_ja_template/ulong_sublist/JAT_state" />
</xsl:variable>

    <span style="cursor: help;">
     <xsl:element name="acronym">
      <xsl:attribute name="title">
        <!-- this lookup translates JAT_state to something more readable -->
      <xsl:value-of select="$codeFile/config/status[@bitmask=$state]/long"/>. The raw JAT_state bitmask code is: <xsl:value-of select="$state"/>
      </xsl:attribute>
<xsl:value-of select="$codeFile/config/status[@bitmask=$state]/translation"/>
     </xsl:element>
     </span>
<!-- for debug use
      (<xsl:value-of select="$state"/>)
-->

</xsl:when>
<xsl:otherwise>
<xsl:variable name="state">
<xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/ulong_sublist/JAT_state" />
</xsl:variable>

    <span style="cursor: help;">
     <xsl:element name="acronym">
      <xsl:attribute name="title">
        <!-- this lookup translates JAT_state to something more readable -->
      <xsl:value-of select="$codeFile/config/status[@bitmask=$state]/long"/>. The raw JAT_state bitmask code is: <xsl:value-of select="$state"/>
      </xsl:attribute>
<xsl:value-of select="$codeFile/config/status[@bitmask=$state]/translation"/>
     </xsl:element>
     </span>
<!-- for debug use
      (<xsl:value-of select="$state"/>)
-->

</xsl:otherwise>
</xsl:choose>

</td>

<td><!-- Owner --> <xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_owner" /></td>

<td><!-- Name --> <xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_job_name" /></td>

<td><!-- Submitted --> <xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_submission_time" />


<xsl:variable name="subDuration">
<xsl:call-template name="date:duration">
 <xsl:with-param name="seconds">1135351646</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- link on this issue
http://lists.fourthought.com/pipermail/exslt/2001-November/000349.html
<-->

<!--
(<xsl:value-of select="$subDuration"/>) 
-->

<!-- this template call crashes cocoon 
(
<xsl:call-template name="date:add">
 <xsl:with-param name="date-time">1970-01-01T00:00:00</xsl:with-param>
 <xsl:with-param name="duration"><xsl:value-of select="$subDuration"/></xsl:with-param>
</xsl:call-template>
)
-->




</td>

<td><!-- Script --> <xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_script_file" /></td>

<td><!-- Exec file --> <xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_exec_file" /></td>

<td><!-- POSIX: uid--> <xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_uid" /></td>

<td><!-- POSIX: gid--> <xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_gid" /></td>

<td><!-- POSIX: group--> <xsl:value-of select="/detailed_job_info/djob_info/qmaster_response/JB_group" /></td>

 </tbody>
<xsl:text>
</xsl:text> 
 </table>
<xsl:text>
</xsl:text> 
</div>

<div>
</div>

<xsl:text>
</xsl:text>      


<!-- break up the tables -->
<div>
 <br/>
</div>


<xsl:text>
</xsl:text>      
     <table width="100%" class="qstat">
<xsl:text>
</xsl:text> 
      <tbody>

<!-- don't print queue instance or host data for pending/held jobs -->
<xsl:choose>
<xsl:when test="$metaType = 0">
 	  <!-- nothing -->
</xsl:when>
<xsl:otherwise>
       <th>Queue Instance</th>
       <th>Host</th>
</xsl:otherwise>
</xsl:choose>
       <th>cwd</th>
       <th>Project</th>
       <th>Department</th>
       </tbody>
<xsl:text>
</xsl:text> 
<tr id="activeJobRow" class="jobDetailRow">

<xsl:choose>
<xsl:when test="$metaType = 0">
 <!-- nothing -->
</xsl:when>
<xsl:otherwise>
<td><xsl:value-of select="//JG_qname"/></td>
<td><xsl:value-of select="//JG_qhostname"/></td>
</xsl:otherwise>
</xsl:choose>

<td><xsl:value-of select="//JB_cwd"/></td>
<td><xsl:value-of select="//JB_project"/></td>
<td><xsl:value-of select="//JB_department"/></td>
</tr>
</table>
     
<!-- break up the tables -->
<div>
 <br/>
</div>

<xsl:text>
</xsl:text>      

<xsl:text>
</xsl:text>      
     <table width="100%" class="qstat">
<xsl:text>
</xsl:text> 
      <tbody>
       <th>
         <div class="tableDescriptorElement">Scheduling Messages: <xsl:value-of select="count(/detailed_job_info/messages/qmaster_response/SME_global_message_list/element/MES_message)"/></div>
       </th>
       <xsl:apply-templates
       select="/detailed_job_info/messages/qmaster_response/SME_global_message_list"  />
  

      </tbody>
<xsl:text>
</xsl:text> 
     </table>
<xsl:text>

</xsl:text>         

<xsl:text>
</xsl:text>      


<xsl:text>
</xsl:text>      

<!-- DISABLE FOR NOW 
     <table width="100%" class="qstat">
<xsl:text>
</xsl:text> 
      <tbody>
       <th>share</th>
       <th>fshare</th>
       <th>oticket</th>
       <th>fticket</th>
       <th>sticket</th>
       <th>priority</th>
       <th>ntix</th>
       </tbody>
<xsl:text>
</xsl:text> 
<tr id="priorityJobRow" class="jobDetailRow">
<td><xsl:value-of select="//JB_ja_template/ulong_sublist/JAT_share"/></td>
<td><xsl:value-of select="//JB_ja_template/ulong_sublist/JAT_fshare"/></td>
<td><xsl:value-of select="//JB_ja_template/ulong_sublist/JAT_oticket"/></td>
<td><xsl:value-of select="//JB_ja_template/ulong_sublist/JAT_fticket"/></td>
<td><xsl:value-of select="//JB_ja_template/ulong_sublist/JAT_sticket"/></td>
<td><xsl:value-of select="//JB_ja_template/ulong_sublist/JAT_prio"/></td>
<td><xsl:value-of select="//JB_ja_template/ulong_sublist/JAT_ntix"/></td>

</tr>
</table>

-->


</blockquote>

<xsl:text>
</xsl:text>

<!-- stuff below is XHTML boilerplate for the basic page layout -->

<xsl:text>

</xsl:text>
<xsl:comment>Bottom status bar</xsl:comment>
<xsl:text>
</xsl:text>
<div id="bottomBar">
     Page rendered: <xsl:value-of select="$timestamp"/>
</div>
<xsl:text>

</xsl:text>
</div> <xsl:comment>This is the end of main content </xsl:comment>
<xsl:text>

</xsl:text><xsl:comment>bottom box section </xsl:comment>
<xsl:text>
</xsl:text>
<div class="bottomBox">
 
</div>
<xsl:text>
</xsl:text>   
</body>  
<xsl:text>
</xsl:text>
</html>
</xsl:template>


<!-- 
This is a massive catch-all element that does nothing but "do nothing" when certain XML elements are  hit. This is because the way we process this document, any un-matched XML nodes are printed out as-is which breaks all sorts of HTML output. So basically we match *here* all the stuff that we currently are not displaying or using. 
-->
 
 <xsl:template match="JB_job_number|JB_job_name|JB_version|JB_session|JB_department|JB_exec_file|JB_script_file|JB_script_size|JB_submission_time|JB_execution_time|JB_deadline|JB_owner|JB_uid|JB_group|JB_gid|JB_account|JB_cwd|JB_notify|JB_type|JB_reserve|JB_priority|JB_jobshare|JB_shell_list|JB_verify|JB_env_list|JB_checkpoint_attr|JB_checkpoint_object|JB_checkpoint_interval|JB_restart|JB_merge_stderr|JB_mail_options|JB_mail_list|JB_ja_structure|JB_ja_n_h_ids|JB_ja_template|B_host|JB_verify_suitable_queues|JB_nrunning|JB_soft_wallclock_gmt|JB_hard_wallclock_gmt|JB_override_tickets|JB_path_aliases|JB_urg|JB_nurg|JB_nppri|JB_rrcontr|JB_dlcontr|JB_wtcontr"/>

 <xsl:template match="//djob_info/qmaster_response">
<xsl:text>
</xsl:text>
  <div class="wideJDBox" >  
<xsl:text>
</xsl:text>
   <table width="80%" class="JDOverview">
<xsl:text>
</xsl:text>
    <tr>
<xsl:text>
</xsl:text>
     <th align="right">Job ID</th>
<xsl:text>
</xsl:text>
     <td><xsl:value-of select="JB_job_number"/></td>
<xsl:text>
</xsl:text>     
    </tr>
<xsl:text>
</xsl:text>
    <tr> 
<xsl:text>
</xsl:text>
     <th align="right">Owner</th>
<xsl:text>
</xsl:text>
     <td><xsl:value-of select="JB_owner"/></td>
<xsl:text>
</xsl:text>
    </tr>
<xsl:text>
</xsl:text>
    <tr>
<xsl:text>
</xsl:text>
     <th align="right" valign="top">Script</th>
     <td><xsl:value-of select="JB_script_file"/></td>
<xsl:text>
</xsl:text>
    </tr>
<xsl:text>
</xsl:text>    
    <tr>
<xsl:text>
</xsl:text>
     <th align="right" valign="top">Job Name</th>
     <td><xsl:value-of select="JB_job_name"/></td>
    </tr>
<xsl:text>
</xsl:text>
    <tr>
     <th align="right" valign="top">CWD</th>
     <td><xsl:value-of select="JB_cwd"/></td>
<xsl:text>
</xsl:text>
    </tr>
<xsl:text>
</xsl:text>
    <tr>
<xsl:text>
</xsl:text>
     <th align="right" valign="top"><xsl:value-of select="count(/detailed_job_info/messages/qmaster_response/SME_global_message_list/element/MES_message)"/> Scheduler Messages</th>
     <td><div width="100%" id="schedMsgHeader">
     
     <a href="#" border="0" onclick="hideJobSchedMessages()"><img border="0" src="../images/uparrow.gif" alt="Hide Table " /></a><a href="#" border="0" onclick="showJobSchedMessages()"><img border="0" src="../images/dnarrow.gif" alt="Hide Table " /></a></div><div id="schedMsgList" width="100%">
     
 <!--    <xsl:apply-templates select="/detailed_job_info/messages/qmaster_response/SME_global_message_list"  /> -->
     
     </div></td>
<xsl:text>
</xsl:text>     
    </tr>
<xsl:text>
</xsl:text>

<!-- need to insert a row here only if the job is active on an exec host                   
     Our test is for the existence of a node named 
     "JAT_granted_destin_identifier_list" 
      in the qstat xml output                                                             -->
    
    <xsl:choose>
     <!-- DO THIS WHEN THERE ARE ACTIVE/RUNNING JOBS -->
     <xsl:when test="//JAT_granted_destin_identifier_list">
      <tr>
       <th align="right" valign="top"> Active job info</th>
       <td>

<!-- NO NEED TO CHOOSE BETWEEN THESE TWO SINCE THE MATCH PATTERNS
     ARE UNIQUE WITHIN 'OLD' VS 'NEW' XML output
-->
<!-- THIS WILL MATCH OLD STYLE XML -->
<xsl:apply-templates select="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/element/JAT_granted_destin_identifier_list/element"/>

<!-- THIS WILL MATCH NEW STYLE XML -->
<div width="100%" id="schedMsgHeader"><a href="#" border="0" onclick="hideJobActiveInfo()"><img border="0" src="../images/uparrow.gif" alt="Hide Table " /></a> <a href="#" border="0" onclick="showJobActiveInfo()"><img border="0" src="../images/dnarrow.gif" alt="Hide Table " /></a></div><div  id="aJobInfoList"><xsl:apply-templates select="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/ulong_sublist/JAT_granted_destin_identifier_list/element"/></div>
<!-- NEW STYLE -->
</td>

      </tr>
     </xsl:when>
     <xsl:otherwise>
      <!-- DO NOTHING (NO NEED TO INSERT TABLE ROW W/ ACTIVE JOB INFO... -->
     </xsl:otherwise>
    </xsl:choose>
    
    <tr>
     <th align="right" valign="top">POSIX</th>
     <td>
      uid = <xsl:value-of select="JB_uid"/>
      <br/>
      gid = <xsl:value-of select="JB_gid"/>
      <br/>
      group = <xsl:value-of select="JB_group"/>
     </td>
      
    </tr>
    
    <tr>
     <th align="right" valign="top">Department</th>
     <td>
      <xsl:value-of select="JB_department"/> 
     </td>
    </tr>
    
    <xsl:choose>
     <xsl:when test="//JB_project">
      <!-- WRITE PROJECT INFO OUT -->
      <tr>
       <th align="right" valign="top">Project</th>
       <td>
        <xsl:value-of select="JB_project"/>
         
       </td>
      </tr>
     </xsl:when>
     <xsl:otherwise>
      <!-- DO NOTHING -->
     </xsl:otherwise>
    </xsl:choose>
    
    <tr>
     <th align="right" valign="top">Path Aliases</th>
     <td>
      <pre>
       <xsl:apply-templates select="/detailed_job_info/djob_info/qmaster_response/JB_path_aliases/element"/>
      </pre>
     </td>
    </tr>
    
    
    <!-- output ae table of job resource usage data ONLY IF IT IS DEFINED-->
    <xsl:choose>
     <xsl:when test="//JAT_usage_list/element">
      <!-- WRITE INFO OUT -->
      <tr>
       <th align="right" valign="top">Usage</th>
       <td>
        <xsl:apply-templates select="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/element/JAT_usage_list/element"/>
       </td>
      </tr>
     </xsl:when>
     <xsl:otherwise>
      <!-- DO NOTHING -->
     </xsl:otherwise>
    </xsl:choose>
    
    <!-- output a table of scaled job resource usage data ONLY IF IT IS DEFINED  -->
    <xsl:choose>
     <xsl:when test="//JAT_scaled_usage_list/element">
      <!-- WRITE INFO OUT -->
      <tr>
       <th align="right" valign="top">Scaled Usage</th>
       <td>
        <xsl:apply-templates select="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/element/JAT_scaled_usage_list/element"/>
       </td>
      </tr>
     </xsl:when>
     <xsl:otherwise>
      <!-- DO NOTHING -->
     </xsl:otherwise>
    </xsl:choose>
     
    
   </table>
  </div>
  
  <xsl:comment/>
  <xsl:comment> ========================================================================   </xsl:comment>
  <xsl:comment>  We use fixed-size tables constrained within thinJDBox DIV elements here.  </xsl:comment>
  <xsl:comment>  We can cleanly output a variable number of these small tables             </xsl:comment>
  <xsl:comment>  because the DIVs "float right" and line themselves up well ...            </xsl:comment>
  <xsl:comment> ========================================================================   </xsl:comment>
  <xsl:comment/>
  
 </xsl:template>
 
 
 <xsl:template match="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/element/JAT_usage_list/element">
  <xsl:value-of select="UA_name"/> = <xsl:value-of select="UA_value"/>
  <br/>
  
 </xsl:template>
 
 <xsl:template match="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/element/JAT_scaled_usage_list/element">
  <xsl:value-of select="UA_name"/> = <xsl:value-of select="UA_value"/>
  <br/>
  
 </xsl:template>
 
 
 
 <xsl:template match="/detailed_job_info/djob_info/qmaster_response/JB_env_list/element">
  
  <xsl:value-of select="VA_variable"/> = <xsl:value-of select="VA_value"/>
  <br/>
   
 </xsl:template>
 
 <xsl:template match="/detailed_job_info/djob_info/qmaster_response/JB_path_aliases/element">
  <xsl:value-of select="PA_origin"/>
  <xsl:text>   </xsl:text><xsl:value-of select="PA_submit_host"/>
  <xsl:text>   </xsl:text><xsl:value-of select="PA_exec_host"/>
  <xsl:text>   </xsl:text><xsl:value-of select="PA_translation"/>
  <br/>
  
 </xsl:template>

<xsl:template match="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/ulong_sublist/JAT_granted_destin_identifier_list/element">

<div class="even">queue instance = 
  <strong><xsl:value-of select="JG_qname"/></strong>
</div>
<div class="odd">queue hostname = <xsl:value-of select="JG_qhostname"/></div>
<div class="even">tag_slave_job  = <xsl:value-of select="JG_tag_slave_job"/></div>
<div class="odd">task_id_range  = <xsl:value-of select="JG_task_id_range"/></div>
<div class="even">share = <xsl:value-of select="../../JAT_share" /></div>
<div class="odd">fshare = <xsl:value-of select="../../JAT_fshare" /></div>
<div class="even">ticket = <xsl:value-of select="../../JAT_tix" /></div>
<div class="odd">oticket = <xsl:value-of select="../../JAT_oticket"/></div>
<div class="even">fticket = <xsl:value-of select="../../JAT_fticket"/></div>
<div class="odd">sticket = <xsl:value-of select="../../JAT_sticket"/></div>
<div class="even">priority =  <xsl:value-of select="../../JAT_prio"/></div>
<div class="odd">ntix =   <xsl:value-of select="../../JAT_ntix"/></div>
<div class="even">overide_tickets = <xsl:value-of select="../../../../JB_override_tickets"/></div>
</xsl:template>

 
 <!-- OLD PRE SGE 6.0u7 -->
 <xsl:template match="/detailed_job_info/djob_info/qmaster_response/JB_ja_tasks/element/JAT_granted_destin_identifier_list/element">
  
<div class="even">queue instance = 
  <strong><xsl:value-of select="JG_qname"/></strong>
</div>
<div class="odd">queue hostname = <xsl:value-of select="JG_qhostname"/></div>
<div class="even">tag_slave_job  = <xsl:value-of select="JG_tag_slave_job"/></div>
<div class="odd">task_id_range  = <xsl:value-of select="JG_task_id_range"/></div>
<div class="even">share = <xsl:value-of select="../../JAT_share" /></div>
<div class="odd">fshare = <xsl:value-of select="../../JAT_fshare" /></div>
<div class="even">ticket = <xsl:value-of select="../../JAT_tix" /></div>
<div class="odd">oticket = <xsl:value-of select="../../JAT_oticket"/></div>
<div class="even">fticket = <xsl:value-of select="../../JAT_fticket"/></div>
<div class="odd">sticket = <xsl:value-of select="../../JAT_sticket"/></div>
<div class="even">priority =  <xsl:value-of select="../../JAT_prio"/></div>
<div class="odd">ntix =   <xsl:value-of select="../../JAT_ntix"/></div>
<div class="even">overide_tickets = <xsl:value-of select="../../../../JB_override_tickets"/></div>  
 </xsl:template>
 

<!-- one of the componenets of a SGE scheduler message -->
<xsl:template match="MES_message_number">

<!-- funky stuff required to determine node position in context
     so we can use our standard mod math to determine even/odd class
     tag names
-->
<xsl:variable name="position" 
  select="1 + count(parent::*/preceding-sibling::*)" 
/>

<xsl:choose>
<xsl:when test="$position mod 2 = 1">
 <tr class="schedMesgRow"><td><span class="even"><xsl:value-of select="../MES_message"/></span></td>
 </tr>
</xsl:when>
<xsl:otherwise>
 <tr class="schedMesgRow"><td><span class="odd"><xsl:value-of select="../MES_message"/></span></td>
 </tr>
</xsl:otherwise>
</xsl:choose>
</xsl:template>



<xsl:template match="MES_message">
<!-- do nothing because we output this in the template above -->
</xsl:template>


 <!-- SCHEDULER MESSAGE DIV LIST -->
<xsl:template match="/detailed_job_info/messages/qmaster_response/SME_global_message_list/element">
<xsl:apply-templates/> 
</xsl:template>
 
 

 
 
 


</xsl:stylesheet>