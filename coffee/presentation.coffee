class Presentation
  constructor: ->
    @$presentation = $('.presentation')
    @$current      = $('section').first()
    @y             = 0

    @$presentation.css('transition-duration', '1s')
    @bind()
    @resize()

  bind: ->
    @bindKeys()
    @bindGestures()
    @bindResize()

  bindKeys: ->
    key('right, down, space, return', @next)
    key('left, up, backspace', @prev)

  bindGestures: ->
    Hammer(document).on('swipeleft swipeup', @next)
    Hammer(document).on('swiperight swipedown', @prev)

  bindResize: ->
    $(window).resize(@resize)

  resize: =>
    min = Math.min($(window).width(), $(window).height())
    $('section').css('font-size', "#{min * 0.4}%")

  prev: =>
    $prev = @$current.prev('section')
    if $prev.length
      @y -= $prev.outerHeight()
      $('.presentation').css('transform', "translateY(-#{@y}px)")
      @$current = $prev

  next: =>
    $next = @$current.next('section')
    if $next.length
      @y += @$current.outerHeight()
      $('.presentation').css('transform', "translateY(-#{@y}px)")
      @$current = $next

presentation = new Presentation()
