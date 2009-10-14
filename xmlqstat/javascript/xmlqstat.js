// use -*- java -*- mode for javascript

//
// set a div 'name' to visible or hidden
// set a cookie for persistence across browser reloads etc
//
function setDiv(name, state)
{
    if (state)
    {
        document.getElementById(name).style.visibility = "visible";
        document.getElementById(name).style.display    = "inline";
        SetCookie(name, "yes", null, "/");
    }
    else
    {
        document.getElementById(name).style.visibility = "hidden";
        document.getElementById(name).style.display    = "none";
        SetCookie(name, "no", null, "/");
    }
}

//
// set a div 'name' to hidden if the cookie is 'no'
//
function hideDivFromCookie(name)
{
    if (GetCookie(name) == "no")
    {
        document.getElementById(name).style.visibility = "hidden";
        document.getElementById(name).style.display    = "none";
    }
}


var req;
var result;

function loadXMLDoc(url)
{
    // branch for native XMLHttpRequest object
    if (window.XMLHttpRequest)
    {
        req = new XMLHttpRequest();
        req.onreadystatechange = processReqChange;
        req.open("GET", url, true);
        req.send(null);
        // branch for IE/Windows ActiveX version
    }
    else if (window.ActiveXObject)
    {
        req = new ActiveXObject("Microsoft.XMLHTTP");
        if (req)
        {
            req.onreadystatechange = processReqChange;
            req.open("GET", url, true);
            req.send();
        }
    }
}


function processReqChange()
{
    // alert (reg.readyState);
    // only if req shows "complete"
    if (req.readyState == 4)
    {
        // only if "OK"
        if (req.status == 200)
        {
            response = req.responseXML.documentElement;
            method   = response.getElementsByTagName('method')[0].firstChild.data;
            result   = response.getElementsByTagName('result')[0].firstChild.data;

            // alert (method) //checkName('',result)

            eval(method + '(\'\', result)');
        }
        else
        {
            alert("There was a problem retrieving the XML data:\n" + req.statusText);
        }
    }
}


function resourceList(input, response)
{
    if (response != '')
    {
        // alert("Result: " + result);
        // Response mode
        document.getElementById("DebugDetailLayer1").style.visibility = "visible";
        document.getElementById("DebugDetailLayer1").style.display    = "inline";
        message   = document.getElementById("DebugDetailLayerSpan");
        // need to put results into the DIV element ...
        // deal with response here
        var txt = document.createTextNode(result);
        var oldTxt = message.replaceChild(txt,message.firstChild);
    }
    else
    {
        // input mode
        result = '';
        url  = 'resourceList.cgi?q=' + input;
        loadXMLDoc(url);
    }
}

// ---------------------------------------------------------------- end-of-file
