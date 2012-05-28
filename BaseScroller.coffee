#
#
# Configurable HTML5 / jQuery scroller.
# Base scroller class
# Copyright 2012, Yohan Giarelli <yohan@frequence-web.fr>
# Licensed under MIT License
#
# Depends on: jQuery >= 1.7, jquery.mousewheel (optional)
# Code style inspirated by Twitter Bootstraps JS components
#
window.fw = {} if not window.fw?
(($) ->
    # BaseScroller class
    # Don't use it
    class window.fw.BaseScroller
    #
    #
    # Options default values
        baseOptions =
        # Misc options
            scrollStep:            150
            offset:                0
            mousewheel:            true
            scrollbar:             true

            # Selectors
            scrollerSelector:         '[data-scroller=scroller]'
            contentSelector:          '[data-scroller=content]'
            innerContentSelector:     '[data-scroller=innercontent]'
            previousSelector:         '[data-scroller=previous]'
            nextSelector:             '[data-scroller=next]'
            draggerContainerSelector: '[data-scroller=dragger-container]'
            draggerSelector:          '[data-scroller=dragger]'

            # Default elements CSS styles
            scrollerStyles:
                position: 'relative'
                top:      0
                left:     0
                overflow: 'hidden'
            contentStyles:
                position: 'absolute'
                top:      0
                left:     0
            draggerContainerStyles:
                position: 'relative'
                top:      0
                left:     0
            draggerStyles:
                position:     'absolute'
                top:          0
                left:         0
                'max-width':  '100%'
                'max-height': '100%'

            # Animation options
            animateOptions:
                duration: 500



        #
        #
        # Class constructor, initialize options and dom
        constructor: (container, options = {}) ->
            # Options overriding
            @options    = $.extend {}, baseOptions, options
            @currentPos = 0

            # DOM retrieving
            @$container    = $ container
            @$scroller     = @$container.find @options.scrollerSelector
            @$content      = @$scroller.find  @options.contentSelector
            @$innerContent = @$content.find   @options.innerContentSelector

            # Styles setting
            @$scroller.css @options.scrollerStyles
            @$content.css  @options.contentStyles

            # Init events
            @$container.delegate @options.previousSelector, 'click', @previous.bind @, 1
            @$container.delegate @options.nextSelector,     'click', @next.bind @, 1
            @$container.bind    'mousewheel', @onMousewheel.bind @ if @options.mousewheel


        #
        #
        # Constructs the scrollbar
        initScrollbar: ->
            # Retrieve DOM objects
            @$draggerContainer = @$container.find        @options.draggerContainerSelector
            @$dragger          = @$draggerContainer.find @options.draggerSelector

            # Set styles
            @scrollbarSize = Math.round((@scrollerSize / @contentSize) * 100)
            @$draggerContainer.css @options.draggerContainerStyles

        #
        #
        # Main slide method, performs the slide action, and cut boundaries
        slideTo: (pos, triggerEvent = true, animate = true) ->
            pos = @maxPos if pos > @maxPos
            pos = 0       if pos < 0
            @currentPos = pos

            # Trigger a slide event
            $(@).trigger 'slide' if triggerEvent

        #
        #
        # Go to next scroll offset(s)
        next: (offset = 1) ->
            @slideTo @currentPos + @options.scrollStep * offset

        #
        #
        # Go to previous scroll offset(s)
        previous: (offset = 1)  ->
            @slideTo @currentPos - @options.scrollStep * offset

        #
        #
        # Listener to the mousewheel event
        onMousewheel: (event, delta) ->
            # Call the `previous` or `next` method, depending of the `delta` sign.
            @[if delta < 0 then 'previous' else 'next'] Math.abs delta
            false


)(jQuery)
