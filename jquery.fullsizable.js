(function() {
  /*
  jQuery fullsizable plugin v1.1
    - take full available browser space to show images
  
  (c) 2011 Matthias Schmidt <http://m-schmidt.eu/>
  
  Example Usage:
    $('a.fullsizable').fullsizable();
  
  Options:
    detach_id: optional id of an element that will be set to display: none after curtain loaded
  */  var $, closeViewer, current_image, image_holder, image_holder_id, images, keyPressed, openViewer, options, preloadImage, resizeImage, showImage, spinner_class;
  $ = jQuery;
  image_holder_id = '#fullsized_image_holder';
  spinner_class = 'fullsized_spinner';
  image_holder = '<div id="fullsized_image_holder"></div>';
  images = [];
  current_image = 0;
  options = null;
  resizeImage = function() {
    var image, _ref;
    image = images[current_image];
        if ((_ref = image.ratio) != null) {
      _ref;
    } else {
      image.ratio = (image.height / image.width).toFixed(2);
    };
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
    if (e.keyCode === 37 && current_image > 0) {
      showImage(images[current_image - 1], -1);
    }
    if (e.keyCode === 39 && current_image < images.length - 1) {
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
    return $(image_holder_id).hide().fadeIn(function() {
      if (options.detach_id != null) {
        $('#' + options.detach_id).css('display', 'none');
      }
      return resizeImage();
    });
  };
  closeViewer = function() {
    if (options.detach_id != null) {
      $('#' + options.detach_id).css('display', 'block');
    }
    $(image_holder_id).fadeOut();
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
    this.each(function() {
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
    return $(image_holder_id).click(closeViewer);
  };
}).call(this);
