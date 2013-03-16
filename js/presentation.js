(function() {

  var factor = 0.4;

  var $window = $(window);

  var Presentation = function() {
    this.$presentation = $('.presentation');
    this.$current      = $('section').first();
    this.y             = 0;

    this.$presentation.css('transition-duration', '1s');
    this.bind();
    this.resize();
  };

  Presentation.prototype.bind = function() {
    this.bindKeys();
    this.bindResize();
  };

  Presentation.prototype.bindKeys = function() {
    key('right, down, space, return', this.next.bind(this));
    key('left, up, backspace', this.prev.bind(this));
  };

  Presentation.prototype.bindResize = function() {
    $window.resize(this.resize);
  };

  Presentation.prototype.resize = function() {
    var min    = Math.min($window.width(), $window.height());
    $('section').css('font-size', (min * factor) + '%');
  };

  Presentation.prototype.prev = function() {
    $prev = this.$current.prev('section');
    if ($prev.length) {
      this.y = this.y - $prev.outerHeight();
      $('.presentation').css('transform', 'translateY(-' + this.y + 'px)');
      this.$current = $prev;
    }
  };

  Presentation.prototype.next = function() {
    $next = this.$current.next('section');
    if ($next.length) {
      this.y = this.y + this.$current.outerHeight();
      $('.presentation').css('transform', 'translateY(-' + this.y + 'px)');
      this.$current = $next;
    }
  };

  var presentation = new Presentation();

})();
