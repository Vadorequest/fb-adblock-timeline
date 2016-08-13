###
// ==UserScript==

// @name           Facebook AdBlock - Sponsored
// @namespace      http://tampermonkey.net/
// @version        0.0.1
// @description    Hide sponsored content on your Facebook's timeline
// @author         Vadorequest
// @include        https://www.facebook.com/*
// @include        https://facebook.com/*
// @include        http://www.facebook.com/*
// @include        http://facebook.com/*
// @version 1.12
// ==/UserScript==
###

class App

  constructor: () ->
    @debug = true
    @appName = "Facebook AdBlock"
    console.log "#{@appName} - Starting" if @debug

    @delay = 3000
    @adClass = 'userContentWrapper'
    @texts = [
      'Suggested Post'
      'Sponsored'
    ]

    # Run recursively.
    console.log "#{@appName} - Starting recursive search of ads" if @debug
    @run(true)

  find: (text) =>
    @result = document.evaluate(
        "//*[text()='#{text}']"
        document
        null
        XPathResult.ORDERED_NODE_SNAPSHOT_TYPE
    ).snapshotItem(0)

    console.log "#{@appName} - Found an ad for '#{text}'" if @debug and @result

  removeAds: =>
    if @result?
      # Get the container and deletes it.
      # XXX This depends upon the css class facebook relies on and may change in the future.
      container = @findParentClassLike(@result)
      container.remove() if container?
      console.log "#{@appName} - Ad deleted, looking for another", container if @debug and container
      console.log "#{@appName} - Couldn't find the container of the ad" if @debug and not container

      # Look for another one right away in case of there would be several at once (ie: fast scroll).
      @run()

  run: (recursive = false) =>
    setTimeout =>
      @texts.map (text) =>
        @find(text)
        @removeAds()

      # Make it recursive.
      @run(@delay) if recursive
    , @delay

  findParentClassLike: (el) =>
    while el.parentNode
      el = el.parentNode
      if el.className?.startsWith @adClass
        return el
    null

App = new App()
