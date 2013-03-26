class Presentation
  constructor: ->
    @$presentation = $('.presentation')
    @$current      = $('section').first()
    @y             = 0

    @$presentation.css('transition-duration', '1s')
    @bind()
    @resize()
    @checkHash()
    @highlight()

  bind: ->
    @bindKeys()
    @bindGestures()
    @bindResize()
    @bindHashChange()

  bindKeys: ->
    key('right, down, space, return, j, l', @next)
    key('left, up, backspace, k, h', @prev)

  bindGestures: ->
    Hammer(document).on('swipeleft swipeup', @next)
    Hammer(document).on('swiperight swipedown', @prev)

  bindResize: ->
    $(window).resize(=>
      @resize()
      @checkHash()
    )

  bindHashChange: ->
    $(window).on('hashchange', @checkHash)

  resize: ->
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

  checkHash: =>
    hash = window.location.hash
    slide = hash.substr(2)
    @go(slide) if slide

  highlight: ->
    hljs.initHighlightingOnLoad()

  prev: =>
    if @hasSteps()
      @prevStep()
    else
      @prevSlide()

  prevSlide: ->
    $prev = @$current.prev('section')
    @go($prev)

  prevStep: ->
    @$steps.eq(@index).removeClass('step').fadeOut()
    $prev = @$steps.eq(--@index)
    unless @index < -1
      if $prev.is(':visible')
        $prev.addClass('step').trigger('step')
      else if @index > -1
        @prevStep()
    else
      @prevSlide()

  next: =>
    if @hasSteps()
      @nextStep()
    else
      @nextSlide()

  nextSlide: ->
    $next = @$current.next('section')
    @go($next)

  nextStep: ->
    @$steps.eq(@index).removeClass('step')
    $next = @$steps.eq(++@index)
    if $next.length
      $next.fadeIn().addClass('step').trigger('step')
    else
      @nextSlide()

  checkSteps: ($section) ->
    @$steps = $section.find('.steps').children()
    unless @$steps.length
      @$steps = $section.find('.step')

    @index = -1
    @$steps.hide()

  hasSteps: ->
    @$steps? and @$steps.length isnt 0

  find: (slide) ->
    if slide instanceof $
      slide
    else
      $section = $("##{slide}")
      if $section.length is 0
        $section = $('section').eq(parseInt(slide) - 1)
      $section

  go: (slide = 1) ->
    $section = @find(slide)

    if $section.length
      @checkSteps($section)
      window.location.hash = "/#{$section.attr('id') || $section.index() + 1}"
      y = $section.prevAll().map(->
        $(@).outerHeight()
      ).get().reduce((memo, height) ->
        memo + height
      , 0)
      $('.presentation').css('transform', "translateY(-#{y}px)")

      @$current.removeClass('current')
      $section.addClass('current').trigger('current')
      @$current = $section


window.Presentation = Presentation
