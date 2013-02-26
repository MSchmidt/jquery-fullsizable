###
jQuery fullsizable plugin v1.6
  - take full available browser space to show images

(c) 2011-2013 Matthias Schmidt <http://m-schmidt.eu/>

Example Usage:
  $('a.fullsizable').fullsizable();

Options:
  **detach_id** (optional, defaults to null) - id of an element that will be set to display: none after the curtain loaded.
  **navigation** (optional, defaults to false) - set to true to show next and previous links.
  **openOnClick** (optional, defaults to true) - set to false to disable default behavior which fullsizes an image when clicking on a thumb.
  **closeButton** (optional, defaults to false) - set to true to show a close link.
  **clickBehaviour** (optional, 'next' or 'close', defaults to 'close') - whether a click on an opened image should close the viewer or open the next image.
  **allowFullscreen** (optional, defaults to true) - enable native HTML5 fullscreen support in supported browsers.
###

$ = jQuery

container_id = '#jquery-fullsizable'
image_holder_id = '#fullsized_image_holder'
spinner_class = 'fullsized_spinner'
$image_holder = $('<div id="jquery-fullsizable"><div id="fullsized_image_holder"></div></div>')

selector = null
images = []
current_image = 0
options = null
stored_scroll_position = null

resizeImage = ->
  image = images[current_image]

  image.ratio ?= (image.height / image.width).toFixed(2)
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

  if e.keyCode == 37
    prevImage()

  if e.keyCode == 39
    nextImage()

prevImage = ->
  if current_image > 0
    showImage(images[current_image - 1], -1)

nextImage = ->
  if current_image < images.length - 1
    showImage(images[current_image + 1], 1)

showImage = (image, direction = 1) ->
  current_image = image.index
  $(image_holder_id).hide()
  $(image_holder_id).html(image)

  # show/hide navigation when hitting range limits
  if options.navigation
    $('#fullsized_go_prev').toggle(current_image != 0)
    $('#fullsized_go_next').toggle(current_image != images.length - 1)

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

openViewer = (image) ->
  $(window).bind 'resize', resizeImage
  showImage(image)
  $(container_id).hide().fadeIn ->
    if options.detach_id?
      stored_scroll_position = $(window).scrollTop()
      $('#' + options.detach_id).css('display', 'none')
      resizeImage()
    $(container_id).bind 'click', closeViewer if options.clickBehaviour == 'close'
    $(container_id).bind 'click', nextImage if options.clickBehaviour == 'next'
    $(document).bind 'keydown', keyPressed

closeViewer = ->
  if options.detach_id?
    $('#' + options.detach_id).css('display', 'block')
    $(window).scrollTop(stored_scroll_position)
  $(container_id).unbind 'click', closeViewer if options.clickBehaviour == 'close'
  $(container_id).unbind 'click', nextImage if options.clickBehaviour == 'next'
  $(container_id).fadeOut()
  closeFullscreen()

  $(container_id).removeClass(spinner_class)
  $(document).unbind 'keydown', keyPressed
  $(window).unbind 'resize', resizeImage

makeFullsizable = ->
  images.length = 0

  if options.dynamic
    sel = $(options.dynamic)
  else
    sel = selector

  sel.each ->
    image = new Image
    image.buffer_src = $(this).attr('href')
    image.index = images.length
    images.push image

    if options.openOnClick
      $(this).click (e) ->
        e.preventDefault()
        openViewer(image)

$.fn.fullsizable = (opts) ->
  options = $.extend
    detach_id: null
    navigation: false
    openOnClick: true
    closeButton: false
    clickBehaviour: 'close'
    allowFullscreen: true
    dynamic: null
  , opts || {}

  $('body').append($image_holder)

  if options.navigation
    $image_holder.append('<a id="fullsized_go_prev" href="#prev"></a><a id="fullsized_go_next" href="#next"></a>')
    $('#fullsized_go_prev').click (e) ->
      e.preventDefault()
      e.stopPropagation()
      prevImage()
    $('#fullsized_go_next').click (e) ->
      e.preventDefault()
      e.stopPropagation()
      nextImage()

  if options.closeButton
    $image_holder.append('<a id="fullsized_close" href="#close"></a>')
    $('#fullsized_close').click (e) ->
      e.preventDefault()
      e.stopPropagation()
      closeViewer()

  if options.allowFullscreen and hasFullscreenSupport()
    $image_holder.append('<a id="fullsized_fullscreen" href="#fullscreen"></a>')
    $('#fullsized_fullscreen').click (e) ->
      e.preventDefault()
      e.stopPropagation()
      toggleFullscreen()

  selector = this
  makeFullsizable() unless options.dynamic

  return this

$.fullsizableDynamic = (selector, opt = {}) ->
  $(selector).fullsizable($.extend(opt, {dynamic: selector}))

$.fullsizableOpen = (target) ->
  makeFullsizable() if options.dynamic
  for image in images
    if image.buffer_src == $(target).attr('href')
      openViewer(image)

hasFullscreenSupport = ->
  fs_dom = $image_holder.get(0)
  if fs_dom.requestFullScreen or fs_dom.webkitRequestFullScreen or fs_dom.mozRequestFullScreen
    return true
  else
    return false

closeFullscreen = ->
  toggleFullscreen(true)

toggleFullscreen = (force_close)->
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
