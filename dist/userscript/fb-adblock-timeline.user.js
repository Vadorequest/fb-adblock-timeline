/*
// ==UserScript==
// @name           Facebook AdBlock for your Timeline
// @namespace      http://tampermonkey.net/
// @version        1.0.1
// @description    Hide ads from Facebook on your timeline
// @author         Vadorequest
// @supportURL     https://github.com/Vadorequest/fb-adblock-timeline/issues
// @include        https://www.facebook.com/*
// @include        https://facebook.com/*
// @include        http://www.facebook.com/*
// @include        http://facebook.com/*
// @version 1.12
// ==/UserScript==
 */
var App,bind=function(t,e){return function(){return t.apply(e,arguments)}};App=function(){function t(){this.findParentClassLike=bind(this.findParentClassLike,this),this.run=bind(this.run,this),this.removeAds=bind(this.removeAds,this),this.find=bind(this.find,this),this.debug=!1,this.appName="Facebook AdBlock",this.debug&&console.log(this.appName+" - Starting"),this.delay=3e3,this.adClass="userContentWrapper",this.texts=["Suggested Post","Sponsored","Publication suggérée","Sponsorisé"],this.debug&&console.log(this.appName+" - Starting recursive search of ads"),this.run(!0)}return t.prototype.find=function(t){if(this.result=document.evaluate("//*[text()='"+t+"']",document,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE).snapshotItem(0),this.debug&&this.result)return console.log(this.appName+" - Found an ad for '"+t+"'")},t.prototype.removeAds=function(){var t;if(null!=this.result)return t=this.findParentClassLike(this.result),null!=t&&t.remove(),this.debug&&t&&console.log(this.appName+" - Ad deleted, looking for another",t),this.debug&&!t&&console.log(this.appName+" - Couldn't find the container of the ad"),this.run()},t.prototype.run=function(t){return null==t&&(t=!1),setTimeout(function(e){return function(){if(e.texts.map(function(t){return e.find(t),e.removeAds()}),t)return e.run(e.delay)}}(this),this.delay)},t.prototype.findParentClassLike=function(t){for(var e;t.parentNode;)if(t=t.parentNode,null!=(e=t.className)?e.startsWith(this.adClass):void 0)return t;return null},t}(),App=new App;