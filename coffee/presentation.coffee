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
    [width, height] = [$(window).width(), $(window).height()]
    if width > height
      min = height
      paddingV = '20px'
      paddingH = "#{(width - 1.3*height)/2}px"
    else
      min = width
      paddingH = '20px'
      paddingV = "#{(height - width/1.3)/2}px"

    $('section').css(
      'font-size': "#{min * 0.4}%"
      'padding':   "#{paddingV} #{paddingH}"
    )

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
