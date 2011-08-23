(function() {
  /*
  jQuery fullsizable plugin v1.2
    - take full available browser space to show images
  
  (c) 2011 Matthias Schmidt <http://m-schmidt.eu/>
  
  Example Usage:
    $('a.fullsizable').fullsizable();
  
  Options:
    **detach_id** (optional) - id of an element that will be set to display: none after the curtain loaded.
    **navigation** (optional) - set to true to show next and previous links.
  */
  var $, closeViewer, container_id, current_image, image_holder, image_holder_id, images, keyPressed, navigation_holder, nextImage, openViewer, options, preloadImage, prevImage, resizeImage, showImage, spinner_class;
  $ = jQuery;
  container_id = '#jquery-fullsizable';
  image_holder_id = '#fullsized_image_holder';
  spinner_class = 'fullsized_spinner';
  image_holder = $('<div id="jquery-fullsizable"><div id="fullsized_image_holder"></div></div>');
  navigation_holder = $('<a id="fullsized_go_prev" href="#prev"></a><a id="fullsized_go_next" href="#next"></a>');
  images = [];
  current_image = 0;
  options = null;
  resizeImage = function() {
    var image, _ref;
    image = images[current_image];
    if ((_ref = image.ratio) == null) {
      image.ratio = (image.height / image.width).toFixed(2);
    }
    if ($(window).height() / image.ratio > $(window).width()) {
      $(image).width($(window).width());
      $(image).height($(window).width() * image.ratio);
      return $(image).css('margin-top', ($(window).height() - $(image).height()) / 2);
    } else {
      $(image).height($(window).height());
      $(image).width($(window).height() / image.ratio);
      return $(image).css('margin-top', 0);
    }
  };
  keyPressed = function(e) {
    if (e.keyCode === 27) {
      closeViewer();
    }
    if (e.keyCode === 37) {
      prevImage();
    }
    if (e.keyCode === 39) {
      return nextImage();
    }
  };
  prevImage = function() {
    if (current_image > 0) {
      return showImage(images[current_image - 1], -1);
    }
  };
  nextImage = function() {
    if (current_image < images.length - 1) {
      return showImage(images[current_image + 1], 1);
    }
  };
  showImage = function(image, direction) {
    if (direction == null) {
      direction = 1;
    }
    current_image = image.index;
    $(image).hide();
    $(image_holder_id).html(image);
    if (options.navigation) {
      $('#fullsized_go_prev').toggle(current_image !== 0);
      $('#fullsized_go_next').toggle(current_image !== images.length - 1);
    }
    if (image.loaded != null) {
      $(image_holder_id).removeClass(spinner_class);
      resizeImage();
      $(image).fadeIn('fast');
      return preloadImage(direction);
    } else {
      $(image_holder_id).addClass(spinner_class);
      image.onload = function() {
        resizeImage();
        $(this).fadeIn('slow', function() {
          return $(image_holder_id).removeClass(spinner_class);
        });
        this.loaded = true;
        return preloadImage(direction);
      };
      return image.src = image.buffer_src;
    }
  };
  preloadImage = function(direction) {
    var preload_image;
    if (direction === 1 && current_image < images.length - 1) {
      preload_image = images[current_image + 1];
    } else if ((direction === -1 || current_image === (images.length - 1)) && current_image > 0) {
      preload_image = images[current_image - 1];
    } else {
      return;
    }
    preload_image.onload = function() {
      return this.loaded = true;
    };
    if (preload_image.src === '') {
      return preload_image.src = preload_image.buffer_src;
    }
  };
  openViewer = function() {
    $(document).bind('keydown', keyPressed);
    $(window).bind('resize', resizeImage);
    return $(container_id).hide().fadeIn(function() {
      if (options.detach_id != null) {
        $('#' + options.detach_id).css('display', 'none');
      }
      $(container_id).bind('click', closeViewer);
      return resizeImage();
    });
  };
  closeViewer = function() {
    if (options.detach_id != null) {
      $('#' + options.detach_id).css('display', 'block');
    }
    $(container_id).unbind('click', closeViewer);
    $(container_id).fadeOut();
    $(image_holder_id).removeClass(spinner_class);
    $(document).unbind('keydown', keyPressed);
    return $(window).unbind('resize', resizeImage);
  };
  $.fn.fullsizable = function(opt) {
    if (opt == null) {
      opt = {};
    }
    options = opt;
    $('body').append(image_holder);
    if (options.navigation) {
      image_holder.append(navigation_holder);
      $('#fullsized_go_prev').click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        return prevImage();
      });
      $('#fullsized_go_next').click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        return nextImage();
      });
    }
    return this.each(function() {
      var image;
      image = new Image;
      image.buffer_src = this.href;
      image.index = images.length;
      images.push(image);
      return $(this).click(function(e) {
        e.preventDefault();
        showImage(image);
        return openViewer();
      });
    });
  };
}).call(this);
