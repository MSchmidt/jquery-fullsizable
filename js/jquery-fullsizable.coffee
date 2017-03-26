###
jQuery fullsizable plugin v2.1.0
  - take full available browser space to show images

(c) 2011-2015 Matthias Schmidt <http://m-schmidt.eu/>

Example Usage:
  $('a.fullsizable').fullsizable();

Options:
  **detach_id** (optional, defaults to null) - id of an element that will temporarely be set to ``display: none`` after the curtain loaded.
  **navigation** (optional, defaults to true) - show next and previous links when working with a set of images.
  **closeButton** (optional, defaults to true) - show a close link.
  **fullscreenButton** (optional, defaults to true) - show full screen button for native HTML5 fullscreen support in supported browsers.
  **openOnClick** (optional, defaults to true) - set to false to disable default behavior which fullsizes an image when clicking on a thumb.
  **clickBehaviour** (optional, 'next' or 'close', defaults to 'close') - whether a click on an opened image should close the viewer or open the next image.
  **preload** (optional, defaults to true) - lookup selector on initialization, set only to false in combination with ``reloadOnOpen: true`` or ``fullsizable:reload`` event.
  **reloadOnOpen** (optional, defaults to false) - lookup selector every time the viewer opens.
  **loop** (optional, defaults to false) - don't hide prev/next button on first/last image, so images are looped
  **caption** (optional, defaults to false) - displays a caption at the bottom of the image. Caption can be set using ``title`` and ``alt`` attributes of the thumbnail.
###

$ = jQuery

container_id = '#jquery-fullsizable'
image_holder_id = '#fullsized_image_holder'
next_id = '#fullsized_go_next'
prev_id = '#fullsized_go_prev'
close_id = '#fullsized_close'
fullscreen_id = '#fullsized_fullscreen'
spinner_class = 'fullsized_spinner'
$image_holder = $('<div id="jquery-fullsizable"><div id="fullsized_wrapper"><div id="fullsized_holder"><div id="fullsized_image_holder"></div></div></div></div>')
$caption_holder  = $('<div id="fullsized_caption_holder"></div>')

images = []
current_image = 0
options = null
stored_scroll_position = null

resizeImage = ->
  image = images[current_image]

  image.ratio ?= (image.naturalHeight / image.naturalWidth).toFixed(2)
  if $(window).height() / image.ratio > $(window).width()
    $(image).width($(window).width())
    $(image).height($(window).width() * image.ratio)
    $(image).css('margin-top', ($(window).height() - $(image).height()) / 2)
  else
    $(image).height($(window).height())
    $(image).width($(window).height() / image.ratio)
    $(image).css('margin-top', 0)

keyPressed = (e) ->
  closeViewer() if e.keyCode == 27

  if options.navigation
    prevImage(true) if e.keyCode == 37
    nextImage(true) if e.keyCode == 39

prevImage = (shouldHideChrome = false) ->
  if current_image > 0
    showImage(images[current_image - 1], -1, shouldHideChrome)
  else if options.loop
    showImage(images[images.length - 1], -1, shouldHideChrome)

nextImage = (shouldHideChrome = false) ->
  if current_image < images.length - 1
    showImage(images[current_image + 1], 1, shouldHideChrome)
  else if options.loop
    showImage(images[0], 1, shouldHideChrome)

showImage = (image, direction = 1, shouldHideChrome = false) ->
  current_image = image.index
  $(image_holder_id).hide()
  $(image_holder_id).html(image)
  if options.caption
    if image.caption
      $caption_holder.html(image.caption);
      $caption_holder.css({visibility: 'visible'});
    else
      $caption_holder.css({visibility: 'hidden'});

  # show/hide navigation when hitting range limits
  if options.navigation
    if shouldHideChrome == true
      hideChrome()
    else
      showChrome()

  if image.loaded?
    $(container_id).removeClass(spinner_class)
    resizeImage()
    $(image_holder_id).fadeIn('fast')
    preloadImage(direction)
  else
    # first load
    $(container_id).addClass(spinner_class)
    image.onload = ->
      resizeImage()
      $(image_holder_id).fadeIn 'slow', ->
        $(container_id).removeClass(spinner_class)
      this.loaded = true
      preloadImage(direction)

    image.src = image.buffer_src

preloadImage = (direction) ->
  # smart preloading
  if direction == 1 and current_image < images.length - 1
    preload_image = images[current_image + 1]
  else if (direction == -1 or current_image == (images.length - 1)) and current_image > 0
    preload_image = images[current_image - 1]
  else
    return

  preload_image.onload = ->
    this.loaded = true
  preload_image.src = preload_image.buffer_src if preload_image.src == ''

openViewer = (image, opening_selector) ->
  $('body').append($image_holder)
  $(window).bind 'resize', resizeImage
  showImage(image)
  $(container_id).hide().fadeIn ->
    if options.detach_id?
      stored_scroll_position = $(window).scrollTop()
      $('#' + options.detach_id).css('display', 'none')
      resizeImage()
    bindCurtainEvents()
    $(document).trigger('fullsizable:opened', opening_selector)

closeViewer = ->
  if options.detach_id?
    $('#' + options.detach_id).css('display', 'block')
    $(window).scrollTop(stored_scroll_position)
  $(container_id).fadeOut ->
    $image_holder.remove()
  closeFullscreen()

  $(container_id).removeClass(spinner_class)
  unbindCurtainEvents()
  $(window).unbind 'resize', resizeImage

