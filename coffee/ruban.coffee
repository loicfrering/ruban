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
    @options.title              ?= null
    @options.stripHtmlInToc     ?= false
    @options.bindClicks         ?= false
    @options.bindMouseWheel     ?= false

  bind: ->
    @bindKeys()
    @bindGestures()
    @bindClicks() if @options.bindClicks
    @bindMouseWheel() if @options.bindMouseWheel

    @bindResize()
    @bindHashChange()

  bindKeys: ->
    key('right, down, space, return, j, l, pagedown', @next)
    key('left, up, backspace, k, h, pageup', @prev)
    key('home', @first)
    key('last', @last)

  bindGestures: ->
    Hammer(document, {
      drag_block_vertical:   true,
      drag_block_horizontal: true
    }).on('swipeleft swipeup', @next)
      .on('swiperight swipedown', @prev)

  bindClicks: ->
    @$ruban.contextmenu(-> false)
    @$ruban.mousedown((e) =>
      switch e.which
        when 1 then @next()
        when 3 then @prev()
    )

  bindMouseWheel: ->
    @$ruban.on('wheel', (e) =>
      if e.originalEvent.deltaY > 0
        @next()
      else if e.originalEvent.deltaY < 0
        @prev()
    )

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

  first: =>
    @firstSlide()

  firstSlide: ->
    $first = @$current.prevAll('section:first-child')
    @go($first, direction: 'backward')

  prev: =>
    if @hasSteps()
      @prevStep()
    else
      @prevSlide()

  prevSlide: ->
    $prev = @$current.prev('section')
    @go($prev, direction: 'backward')

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

  last: =>
    @lastSlide()

  lastSlide: ->
    $last = @$current.nextAll('section:last-child')
    @go($last, direction: 'forward')

  next: =>
    if @hasSteps()
      @nextStep()
    else
      @nextSlide()

  nextSlide: ->
    $next = @$current.next('section')
    @go($next, direction: 'forward')

  nextStep: ->
    @$steps.eq(@index).removeClass('step')
    $next = @$steps.eq(++@index)
    if $next.length
      $next.fadeIn().addClass('step').trigger('step')
    else
      @nextSlide()

  checkSteps: ($section, direction) ->
    @$steps = $section.find('.steps').children()
    unless @$steps.length
      @$steps = $section.find('.step')

    if direction is 'backward'
      @index = @$steps.length - 1
    else
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
      @checkSteps($section, options.direction)
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
    @paginationText = []
    @paginationText.push @options.title if @options.title
    if @options.pagination or @options.title
      unless @$pagination
        @$ruban.parent().append('<footer class="pagination"></footer>')
        @$pagination = $('.pagination')
        @total = @$sections.length
      if @options.pagination
        @paginationText.push("#{@$current.index() + 1}/#{@total}")
      @$pagination.html(@paginationText.join(' - '))

  toc: ->
    $toc = $('.toc').first()
    if $toc.length
      stripHtmlInToc = @options.stripHtmlInToc
      $ul = $('<ul/>')

      $('section:not(.no-toc,.toc) > h1:only-child').each(->
        $section = $(this).parent()

        if stripHtmlInToc
          title = html = $(this).text()
        else
          $h1 = $(this).clone()
                       .find('a')
                         .replaceWith(-> $(this).text())
                         .end()
          title = $h1.text()
          html  = $h1.html()

        $('<li/>').append($('<a/>',
          href:  "#/#{$section.attr('id') || $section.index() + 1}"
          title: title
          html:  html
        )).appendTo($ul);
      )
      $toc.append($ul)


window.Ruban = Ruban
