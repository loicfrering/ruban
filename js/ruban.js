(function() {
  var Ruban,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Ruban = (function() {
    function Ruban(options) {
      this.options = options != null ? options : {};
      this.next = __bind(this.next, this);
      this.last = __bind(this.last, this);
      this.prev = __bind(this.prev, this);
      this.first = __bind(this.first, this);
      this.checkHash = __bind(this.checkHash, this);
      this.initOptions();
      this.$sections = $('section').wrapAll('<div class="ruban"></div>');
      this.$ruban = $('.ruban');
      this.toc();
      this.current(this.$sections.first());
      this.pagination();
      this.checkHash();
      this.highlight();
      this.resize();
      this.bind();
      this.$ruban.css('transition-property', 'transform');
      this.$ruban.css('-webkit-transition-property', '-webkit-transform');
      this.$ruban.css('transition-duration', this.options.transitionDuration);
    }

    Ruban.prototype.initOptions = function() {
      var _base, _base1, _base2, _base3, _base4, _base5, _base6, _base7;
      if ((_base = this.options).ratio == null) {
        _base.ratio = 4 / 3;
      }
      if ((_base1 = this.options).minPadding == null) {
        _base1.minPadding = '0.4em';
      }
      if ((_base2 = this.options).transitionDuration == null) {
        _base2.transitionDuration = '1s';
      }
      if ((_base3 = this.options).pagination == null) {
        _base3.pagination = false;
      }
      if ((_base4 = this.options).title == null) {
        _base4.title = null;
      }
      if ((_base5 = this.options).stripHtmlInToc == null) {
        _base5.stripHtmlInToc = false;
      }
      if ((_base6 = this.options).bindClicks == null) {
        _base6.bindClicks = false;
      }
      return (_base7 = this.options).bindMouseWheel != null ? (_base7 = this.options).bindMouseWheel : _base7.bindMouseWheel = false;
    };

    Ruban.prototype.bind = function() {
      this.bindKeys();
      this.bindGestures();
      if (this.options.bindClicks) {
        this.bindClicks();
      }
      if (this.options.bindMouseWheel) {
        this.bindMouseWheel();
      }
      this.bindResize();
      return this.bindHashChange();
    };

    Ruban.prototype.bindKeys = function() {
      key('right, down, space, return, j, l, pagedown', this.next);
      key('left, up, backspace, k, h, pageup', this.prev);
      key('home', this.first);
      return key('last', this.last);
    };

    Ruban.prototype.bindGestures = function() {
      return Hammer(document, {
        drag_block_vertical: true,
        drag_block_horizontal: true
      }).on('swipeleft swipeup', this.next).on('swiperight swipedown', this.prev);
    };

    Ruban.prototype.bindClicks = function() {
      var _this = this;
      this.$ruban.contextmenu(function() {
        return false;
      });
      return this.$ruban.mousedown(function(e) {
        switch (e.which) {
          case 1:
            return _this.next();
          case 3:
            return _this.prev();
        }
      });
    };

    Ruban.prototype.bindMouseWheel = function() {
      var _this = this;
      return this.$ruban.on('wheel', function(e) {
        if (e.originalEvent.deltaY > 0) {
          return _this.next();
        } else if (e.originalEvent.deltaY < 0) {
          return _this.prev();
        }
      });
    };

    Ruban.prototype.bindResize = function() {
      var _this = this;
      return $(window).resize(function() {
        _this.resize();
        return _this.go(_this.$current, {
          force: true
        });
      });
    };

    Ruban.prototype.bindHashChange = function() {
      return $(window).on('hashchange', this.checkHash);
    };

    Ruban.prototype.resize = function() {
      var height, min, outerHeight, outerWidth, paddingH, paddingV, width, _ref;
      _ref = [$(window).width(), $(window).height()], outerWidth = _ref[0], outerHeight = _ref[1];
      if (outerWidth > this.options.ratio * outerHeight) {
        min = outerHeight;
        paddingV = this.options.minPadding;
        this.$ruban.parent().css('font-size', "" + (min * 0.4) + "%");
        this.$sections.css({
          'padding-top': paddingV,
          'padding-bottom': paddingV
        });
        height = this.$current.height();
        width = this.options.ratio * height;
        paddingH = "" + ((outerWidth - width) / 2) + "px";
        return this.$sections.css({
          'padding-left': paddingH,
          'padding-right': paddingH
        });
      } else {
        min = outerWidth / this.options.ratio;
        paddingH = this.options.minPadding;
        this.$ruban.parent().css('font-size', "" + (min * 0.4) + "%");
        this.$sections.css({
          'padding-left': paddingH,
          'padding-right': paddingH
        });
        width = this.$current.width();
        height = width / this.options.ratio;
        paddingV = "" + ((outerHeight - height) / 2) + "px";
        return this.$sections.css({
          'padding-top': paddingV,
          'padding-bottom': paddingV
        });
      }
    };

    Ruban.prototype.checkHash = function() {
      var hash, slide;
      hash = window.location.hash;
      if (slide = hash.substr(2)) {
        return this.go(slide);
      }
    };

    Ruban.prototype.highlight = function() {
      return hljs.initHighlightingOnLoad();
    };

    Ruban.prototype.first = function() {
      return this.firstSlide();
    };

    Ruban.prototype.firstSlide = function() {
      var $first;
      $first = this.$current.prevAll('section:first-child');
      return this.go($first, {
        direction: 'backward'
      });
    };

    Ruban.prototype.prev = function() {
      if (this.hasSteps()) {
        return this.prevStep();
      } else {
        return this.prevSlide();
      }
    };

    Ruban.prototype.prevSlide = function() {
      var $prev;
      $prev = this.$current.prev('section');
      return this.go($prev, {
        direction: 'backward'
      });
    };

    Ruban.prototype.prevStep = function() {
      var $prev;
      this.$steps.eq(this.index).removeClass('step').fadeOut();
      $prev = this.$steps.eq(--this.index);
      if (!(this.index < -1)) {
        if ($prev.is(':visible')) {
          return $prev.addClass('step').trigger('step');
        } else if (this.index > -1) {
          return this.prevStep();
        }
      } else {
        return this.prevSlide();
      }
    };

    Ruban.prototype.last = function() {
      return this.lastSlide();
    };

    Ruban.prototype.lastSlide = function() {
      var $last;
      $last = this.$current.nextAll('section:last-child');
      return this.go($last, {
        direction: 'forward'
      });
    };

    Ruban.prototype.next = function() {
      if (this.hasSteps()) {
        return this.nextStep();
      } else {
        return this.nextSlide();
      }
    };

    Ruban.prototype.nextSlide = function() {
      var $next;
      $next = this.$current.next('section');
      return this.go($next, {
        direction: 'forward'
      });
    };

    Ruban.prototype.nextStep = function() {
      var $next;
      this.$steps.eq(this.index).removeClass('step');
      $next = this.$steps.eq(++this.index);
      if ($next.length) {
        return $next.fadeIn().addClass('step').trigger('step');
      } else {
        return this.nextSlide();
      }
    };

    Ruban.prototype.checkSteps = function($section, direction) {
      this.$steps = $section.find('.steps').children();
      if (!this.$steps.length) {
        this.$steps = $section.find('.step');
      }
      if (direction === 'backward') {
        return this.index = this.$steps.length - 1;
      } else {
        this.index = -1;
        return this.$steps.hide();
      }
    };

    Ruban.prototype.hasSteps = function() {
      return (this.$steps != null) && this.$steps.length !== 0;
    };

    Ruban.prototype.find = function(slide) {
      var $section;
      if (slide instanceof $) {
        return slide;
      } else {
        $section = $("#" + slide);
        if ($section.length === 0) {
          $section = this.$sections.eq(parseInt(slide) - 1);
        }
        return $section;
      }
    };

    Ruban.prototype.go = function(slide, options) {
      var $section;
      if (slide == null) {
        slide = 1;
      }
      if (options == null) {
        options = {};
      }
      $section = this.find(slide);
      if ($section.length && (options.force || !$section.is(this.$current))) {
        this.checkSteps($section, options.direction);
        this.navigate($section);
        this.translate($section);
        this.current($section);
        return this.pagination();
      }
    };

    Ruban.prototype.navigate = function($section) {
      return window.location.hash = "/" + ($section.attr('id') || $section.index() + 1);
    };

    Ruban.prototype.translate = function($section) {
      var y;
      y = $section.prevAll().map(function() {
        return $(this).outerHeight();
      }).get().reduce(function(memo, height) {
        return memo + height;
      }, 0);
      return this.$ruban.css('transform', "translateY(-" + y + "px)");
    };

    Ruban.prototype.current = function($section) {
      if (this.$current != null) {
        this.$current.removeClass('active').trigger('inactive');
      }
      $section.addClass('active').trigger('active');
      return this.$current = $section;
    };

    Ruban.prototype.pagination = function() {
      this.paginationText = [];
      if (this.options.title) {
        this.paginationText.push(this.options.title);
      }
      if (this.options.pagination || this.options.title) {
        if (!this.$pagination) {
          this.$ruban.parent().append('<footer class="pagination"></footer>');
          this.$pagination = $('.pagination');
          this.total = this.$sections.length;
        }
        if (this.options.pagination) {
          this.paginationText.push("" + (this.$current.index() + 1) + "/" + this.total);
        }
        return this.$pagination.html(this.paginationText.join(' - '));
      }
    };

    Ruban.prototype.toc = function() {
      var $toc, $ul, stripHtmlInToc;
      $toc = $('.toc').first();
      if ($toc.length) {
        stripHtmlInToc = this.options.stripHtmlInToc;
        $ul = $('<ul/>');
        $('section:not(.no-toc,.toc) > h1:only-child').each(function() {
          var $h1, $section, html, title;
          $section = $(this).parent();
          if (stripHtmlInToc) {
            title = html = $(this).text();
          } else {
            $h1 = $(this).clone().find('a').replaceWith(function() {
              return $(this).text();
            }).end();
            title = $h1.text();
            html = $h1.html();
          }
          return $('<li/>').append($('<a/>', {
            href: "#/" + ($section.attr('id') || $section.index() + 1),
            title: title,
            html: html
          })).appendTo($ul);
        });
        return $toc.append($ul);
      }
    };

    return Ruban;

  })();

  window.Ruban = Ruban;

}).call(this);