makeFullsizable = ->
  images.length = 0

  $(options.selector).each ->
    image = new Image
    $this = $(this)
    $imageElement = $this.children('img:first');
    image.buffer_src = $this.attr('href')
    image.index = images.length
    if options.caption
        image.caption = '';
        image.caption += ('<b>' + $imageElement.attr('title') + '</b><br>') if !!$imageElement.attr('title')
        image.caption += $imageElement.attr('alt') if !!$imageElement.attr('alt')
    images.push image

    if options.openOnClick
      $this.unbind("click").click (e) ->
        e.preventDefault()
        makeFullsizable() if options.reloadOnOpen
        openViewer(image, this)

prepareCurtain = ->
  if options.navigation and $image_holder.find(prev_id).length == 0
    $image_holder.append('<button id="fullsized_go_prev" type="button" title="Previous"></button><button id="fullsized_go_next" type="button" title="Next"></button>')
    $(document).on 'click', prev_id, (e) ->
      e.preventDefault()
      e.stopPropagation()
      prevImage()
    $(document).on 'click', next_id, (e) ->
      e.preventDefault()
      e.stopPropagation()
      nextImage()

  if options.closeButton and $image_holder.find(close_id).length == 0
    $image_holder.append('<button id="fullsized_close" type="button" title="Close"></button>')
    $(document).on 'click', close_id, (e) ->
      e.preventDefault()
      e.stopPropagation()
      closeViewer()

  if options.fullscreenButton and hasFullscreenSupport() and $image_holder.find(fullscreen_id).length == 0
    $image_holder.append('<button id="fullsized_fullscreen" type="button" title="Toggle fullscreen"></button>')
    $(document).on 'click', fullscreen_id, (e) ->
      e.preventDefault()
      e.stopPropagation()
      toggleFullscreen()

  if options.caption
    $image_holder.find('#fullsized_holder').append($caption_holder)

  switch options.clickBehaviour
    when 'close' then $(document).on 'click', container_id, closeViewer
    when 'next' then $(document).on 'click', container_id, -> nextImage(true)
    else $(document).on 'click', container_id, options.clickBehaviour

bindCurtainEvents = ->
  $(document).bind 'keydown', keyPressed
  if options.navigation
    $(document).bind 'fullsizable:next', -> nextImage(true)
    $(document).bind 'fullsizable:prev', -> prevImage(true)
  $(document).bind 'fullsizable:close', closeViewer

unbindCurtainEvents = ->
  $(document).unbind 'keydown', keyPressed
  if options.navigation
    $(document).unbind 'fullsizable:next'
    $(document).unbind 'fullsizable:prev'
  $(document).unbind 'fullsizable:close'

hideChrome = ->
  $caption_holder.toggle(false);
  $chrome = $image_holder.find('button')
  if $chrome.is(':visible') == true
    $chrome.toggle(false)
    $image_holder.bind 'mousemove', mouseMovement

mouseStart = null
mouseMovement = (event) ->
  mouseStart = [event.clientX, event.clientY] if mouseStart == null
  distance = Math.round(Math.sqrt(Math.pow(mouseStart[1] - event.clientY, 2) + Math.pow(mouseStart[0] - event.clientX, 2)))
  if distance >= 10
    $image_holder.unbind 'mousemove', mouseMovement
    mouseStart = null
    showChrome()

showChrome = ->
  $caption_holder.toggle(true);
  $(close_id+','+fullscreen_id).toggle(true)
  if options.loop
    $(prev_id).show()
    $(next_id).show()
  else
    $(prev_id).toggle(current_image != 0)
    $(next_id).toggle(current_image != images.length - 1)

$.fn.fullsizable = (opts) ->
  options = $.extend
    selector: this.selector
    detach_id: null
    navigation: true
    closeButton: true
    fullscreenButton: true
    openOnClick: true
    clickBehaviour: 'close'
    preload: true
    reloadOnOpen: false
    loop: false
    caption : false
  , opts || {}

  prepareCurtain()

  makeFullsizable() if options.preload

  $(document).bind 'fullsizable:reload', makeFullsizable
  $(document).bind 'fullsizable:open', (e, target) ->
    makeFullsizable() if options.reloadOnOpen
    for image in images
      if image.buffer_src == $(target).attr('href')
        openViewer(image, target)

  return this

hasFullscreenSupport = ->
  fs_dom = $image_holder.get(0)
  if fs_dom.requestFullScreen or fs_dom.webkitRequestFullScreen or fs_dom.mozRequestFullScreen
    return true
  else
    return false

closeFullscreen = ->
  toggleFullscreen(true)

toggleFullscreen = (force_close) ->
  fs_dom = $image_holder.get(0)
  if fs_dom.requestFullScreen
    if document.fullScreen or force_close
      document.exitFullScreen()
    else
      fs_dom.requestFullScreen()
  else if fs_dom.webkitRequestFullScreen
    if document.webkitIsFullScreen or force_close
      document.webkitCancelFullScreen()
    else
      fs_dom.webkitRequestFullScreen()
  else if fs_dom.mozRequestFullScreen
    if document.mozFullScreen or force_close
      document.mozCancelFullScreen()
    else
      fs_dom.mozRequestFullScreen()
