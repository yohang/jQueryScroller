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
    class window.fw.HorizontalScroller extends window.fw.BaseScroller
        baseOptions =
            # Misc options
            scrollStep:            25
            draggerStyles:
                position:     'absolute'
                top:          0
                left:         0
                'max-width':  '100%'
        #
        #
        # Class constructor, initialize options and dom
        constructor: (container, options = {}) ->
            super(container, $.extend({}, baseOptions, options))

            # Size (width) calcul
            @$content.width '999999px'
            @contentSize   = @$innerContent.width() + @options.offset
            @$content.width @contentSize
            @scrollerSize  = @$scroller.width()
            @maxPos        = @contentSize - @scrollerSize

            # Init the scrollbar if needed
            @initScrollbar() if @options.scrollbar

        #
        #
        # Constructs the scrollbar
        initScrollbar: ->
            super()

            @$dragger.css          $.extend {}, @options.draggerStyles,
                width: @scrollbarSize + '%'

            # Make the scrollbar draggable
            @$dragger.draggable
                axis:        'x'
                containment: @$draggerContainer
                drag: (event, ui) =>
                    @slideTo (ui.position.left / @$draggerContainer.width()) * @contentSize, false, false

            # Bind the slide event to update the scrollbar pos
            $(@).bind 'slide', =>
                @$dragger.stop().animate
                    left: (@currentPos / @contentSize) * 100 + '%'
                , @options.animateOptions

        #
        #
        # Main slide method, performs the slide action, and cut boundaries
        slideTo: (pos, triggerEvent = true, animate = true) ->
            super(pos, triggerEvent, animate)

            if animate
                @$content.stop().animate
                    left: (-@currentPos) + 'px'
                , @options.animateOptions
            else
                @$content.css
                    left: (-@currentPos) + 'px'

)(jQuery)
