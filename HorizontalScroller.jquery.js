// Generated by CoffeeScript 1.3.3
(function() {

  if (!(window.fw != null)) {
    window.fw = {};
  }

  (function($) {
    window.fw.HorizontalScroller = (function() {
      var baseOptions;

      baseOptions = {
        scrollStep: 150,
        offset: 0,
        mousewheel: true,
        scrollerSelector: '[data-scroller=scroller]',
        contentSelector: '[data-scroller=content]',
        innerContentSelector: '[data-scroller=innercontent]',
        previousSelector: '[data-scroller=previous]',
        nextSelector: '[data-scroller=next]',
        scrollerStyles: {
          position: 'relative',
          top: 0,
          left: 0
        },
        contentStyles: {
          position: 'absolute',
          top: 0,
          left: 0
        },
        animateOptions: {
          duration: 500
        }
      };

      function HorizontalScroller(container, options) {
        if (options == null) {
          options = {};
        }
        this.options = $.extend({}, baseOptions, options);
        this.$container = $(container);
        this.$scroller = this.$container.find(this.options.scrollerSelector);
        this.$content = this.$scroller.find(this.options.contentSelector);
        this.$innerContent = this.$content.find(this.options.innerContentSelector);
        this.currentPos = 0;
        this.$content.width('999999px');
        this.contentWidth = this.$innerContent.width() + this.options.offset;
        this.$content.width(this.contentWidth);
        this.scrollerWidth = this.$scroller.width();
        this.maxPos = this.contentWidth - this.scrollerWidth;
        this.$scroller.css(this.options.scrollerStyles);
        this.$content.css(this.options.contentStyles);
        this.$container.delegate(this.options.previousSelector, 'click', this.previous.bind(this, 1));
        this.$container.delegate(this.options.nextSelector, 'click', this.next.bind(this, 1));
        if (this.options.mousewheel) {
          this.$container.bind('mousewheel', this.onMousewheel.bind(this));
        }
      }

      HorizontalScroller.prototype.slideTo = function(pos) {
        if (pos > this.maxPos) {
          pos = this.maxPos;
        }
        if (pos < 0) {
          pos = 0;
        }
        this.currentPos = pos;
        return this.$content.stop().animate({
          left: (-pos) + 'px'
        }, this.options.animateOptions);
      };

      HorizontalScroller.prototype.next = function(offset) {
        if (offset == null) {
          offset = 1;
        }
        return this.slideTo(this.currentPos + this.options.scrollStep * offset);
      };

      HorizontalScroller.prototype.previous = function(offset) {
        if (offset == null) {
          offset = 1;
        }
        return this.slideTo(this.currentPos - this.options.scrollStep * offset);
      };

      HorizontalScroller.prototype.onMousewheel = function(event, delta) {
        this[delta < 0 ? 'previous' : 'next'](Math.abs(delta));
        return false;
      };

      return HorizontalScroller;

    })();
    return $.fn.horizontalScroller = function(option) {
      var args;
      args = arguments;
      return this.each(function() {
        var $this, data;
        $this = $(this);
        data = $this.data('fw.scroller');
        if (!(data != null)) {
          $this.data('fw.scroller', data = new window.fw.HorizontalScroller($this, option));
        }
        if (data && typeof option === 'string' && typeof data[option] === 'function') {
          return data[option].apply(data, [].slice.call(args, 1));
        }
      });
    };
  })(jQuery);

}).call(this);