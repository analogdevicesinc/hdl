!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?module.exports=t():"function"==typeof define&&define.amd?define(t):(e="undefined"!=typeof globalThis?globalThis:e||self).App=t()}(this,(function(){"use strict";const e={repository:void 0,version:void 0,offline:void 0,theme:void 0,content_root:void 0,sub_hosted:void 0,path:void 0,reloaded:void 0,metadata:void 0};class t{constructor(t){this.init_state(e),this.parent=t,t.state=e}repository(){let e=document.querySelector('meta[name="repository"]');return e?e.content:""}version(){let e=document.querySelector('meta[name="version"]');if(null!==e){return e.content}}content_root(){let e,t=document.querySelector("script#documentation_options");return null!==t&&(e=t.dataset.url_root),null==e&&(e=document.querySelector("html").dataset.content_root),null==e&&(t=document.querySelector(".repotoc-tree .current"),null!==t&&(e=t.getAttribute("href").replace("index.html",""))),null==e&&(console.warn("Failed to get content root."),e=""),e}sub_hosted(e,t){let r=new URL(e,location).href,s=new URL(t,location.origin).href;return r.startsWith(s)}path(e,t,r){r||(t="");let s=new URL(e,location).href,o=new URL(t,location.origin).href;return s.startsWith(o)?s.replace(o,"").replace(/^\/|\/$/g,""):""}reloaded(){return!!window.performance&&performance.navigation.type===performance.navigation.TYPE_RELOAD}init_state(e){e.repository=this.repository(),e.version=this.version(),e.offline="file:"==window.location.protocol,e.theme=localStorage.getItem("theme"),e.content_root=this.content_root(),e.offline||(e.sub_hosted=this.sub_hosted(e.content_root,e.repository),e.path=this.path(e.content_root,e.repository,e.sub_hosted)),e.reloaded=this.reloaded()}}class r{static randomChar(){const e="abcdefghijklmnopqrstuvwxyz";return e[Math.floor(26*Math.random())]}static UID(){return this.randomChar()+(+new Date).toString(36)+Math.random().toString(36).substring(3)}static SID(){return this.randomChar()+Math.random().toString(36).substring(3,8)}static fromUrl(e){let t=new URLSearchParams(document.location.search);return null==t.get(e)?this.urlDefaults(e):this.urlValidParams(e,t.get(e))}static urlDefaults(e){if("theme"===e)return"light"}static urlValidParams(e,t){if("theme"===e)return["dark","light"].includes(t)?t:this.urlDefaults(e)}static cleanPathname(e){return e.replace(/([^:]\/)\/+/g,"$1").replace(/[^:]\.\//g,"$1")}static getDepth(e){return(e.match(/\//g)||[]).length}static async try_redirect(e,t){try{404===(await fetch(e,{method:"HEAD"})).status?console.log(t):location.href=e}catch(e){location.href=t}}static async fetch_each(e){for(let t of e)try{const e=await fetch(t,{method:"Get",headers:{"Content-Type":"application/json"}});if(!0===e.ok)return{obj:await e.json(),url:t};if(404!==e.status)return{error:e,url:t}}catch(e){return{error:e,url:t}}return{error:`No url returned a valid JSON, urls: ${e}`}}static cache_check(e,t,s,o){Array.isArray(t)||(t=[t]);let a=t[0],n=localStorage.getItem(a);null!==n&&(n=JSON.parse(n));let i=new Date(0);i.setHours(s),!0===e.reloaded||null===n||n.timestamp+i.valueOf()<Date.now()?r.fetch_each(t).then((e=>{"error"in e?console.error("Failed to fetch resource, due to:",e.error):(e.timestamp=Date.now(),o(e),localStorage.setItem(a,JSON.stringify(e)))})):o(n)}}class s{constructor(e,t){if(this.$,"string"==typeof e){if(this.$=document.createElement(e),"object"==typeof t)for(const e in t)e in this.$?this.$[e]=t[e]:this.$.dataset[e]=t[e]}else this.$=e}cloneNode(e){return new s(this.$.cloneNode(e))}set innerText(e){this.$.innerText=e}get innerText(){return this.$.innerText}get height(){return this.$.offsetHeight}get width(){return this.$.offsetWidth}get id(){return this.$.id}set id(e){this.$.id=e}get value(){return this.$.value}set value(e){this.$.value=e}get src(){return this.$.src}set src(e){this.$.src=e}focus(){this.$.focus()}get classList(){return this.$.classList}get style(){return this.$.style}onchange(e,t,r){return this.$.onchange=s=>{void 0===r?t.apply(e,[s]):r.constructor==Array&&(r.push(s),t.apply(e,r))},this}onclick(e,t,r){return this.$.onclick=s=>{void 0===r?t.apply(e,[s]):r.constructor==Array&&(r.push(s),t.apply(e,r))},this}onup(e,t,r){return this.$.addEventListener("mouseup",(s=>{void 0===r?t.apply(e,[s]):r.constructor==Array&&(r.push(s),t.apply(e,r))})),this}ondown(e,t,r){return this.$.addEventListener("mousedown",(s=>{void 0===r?t.apply(e,[s]):r.constructor==Array&&(r.push(s),t.apply(e,r))})),this}onmove(e,t,r){return this.$.addEventListener("mousemove",(s=>{void 0===r?t.apply(e,[s]):r.constructor==Array&&(r.push(s),t.apply(e,r))})),this}onevent(e,t,r,s){return this.$.addEventListener(e,(e=>{void 0===s?r.apply(t,[e]):s.constructor==Array&&(s.push(e),r.apply(t,s))})),this}append(e){return e.constructor!=Array&&(e=[e]),e.forEach((e=>{/HTML(.*)Element/.test(e.constructor.name)?this.$.appendChild(e):"object"==typeof e&&/HTML(.*)Element/.test(e.$.constructor.name)&&this.$.appendChild(e.$)})),this}delete(){this.$.remove()}removeChilds(){let e=this.$.lastElementChild;for(;e;)this.$.removeChild(e),e=this.$.lastElementChild;return this}static get(e,t){return void 0===(t=t instanceof s?t.$:t)?document.querySelector(e):t.querySelector(e)}static getAll(e,t){return"object"==typeof(t=t instanceof s?t.$:t)?t.querySelectorAll(e):get(t).querySelectorAll(e)}static switchState(e,t){let r=null!=t?t:"on";(e=e instanceof s?e.$:e).classList.contains(r)?e.classList.remove(r):e.classList.add(r)}static UID(){return(+new Date).toString(36)+Math.random().toString(36).substr(2)}static prototypeDetails(e){let t=new s("summary",{innerText:e.innerText}),r=new s("details",{id:e.id,name:e.id}).append(t);return null!=e.onevent&&e.onevent.forEach((e=>{e.args.push(r.$),t.onevent(e.event,e.self,e.fun,e.args)})),r}static prototypeInputFile(e){return new s("label",{htmlFor:`${e.id}_input`,id:e.id,className:e.className,innerText:e.innerText}).append(new s("input",{id:`${e.id}_input`,type:"file"}))}static prototypeCheckSwitch(e){let t=new s("input",{id:e.id,name:e.id,className:"checkswitch",type:"checkbox",value:!1});return[t,new s("div",{className:e.className}).append([new s("div").append([new s("label",{className:"checkswitch",htmlFor:e.id,innerText:e.innerText}).append([t,new s("span")])])])]}static prototypeDownload(e,t){let r,s=/.*\.(py|xml|csv|json|svg|png)$/;if(!s.test(e))return;let o=e.match(s)[1];switch(e=e.replaceAll("/","-").replaceAll(" ","_").toLowerCase(),o){case"xml":r="data:x-application/xml;charset=utf-8,"+encodeURIComponent(t);break;case"py":r="data:text/python;charset=utf-8,"+encodeURIComponent(t);break;case"json":r="data:text/json;charset=utf-8,"+encodeURIComponent(t);break;case"csv":r="data:text/csv;charset=utf-8,"+encodeURIComponent(t);break;case"svg":r="data:image/svg+xml;charset=utf-8,"+encodeURIComponent(t);break;case"png":r=t}let a=document.createElement("a");a.setAttribute("href",r),a.setAttribute("download",e),a.style.display="none",document.body.appendChild(a),a.click(),document.body.removeChild(a)}static setSelected(e,t){for(var r=0;r<e.$.options.length;r++)if(e.$.options[r].text==t)return void(e.$.options[r].selected=!0)}static lazyUpdate(e,t,r,o){o=null==o?"innerText":o;let a=s.get(`[data-uid='${t}']`,e);for(const e in r)s.get(`#${e}`,a)[o]=r[e]}}class o{constructor(e){(this.$={}).head=new s(s.get("head")),this.parent=e,this.init()}init(){!0!==this.parent.state.offline?!1!==this.parent.state.sub_hosted?r.cache_check(this.parent.state,["/doctools/metadata.json","https://analogdevicesinc.github.io/doctools/metadata.json"],24,(e=>{this.init_metadata(e)})):console.log("fetch: dynamic features are not available for single repository doc"):console.log("fetch: dynamic features are not available in offline mode")}init_metadata(e){this.parent.state.metadata=e.obj,"modules"in e.obj&&this.load_modules(e.obj.modules,e.url)}load_modules(e,t){"string"==typeof t?(t=t.startsWith("https://")||t.startsWith("http://")?new URL(t).origin:"","javascript"in e&&e.javascript.forEach((e=>{let r=new s("script",{src:`${t}/doctools/_static/${e}`});this.$.head.append(r)})),"stylesheet"in e&&e.stylesheet.forEach((e=>{let r=new s("link",{rel:"stylesheet",type:"text/css",href:`${t}/doctools/_static/${e}`});this.$.head.append(r)}))):console.warn("Expected string with url, got ",t)}}class a{constructor(e){this.parent=e,this.portrait=!1,this.scrollSpy={localtoc:new Map,currentLocaltoc:void 0};let t=this.$={};t.body=new s(s.get("body")),t.content=new s(s.get(".body section")),t.localtoc=new s(s.get(".tocwrapper > nav > ul > li")),this.scroll_spy(),null===this.parent.state.theme&&(this.parent.state.theme=this.os_theme()),t.body.classList.add("js-on"),this.parent.state.theme!==this.os_theme()&&t.body.classList.add(this.parent.state.theme),t.searchButton=new s("button",{id:"search",className:"icon",title:"Search (/)"}).onclick(this,(()=>{s.switchState(t.searchArea),s.switchState(t.searchAreaBg),t.searchInput.focus(),t.searchInput.$.select()})),t.changeTheme=new s("button",{className:"dark"===this.parent.state.theme?"icon on":"icon",id:"theme",title:"Switch theme"}).onclick(this,(()=>{t.body.classList.remove(this.parent.state.theme),this.parent.state.theme="dark"===this.parent.state.theme?"light":"dark",this.os_theme()==this.parent.state.theme?localStorage.removeItem("theme"):(localStorage.setItem("theme",this.parent.state.theme),t.body.classList.add(this.parent.state.theme))})),t.searchAreaBg=new s("div",{className:"search-area-bg"}).onclick(this,(()=>{s.switchState(t.searchArea),s.switchState(t.searchAreaBg)})),t.searchArea=new s(s.get(".search-area")),t.searchForm=new s(s.get("form",t.searchArea)),t.searchInput=new s(s.get("input",t.searchForm)),t.searchForm.$.action=s.get('link[rel="search"]').href,t.body.append([t.searchAreaBg]),t.preserve_scroll={},t.preserve_scroll.sphinxsidebarwrapper=new s(s.get(".sphinxsidebarwrapper")),t.rightHeader=new s(s.get("header #right span.reverse")).append([t.changeTheme,t.searchButton]),t.relatedNext=s.get(".related .next"),t.relatedPrev=s.get(".related .prev"),this.init(),e.navigation=this}scroll_spy(){null!==this.$.localtoc.$&&this.prepareLocaltocMap()}prepareLocaltocMap(){let e="",t=this.scrollSpy.localtoc,r=0;s.getAll(".reference.internal",this.$.localtoc).forEach((s=>{e=`${r}_${s.textContent}`,t.set(e,[s,void 0]),r+=1}));let o=[];for(let e=0;e<7;e++)o.push(...s.getAll(`section > h${e}`,this.$.content));o=o.sort(((e,t)=>e.getBoundingClientRect().y-t.getBoundingClientRect().y)),r=0,o.forEach((s=>{e=s.textContent,e=`${r}_${e}`,t.has(e)&&(t.set(e,[t.get(e)[0],s]),r+=1)})),t.forEach(((e,t,r)=>{void 0===e[1]&&r.delete(t)}))}handleResize(){this.portrait=window.innerHeight>window.innerWidth}handleScroll(){if(null!==this.$.localtoc.$){let e,t,r,s,o=Number.MAX_SAFE_INTEGER,a=Number.MIN_SAFE_INTEGER,n=this.scrollSpy.localtoc;if(n.forEach(((r,n,i)=>{s=r[1].getBoundingClientRect().y,s<=0?s>a&&(a=s,e=n):s<o&&(o=s,t=n)})),r=o<80?t:e,void 0!==r){let e=this.scrollSpy.currentLocaltoc;r!==e&&(n.get(r)[0].classList.add("current"),void 0!==e&&n.get(e)[0].classList.remove("current"),this.scrollSpy.currentLocaltoc=r)}}}search(e){"IntlRo"!==e.code&&"Slash"!==e.code||this.$.searchArea.classList.contains("on")?"Escape"===e.code&&this.$.searchArea.classList.contains("on")&&(s.switchState(this.$.searchArea),s.switchState(this.$.searchAreaBg)):(s.switchState(this.$.searchArea),s.switchState(this.$.searchAreaBg),this.$.searchInput.focus(),this.$.searchInput.$.select())}related(e){if(!e.altKey||!e.shiftKey)return;e.preventDefault();let t=e.ctrlKey&&location.hash.length>0?location.hash:"";"ArrowLeft"!=e.code&&"KeyA"!=e.code||!this.$.relatedPrev?"ArrowRight"!=e.code&&"KeyD"!=e.code||!this.$.relatedNext||(location.href=this.$.relatedNext.href+t):location.href=this.$.relatedPrev.href+t}keyup(e){switch(e.code){case"ArrowLeft":case"ArrowRight":case"KeyA":case"KeyD":this.related(e);break;case"IntlRo":case"Slash":case"Escape":this.search(e)}}keydown(e){if(e.altKey&&e.shiftKey)switch(e.code){case"ArrowLeft":case"ArrowRight":case"KeyA":case"KeyD":e.preventDefault()}}os_theme(){return window.matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light"}scroll_save(){let e={};for(const[t,r]of Object.entries(this.$.preserve_scroll))e[t]=r.$.scrollTop;localStorage.setItem("scroll_position",JSON.stringify(e))}scroll_restore(e){let t=localStorage.getItem("scroll_position");if(t){t=JSON.parse(t);for(const[e,r]of Object.entries(t))e in this.$.preserve_scroll&&(this.$.preserve_scroll[e].$.scrollTop=r)}}init(){onresize=()=>{this.handleResize()},onscroll=()=>{this.handleScroll()},document.addEventListener("keyup",(e=>{this.keyup(e)}),!1),document.addEventListener("keydown",(e=>{this.keydown(e)}),!1),this.scroll_restore(),addEventListener("beforeunload",(e=>{this.scroll_save(e)}),!1)}}function n(){window.app={},new t(app),new o(app),new a(app)}return n(),n}));
//# sourceMappingURL=app.umd.js.map
