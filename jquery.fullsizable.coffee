###
jQuery fullsizable plugin v1.1
  - take full available browser space to show images

(c) 2011 Matthias Schmidt <http://m-schmidt.eu/>

Example Usage:
  $('a.fullsizable').fullsizable();

Options:
  detach_id: optional id of an element that will be set to display: none after curtain loaded
              this can be used to hide scrollbars on long pages by e.g. detaching a wrapper element
###

$ = jQuery

image_holder_id = '#fullsized_image_holder'
spinner_class = 'fullsized_spinner'
image_holder = '<div id="fullsized_image_holder"></div>'

images = []
current_image = 0
options = null

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

  if e.keyCode == 37 && current_image > 0
    showImage(images[current_image - 1], -1)

  if e.keyCode == 39 && current_image < images.length - 1
    showImage(images[current_image + 1], 1)

showImage = (image, direction = 1) ->
  current_image = image.index
  $(image).hide()
  $(image_holder_id).html(image)
  if image.loaded?
    $(image_holder_id).removeClass(spinner_class)
    resizeImage()
    $(image).fadeIn('fast')
    preloadImage(direction)
  else
    # first load
    $(image_holder_id).addClass(spinner_class)
    image.onload = ->
      resizeImage()
      $(this).fadeIn 'slow', ->
        $(image_holder_id).removeClass(spinner_class)
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

openViewer = ->
  $(document).bind 'keydown', keyPressed
  $(window).bind 'resize', resizeImage
  $(image_holder_id).hide().fadeIn ->
    $('#' + options.detach_id).css('display', 'none') if options.detach_id?
    resizeImage()

closeViewer = ->
  $('#' + options.detach_id).css('display', 'block') if options.detach_id?
  $(image_holder_id).fadeOut()
    
  $(image_holder_id).removeClass(spinner_class)
  $(document).unbind 'keydown', keyPressed
  $(window).unbind 'resize', resizeImage

$.fn.fullsizable = (opt = {}) ->
  options = opt
  $('body').append(image_holder)

  this.each ->
    image = new Image
    image.buffer_src = this.href
    image.index = images.length
    images.push image

    $(this).click (e) ->
      e.preventDefault()
      showImage(image)
      openViewer()

  $(image_holder_id).click closeViewer
