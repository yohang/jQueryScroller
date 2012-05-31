# Hacky polyfill for IE
if not Function::bind?
    Function::bind = (context, boundArgs...) ->
        (args...) =>
            Array::push.apply boundArgs, args
            @apply context, boundArgs
(($) ->
    #
    #
    # jQuery Plugin
    $.fn.scroller = (option) ->
        args = arguments
        @each ->
            $this = $ @
            data  = $this.data 'fw.scroller'

            # Instantiation
            if not data?
                if $this.attr('data-scroller') is 'horizontal' or (option? and option.horizontal? and option.horizontal)
                    $this.data 'fw.scroller', data = new window.fw.HorizontalScroller $this, option
                else
                    $this.data 'fw.scroller', data = new window.fw.VerticalScroller $this, option

            # Method call
            if data and typeof option is 'string' and typeof data[option] is 'function'
                data[option].apply data, [].slice.call args, 1

)(jQuery)
