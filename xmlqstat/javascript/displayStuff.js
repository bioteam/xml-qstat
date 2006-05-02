 
 
 function hideResourceDetailLayer() {
   document.getElementById("ResourceDetailLayer").style.visibility = "hidden";
   document.getElementById("ResourceDetaillayer").style.display    = "none";
   }
   
   function showDebugDetailLayer() {
   document.getElementById("DebugDetailLayer1").style.visibility = "visible";
   document.getElementById("DebugDetailLayer1").style.display    = "inline";
   }
   
   function hideDebugDetailLayer() {
   document.getElementById("DebugDetailLayer1").style.visibility = "hidden";
   document.getElementById("DebugDetailLayer1").style.display    = "none";
   }
   
   function hideQueueStatus() {
   document.getElementById("queueStatusTable").style.visibility = "hidden";
   document.getElementById("queueStatusTable").style.display    = "none";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayQtable", "no", null, "/");
   }
   
   function showQueueStatus() {
   document.getElementById("queueStatusTable").style.visibility = "visible";
   document.getElementById("queueStatusTable").style.display    = "inline";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayQtable", "yes", null, "/");
   }
   
   function hideActiveStatus() {
   document.getElementById("activeJobTable").style.visibility = "hidden";
   document.getElementById("activeJobTable").style.display    = "none";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayAJtable", "no", null, "/");
   }
   
   function showActiveStatus() {
   document.getElementById("activeJobTable").style.visibility = "visible";
   document.getElementById("activeJobTable").style.display    = "inline";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayAJtable", "yes", null, "/");
   }
   
   function hidePendingStatus() {
   document.getElementById("pendingJobTable").style.visibility = "hidden";
   document.getElementById("pendingJobTable").style.display    = "none";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayPJtable", "no", null, "/");
   }
   
   function showPendingStatus() {
   document.getElementById("pendingJobTable").style.visibility = "visible";
   document.getElementById("pendingJobTable").style.display    = "inline";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayPJtable", "yes", null, "/");
   }

   function hideJobSchedMessages() {
   document.getElementById("schedMsgList").style.visibility = "hidden";
   document.getElementById("schedMsgList").style.display    = "none";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayJobSchedMessages", "no", null, "/");
   }
   
   function showJobSchedMessages() {
   document.getElementById("schedMsgList").style.visibility = "visible";
   document.getElementById("schedMsgList").style.display    = "inline";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayJobSchedMessages", "yes", null, "/");
   }

   function hideJobActiveInfo() {
   document.getElementById("aJobInfoList").style.visibility = "hidden";
   document.getElementById("aJobInfoList").style.display    = "none";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayJobActiveInfo", "no", null, "/");
   }
   
   function showJobActiveInfo() {
   document.getElementById("aJobInfoList").style.visibility = "visible";
   document.getElementById("JobActiveInfo").style.display    = "inline";
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("displayJobActiveInfo", "yes", null, "/");
   }


   
   function setTerseOutputFilter() {
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("outputFilter", 'terse', null, "/xmlqstat");
   }
   function setDefaultOutputFilter() {
   // set a cookie to persist this preference through browser reloads etc. 
   SetCookie ("outputFilter", 'default', null, "/xmlqstat");
   }
   
   
   var req;
   var result;
   
   function loadXMLDoc(url)
   {
   // branch for native XMLHttpRequest object
   if (window.XMLHttpRequest) {
   req = new XMLHttpRequest();
   req.onreadystatechange = processReqChange;
   req.open("GET", url, true);
   req.send(null);
   // branch for IE/Windows ActiveX version
   } else if (window.ActiveXObject) {
   req = new ActiveXObject("Microsoft.XMLHTTP");
   if (req) {
   req.onreadystatechange = processReqChange;
   req.open("GET", url, true);
   req.send();
   }
   }
   }
   
   
   function processReqChange()
   {
   //alert (reg.readyState);
   // only if req shows "complete"
   if (req.readyState == 4) {
   // only if "OK"
   if (req.status == 200) {
   response  = req.responseXML.documentElement;
   method    = response.getElementsByTagName('method')[0].firstChild.data;
   result    = response.getElementsByTagName('result')[0].firstChild.data;
   
   
   //alert (method) //checkName('',result)
   
   eval(method + '(\'\', result)');
   } else {
   alert("There was a problem retrieving the XML data:\n" + req.statusText);
   }
   }
   }    
   
   
   function spoolMessages(input, response)
   {
   if (response != ''){ 
   // alert("Result: " + result);
   // Response mode
   document.getElementById("DebugDetailLayer1").style.visibility = "visible";
   document.getElementById("DebugDetailLayer1").style.display    = "inline";
   message   = document.getElementById("DebugDetailLayerSpan");
   // need to put results into the DIV element ...
   // deal with response here
   var txt = document.createTextNode(result);
   
   var oldTxt = message.replaceChild(txt,message.firstChild);
   }else{
   // input mode
   result = '';
   url  = 'spoolDebug.cgi?m=' + input;
   loadXMLDoc(url);
   }
   }
   
   
   function resourceList(input, response)
   {
   if (response != ''){ 
   // alert("Result: " + result);
   // Response mode
   document.getElementById("DebugDetailLayer1").style.visibility = "visible";
   document.getElementById("DebugDetailLayer1").style.display    = "inline";
   message   = document.getElementById("DebugDetailLayerSpan");
   // need to put results into the DIV element ...
   // deal with response here
   var txt = document.createTextNode(result);
   var oldTxt = message.replaceChild(txt,message.firstChild);
   }else{
   // input mode
   result = '';
   url  = 'resourceList.cgi?q=' + input;
   loadXMLDoc(url);
   }
   }
   
   