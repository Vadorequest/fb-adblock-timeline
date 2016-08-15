###
// ==UserScript==
// @name           Facebook AdBlock for your Timeline
// @namespace      http://tampermonkey.net/
// @version        1.0.0
// @description    Hide ads from Facebook on your timeline
// @author         Vadorequest
// @supportURL     https://github.com/Vadorequest/fb-adblock-timeline/issues
// @include        https://www.facebook.com/*
// @include        https://facebook.com/*
// @include        http://www.facebook.com/*
// @include        http://facebook.com/*
// @version 1.12
// ==/UserScript==
###

class App

    constructor: ->
        @debug = false # Display logs.
        @appName = "Facebook AdBlock" # Used in logs.
        console.log "#{@appName} - Starting" if @debug

        @delay = 3000 # Delay between two attempts to delete a fracking ad.
        @adClass = 'userContentWrapper' # Class used by facebook to identify a <div> container. Used as a way to check we are deleting the right thing.

        # Texts to look for. Currently, there are only 2 different texts used by facebook.
        # TODO Handle I18n. Or just put a big array with all possibilities. (may be complicated to check the user language settings?)
        @texts = [
            # EN
            'Suggested Post'
            'Sponsored'

            # FR
            'Publication suggérée'
            'Sponsorisé'
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

            # TODO Do something smart about this. It basically means we haven't found a proper container. Many possible reasons:
            # 1. FB has changed the container class name (most likely)
            # 2. There must be more reasons for this to fail, haven't found them yet!
            console.log "#{@appName} - Couldn't find the container of the ad" if @debug and not container

            # Look for another one right away in case of there would be several at once (ie: fast scroll).
            @run()

    # Main program. For each text, tries to find a result. If so, deletes it. Additionally run recursively.
    run: (recursive = false) =>
        setTimeout =>
            @texts.map (text) =>
                @find(text)
                @removeAds()

            # Make it recursive.
            @run(@delay) if recursive
        , @delay

    # Try to find a parent <div> containing the class we're looking for. (In order to identify the ad container)
    findParentClassLike: (el) =>
        while el.parentNode
            el = el.parentNode
            if el.className?.startsWith @adClass
                return el
        null

# TRACK AND KILL THEM ALL!
App = new App()
