class Ruban
  constructor: (@options = {}) ->
    @initOptions()
    @$sections = $('section').wrapAll('<div class="ruban"></div>')
    @$ruban    = $('.ruban')

    @toc()
    @current(@$sections.first())
    @pagination()
    @checkHash()
    @highlight()
    @resize()
    @bind()
    @$ruban.css('transition-property', 'transform')
    @$ruban.css('-webkit-transition-property', '-webkit-transform')
    @$ruban.css('transition-duration', @options.transitionDuration)

  initOptions: () ->
    @options.ratio              ?= 4/3
    @options.minPadding         ?= '0.4em'
    @options.transitionDuration ?= '1s'
    @options.pagination         ?= false

  bind: ->
    @bindKeys()
    @bindGestures()
    @bindResize()
    @bindHashChange()

  bindKeys: ->
    key('right, down, space, return, j, l', @next)
    key('left, up, backspace, k, h', @prev)

  bindGestures: ->
    Hammer(document, {
      drag_block_vertical:   true,
      drag_block_horizontal: true
    }).on('swipeleft swipeup', @next)
      .on('swiperight swipedown', @prev)

  bindResize: ->
    $(window).resize(=>
      @resize()
      @go(@$current, force: true)
    )

  bindHashChange: ->
    $(window).on('hashchange', @checkHash)

  resize: ->
    [outerWidth, outerHeight] = [$(window).width(), $(window).height()]
    if outerWidth > @options.ratio * outerHeight
      min = outerHeight
      paddingV = @options.minPadding
      @$ruban.parent().css('font-size', "#{min * 0.4}%")
      @$sections.css(
        'padding-top':    paddingV,
        'padding-bottom': paddingV
      )
      height = @$current.height()
      width = @options.ratio * height
      paddingH = "#{(outerWidth - width)/2}px"
      @$sections.css(
        'padding-left':  paddingH
        'padding-right': paddingH
      )
    else
      min = outerWidth / @options.ratio
      paddingH = @options.minPadding
      @$ruban.parent().css('font-size', "#{min * 0.4}%")
      @$sections.css(
        'padding-left':  paddingH,
        'padding-right': paddingH
      )
      width = @$current.width()
      height = width / @options.ratio
      paddingV = "#{(outerHeight - height)/2}px"
      @$sections.css(
        'padding-top':    paddingV,
        'padding-bottom': paddingV
      )

  checkHash: =>
    hash = window.location.hash
    if slide = hash.substr(2)
      @go(slide)

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
        $section = @$sections.eq(parseInt(slide) - 1)
      $section

  go: (slide = 1, options = {}) ->
    $section = @find(slide)

    if $section.length and (options.force or not $section.is(@$current))
      @checkSteps($section)
      @navigate($section)
      @translate($section)
      @current($section)
      @pagination()

  navigate: ($section) ->
    window.location.hash = "/#{$section.attr('id') || $section.index() + 1}"

  translate: ($section) ->
    y = $section.prevAll().map(->
      $(@).outerHeight()
    ).get().reduce((memo, height) ->
      memo + height
    , 0)
    @$ruban.css('transform', "translateY(-#{y}px)")


  current: ($section) ->
    @$current.removeClass('active').trigger('inactive') if @$current?
    $section.addClass('active').trigger('active')
    @$current = $section

  pagination: ->
    if @options.pagination
      unless @$pagination
        @$ruban.parent().append('<footer class="pagination"></footer>')
        @$pagination = $('.pagination')
        @total = @$sections.length

      @$pagination.html("#{@$current.index() + 1}/#{@total}")

  toc: ->
    $toc = $('.toc').first()
    if $toc.length
      $ul = $('<ul/>')
      $('section:not(.no-toc,.toc) > h1:only-child').each(->
        $section = $(this).parent()
        title = $(this).text()
        $ul.append($('<li/>'))
           .append($('<a/>',
             href:  "#/#{$section.attr('id') || $section.index() + 1}"
             title: title
             text:  title
           ))
      )
      $toc.append($ul)


window.Ruban = Ruban
