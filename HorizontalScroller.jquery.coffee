#
#
# Configurable HTML5 / jQuery Horizontal scroller.
# Copyright 2012, Yohan Giarelli <yohan@frequence-web.fr>
# Licensed under MIT License
#
# Depends on: jQuery >= 1.7, jquery.mousewheel (optional)
# Code style inspirated by Twitter Bootstraps JS components
#
window.fw = {} if not window.fw?
(($) ->
    # HorizontalScroller class
    # Use it with :
    #   hscroller = new window.fw.HorizontalScroller container, options
    #
    # Properties :
    #   `options`       : Merged options, default values in `baseOptions`
    #   `$container`    : Global scroller container
    #   `$scroller`     : Direct container of the scrolled content
    #   `$content`      : The scrolled container
    #   `$innerContent` : Container inside scrolled container. Used to guess total to-scroll-width
    #   `contentWidth`  : To-scroll-width
    #   `scrollerWidth` : scroll view width
    #   `maxPos`        : Max scroll offset (contentWidth - scrollerWidth)
    class window.fw.HorizontalScroller
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
                position: 'absolute'
                top:         0
                left:        0
                'max-width': '100%'

            # Animation options
            animateOptions:
                duration: 500



        #
        #
        # Class constructor, initialize options and dom
        constructor: (container, options = {}) ->
            # Options overriding
            @options        = $.extend {}, baseOptions, options

            # DOM retrieving
            @$container    = $ container
            @$scroller     = @$container.find @options.scrollerSelector
            @$content      = @$scroller.find  @options.contentSelector
            @$innerContent = @$content.find   @options.innerContentSelector

            # Size (width) calcul
            @currentPos = 0
            @$content.width '999999px'
            @contentWidth  = @$innerContent.width() + @options.offset
            @$content.width @contentWidth
            @scrollerWidth = @$scroller.width()
            @maxPos        = @contentWidth - @scrollerWidth

            # Styles setting
            @$scroller.css @options.scrollerStyles
            @$content.css  @options.contentStyles

            # Init events
            @$container.delegate @options.previousSelector, 'click', @previous.bind @, 1
            @$container.delegate @options.nextSelector,     'click', @next.bind @, 1
            @$container.bind    'mousewheel', @onMousewheel.bind @ if @options.mousewheel

            @initScrollbar() if @options.scrollbar

        #
        #
        # Constructs the scrollbar
        initScrollbar: ->
            # Retrieve DOM objects
            @$draggerContainer = @$container.find        @options.draggerContainerSelector
            @$dragger          = @$draggerContainer.find @options.draggerSelector

            # Set styles
            @scrollbarWidth = Math.round((@scrollerWidth / @contentWidth) * 100)
            @$draggerContainer.css @options.draggerContainerStyles
            @$dragger.css          $.extend {}, @options.draggerStyles,
                width: @scrollbarWidth + '%'

            # Make the scrollbar draggable
            @$dragger.draggable
                axis:        'x'
                containment: @$draggerContainer
                drag: (event, ui) =>
                    @slideTo (ui.position.left / @$draggerContainer.width()) * @contentWidth, false, false

            # Bind the slide event to update the scrollbar pos
            $(@).bind 'slide', =>
                @$dragger.stop().animate
                    left: (@currentPos / @contentWidth) * 100 + '%'
                , @options.animateOptions



        #
        #
        # Main slide method, performs the slide action, and cut boundaries
        slideTo: (pos, triggerEvent = true, animate = true) ->
            pos = @maxPos if pos > @maxPos
            pos = 0             if pos < 0
            @currentPos = pos

            if animate
                @$content.stop().animate
                    left: (-pos) + 'px'
                , @options.animateOptions
            else
                @$content.css
                    left: (-pos) + 'px'

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





    #
    #
    # jQuery Plugin
    $.fn.horizontalScroller = (option) ->
        args = arguments
        @each ->
            $this = $ @
            data  = $this.data 'fw.scroller'

            # Instantiation
            if not data?
                $this.data 'fw.scroller', data = new window.fw.HorizontalScroller $this, option

            # Method call
            if data and typeof option is 'string' and typeof data[option] is 'function'
                data[option].apply data, [].slice.call args, 1
)(jQuery)
