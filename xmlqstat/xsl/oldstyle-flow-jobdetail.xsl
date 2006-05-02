<!-- BETTER XSL BUT WORSE FOR HTML FORMATTING 


<!--This table is for SGE queues and running jobs-->
<xsl:apply-templates select="/detailed_job_info/djob_info/qmaster_response"/>
   
<!-- output a wide table of SGE environment variables -->
<xsl:text>

</xsl:text>
<div class="wideJDBox">
<xsl:text>
</xsl:text>
<table width="80%" class="JDOverview">
<xsl:text>
</xsl:text>
 <tr>
<xsl:text>
</xsl:text>
  <th width="10%" align="right">SGE Environment List</th>
<xsl:text>
</xsl:text>
  <td>
<xsl:text>
</xsl:text>
   <xsl:apply-templates select="/detailed_job_info/djob_info/qmaster_response/JB_env_list/element"/>
<xsl:text>
</xsl:text>
  </td>
<xsl:text>
</xsl:text>
 </tr>
<xsl:text>
</xsl:text>
</table>
<xsl:text>
</xsl:text>
</div>   
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

