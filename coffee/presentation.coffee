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
    @go($prev)

  next: =>
    $next = @$current.next('section')
    @go($next)

  go: (slide = 1) ->
    $section = if (slide instanceof $) then slide else $("##{slide}")
    if $section.length is 0
      $section = $('section').slice(parseInt(slide) - 1).first()

    if $section.length
      y = $section.prevAll().map(->
        $(@).outerHeight()
      ).get().reduce((memo, height) ->
        memo + height
      , 0)
      $('.presentation').css('transform', "translateY(-#{y}px)")
      @$current = $section

window.presentation = new Presentation()
