
/*
// ==UserScript==
// @name           Facebook AdBlock for your Timeline
// @namespace      http://tampermonkey.net/
// @version        1.0.0
// @description    Hide ads from Facebook on your timeline
// @author         Vadorequest
// @include        https://www.facebook.com/*
// @include        https://facebook.com/*
// @include        http://www.facebook.com/*
// @include        http://facebook.com/*
// @version 1.12
// ==/UserScript==
 */
var App,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

App = (function() {
  function App() {
    this.findParentClassLike = bind(this.findParentClassLike, this);
    this.run = bind(this.run, this);
    this.removeAds = bind(this.removeAds, this);
    this.find = bind(this.find, this);
    this.debug = false;
    this.appName = "Facebook AdBlock";
    if (this.debug) {
      console.log(this.appName + " - Starting");
    }
    this.delay = 3000;
    this.adClass = 'userContentWrapper';
    this.texts = ['Suggested Post', 'Sponsored', 'Publication suggérée', 'Sponsorisé'];
    if (this.debug) {
      console.log(this.appName + " - Starting recursive search of ads");
    }
    this.run(true);
  }

  App.prototype.find = function(text) {
    this.result = document.evaluate("//*[text()='" + text + "']", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE).snapshotItem(0);
    if (this.debug && this.result) {
      return console.log(this.appName + " - Found an ad for '" + text + "'");
    }
  };

  App.prototype.removeAds = function() {
    var container;
    if (this.result != null) {
      container = this.findParentClassLike(this.result);
      if (container != null) {
        container.remove();
      }
      if (this.debug && container) {
        console.log(this.appName + " - Ad deleted, looking for another", container);
      }
      if (this.debug && !container) {
        console.log(this.appName + " - Couldn't find the container of the ad");
      }
      return this.run();
    }
  };

  App.prototype.run = function(recursive) {
    if (recursive == null) {
      recursive = false;
    }
    return setTimeout((function(_this) {
      return function() {
        _this.texts.map(function(text) {
          _this.find(text);
          return _this.removeAds();
        });
        if (recursive) {
          return _this.run(_this.delay);
        }
      };
    })(this), this.delay);
  };

  App.prototype.findParentClassLike = function(el) {
    var ref;
    while (el.parentNode) {
      el = el.parentNode;
      if ((ref = el.className) != null ? ref.startsWith(this.adClass) : void 0) {
        return el;
      }
    }
    return null;
  };

  return App;

})();

App = new App();
