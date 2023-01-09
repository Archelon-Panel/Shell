const IsInIframe = window.self !== window.top
const urlSearchParams = new URLSearchParams(window.location.search); window.QueryParameters = Object.fromEntries(urlSearchParams.entries());
window.p = console.log

//#region Main api
if (IsInIframe) {
    window.Archelon = window.top.Archelon
} else {
    window.Archelon = {
        
    }
}
//#endregion
//#region additional prototypes
String.prototype.interpolate = function(params) {
    const names = Object.keys(params);
    const vals = Object.values(params);
    return new Function(...names, `return \`${this}\`;`)(...vals);
}

Number.prototype.clamp = function(min, max) {
    return Math.min(Math.max(this, min), max);
};

function Sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
//#endregion
//#region https://github.com/benhowdle89/deSVG
!function(){"use strict";window.deSVG=function(t,e){e=e||!1;var r,n,o={},a=function(t,e){var r=t.id,n=t.getAttribute("class");r&&(e.id=r),n&&e.setAttribute("class",n+" replaced-svg"),t.parentNode.replaceChild(e,t)};for(n=(r=document.querySelectorAll(t)).length;n--;){var i,l=r[n];o[i=l.getAttribute("data-src")?l.getAttribute("data-src"):l.getAttribute("src")]?o[i].push(l):o[i]=[l]}for(var s in o)o.hasOwnProperty(s)&&function(t,r){var n=new XMLHttpRequest;n.open("GET",t,!0),n.onload=function(){var t,o,i,l;if(t=n.responseXML,l=r.length,t){if(o=t.documentElement,i=o.querySelectorAll("path"),e)for(var s=0;s<i.length;s++)i[s].removeAttribute("style");for(o.removeAttribute("xmlns:a");l--;)a(r[l],o.cloneNode(!0))}},n.send()}(s,o[s])}}();
deSVG('img', true);
//#endregion
//#region HTTP
if (!IsInIframe) {
    Archelon.HTTP = {}

    Archelon.HTTP.Request = async function(Method="GET", Url, Headers={}, Body) {
        var Data
        var ReturnData
        try {
            Data = await fetch(
                Url,
                {
                    method: Method,
                    headers: Headers,
                    body: Body
                }
            )
            ReturnData = {
                Code: Data.status,
                Ok: Data.ok,
                Headers: Data.headers,
                Body: await Data.text()
            }
            ReturnData.Data = ReturnData.Body
        } catch (error) {
            ReturnData = {Ok: false}
        }
        
        return ReturnData
    }

    Archelon.HTTP.JsonRequest = async function(Method, Url, Headers, Body) {
        const Data = await Archelon.HTTP.Request(Method, Url, Headers, await JSON.stringify(Body))
        try {
            Data.Data = await JSON.parse(Data.Body)
        } catch {}
        return Data
    }

    Archelon.HTTP.APIRequest = async function(Method, Url, Headers, Body, Json=true) {
        if (Json) {
            return await Archelon.HTTP.JsonRequest(Method, Archelon.HTTP.APIUrl + Url, Headers, Body)
        } else {
            return await Archelon.HTTP.Request(Method, Archelon.HTTP.APIUrl + Url, Headers, Body)
        }
    }

    if ((await Archelon.HTTP.Request("GET", "/api/v1/ping")).Ok) {
        Archelon.HTTP.APIUrl = location.origin
    } else if ((await Archelon.HTTP.Request("GET", "http://localhost:443/api/v1/ping")).Ok) {
        Archelon.HTTP.APIUrl = "http://localhost:443"
    } else {
        alert("Could not connect to panel")
    }
}
//#endregion