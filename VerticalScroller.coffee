#
#
# Configurable HTML5 / jQuery Vertical scroller.
# Copyright 2012, Yohan Giarelli <yohan@frequence-web.fr>
# Licensed under MIT License
#
# Depends on: jQuery >= 1.7, jquery.mousewheel (optional)
# Code style inspirated by Twitter Bootstraps JS components
#
window.fw = {} if not window.fw?
(($) ->
    # VerticalScroller class
    # Use it with :
    #   hscroller = new window.fw.HorizontalScroller container, options
    #
    class window.fw.VerticalScroller extends window.fw.BaseScroller
        baseOptions =
            # Misc options
            scrollStep:            25
            draggerStyles:
                position:     'absolute'
                top:          0
                left:         0
                'max-height': '100%'
        #
        #
        # Class constructor, initialize options and dom
        constructor: (container, options = {}) ->
            super(container, $.extend({}, baseOptions, options))

            # Size (height) calcul
            @$content.height '999999px'
            @contentSize   = @$innerContent.height() + @options.offset
            @$content.height @contentSize
            @scrollerSize  = @$scroller.height()
            @maxPos        = @contentSize - @scrollerSize

            # Init the scrollbar if needed
            @initScrollbar() if @options.scrollbar

        #
        #
        # Constructs the scrollbar
        initScrollbar: ->
            super()

            @$dragger.css          $.extend {}, @options.draggerStyles,
                height: @scrollbarSize + '%'

            # Make the scrollbar draggable
            @$dragger.draggable
                axis:        'y'
                containment: @$draggerContainer
                drag: (event, ui) =>
                    @slideTo (ui.position.top / @$draggerContainer.height()) * @contentSize, false, false

            # Bind the slide event to update the scrollbar pos
            $(@).bind 'slide', =>
                @$dragger.stop().animate
                    top: (@currentPos / @contentSize) * 100 + '%'
                , @options.animateOptions

        #
        #
        # Main slide method, performs the slide action, and cut boundaries
        slideTo: (pos, triggerEvent = true, animate = true) ->
            super(pos, triggerEvent, animate)

            if animate
                @$content.stop().animate
                    top: (-@currentPos) + 'px'
                , @options.animateOptions
            else
                @$content.css
                    top: (-@currentPos) + 'px'

)(jQuery)
