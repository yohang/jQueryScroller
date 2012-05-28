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
    # ```coffeescript
    #   hscroller = new window.fw.HorizontalScroller container, options
    # ```
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

            # Selectors
            scrollerSelector:      '[data-scroller=scroller]'
            contentSelector:       '[data-scroller=content]'
            innerContentSelector:  '[data-scroller=innercontent]'
            previousSelector:      '[data-scroller=previous]'
            nextSelector:          '[data-scroller=next]'

            # Default elements CSS styles
            scrollerStyles:
                position: 'relative'
                top:      0
                left:     0
            contentStyles:
                position: 'absolute'
                top:      0
                left:     0

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

        #
        #
        # Main slide method, performs the slide action, and cut boundaries
        slideTo: (pos) ->
            pos = @maxPos if pos > @maxPos
            pos = 0             if pos < 0
            @currentPos = pos
            @$content.stop().animate
                left: (-pos) + 'px'
            , @options.animateOptions


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
