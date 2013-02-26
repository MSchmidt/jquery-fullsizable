
/*
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
*/

(function() {
  var $, $image_holder, closeFullscreen, closeViewer, container_id, current_image, hasFullscreenSupport, image_holder_id, images, keyPressed, makeFullsizable, nextImage, openViewer, options, preloadImage, prevImage, resizeImage, selector, showImage, spinner_class, stored_scroll_position, toggleFullscreen;

  $ = jQuery;

  container_id = '#jquery-fullsizable';

  image_holder_id = '#fullsized_image_holder';

  spinner_class = 'fullsized_spinner';

  $image_holder = $('<div id="jquery-fullsizable"><div id="fullsized_image_holder"></div></div>');

  selector = null;

  images = [];

  current_image = 0;

  options = null;

  stored_scroll_position = null;

  resizeImage = function() {
    var image;
    image = images[current_image];
    if (image.ratio == null) image.ratio = (image.height / image.width).toFixed(2);
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
    if (e.keyCode === 27) closeViewer();
    if (e.keyCode === 37) prevImage();
    if (e.keyCode === 39) return nextImage();
  };

  prevImage = function() {
    if (current_image > 0) return showImage(images[current_image - 1], -1);
  };

  nextImage = function() {
    if (current_image < images.length - 1) {
      return showImage(images[current_image + 1], 1);
    }
  };

  showImage = function(image, direction) {
    if (direction == null) direction = 1;
    current_image = image.index;
    $(image_holder_id).hide();
    $(image_holder_id).html(image);
    if (options.navigation) {
      $('#fullsized_go_prev').toggle(current_image !== 0);
      $('#fullsized_go_next').toggle(current_image !== images.length - 1);
    }
    if (image.loaded != null) {
      $(container_id).removeClass(spinner_class);
      resizeImage();
      $(image_holder_id).fadeIn('fast');
      return preloadImage(direction);
    } else {
      $(container_id).addClass(spinner_class);
      image.onload = function() {
        resizeImage();
        $(image_holder_id).fadeIn('slow', function() {
          return $(container_id).removeClass(spinner_class);
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

  openViewer = function(image) {
    $(window).bind('resize', resizeImage);
    showImage(image);
    return $(container_id).hide().fadeIn(function() {
      if (options.detach_id != null) {
        stored_scroll_position = $(window).scrollTop();
        $('#' + options.detach_id).css('display', 'none');
        resizeImage();
      }
      if (options.clickBehaviour === 'close') {
        $(container_id).bind('click', closeViewer);
      }
      if (options.clickBehaviour === 'next') {
        $(container_id).bind('click', nextImage);
      }
      return $(document).bind('keydown', keyPressed);
    });
  };

  closeViewer = function() {
    if (options.detach_id != null) {
      $('#' + options.detach_id).css('display', 'block');
      $(window).scrollTop(stored_scroll_position);
    }
    if (options.clickBehaviour === 'close') {
      $(container_id).unbind('click', closeViewer);
    }
    if (options.clickBehaviour === 'next') {
      $(container_id).unbind('click', nextImage);
    }
    $(container_id).fadeOut();
    closeFullscreen();
    $(container_id).removeClass(spinner_class);
    $(document).unbind('keydown', keyPressed);
    return $(window).unbind('resize', resizeImage);
  };

  makeFullsizable = function() {
    var sel;
    images.length = 0;
    if (options.dynamic) {
      sel = $(options.dynamic);
    } else {
      sel = selector;
    }
    return sel.each(function() {
      var image;
      image = new Image;
      image.buffer_src = $(this).attr('href');
      image.index = images.length;
      images.push(image);
      if (options.openOnClick) {
        return $(this).click(function(e) {
          e.preventDefault();
          return openViewer(image);
        });
      }
    });
  };

  $.fn.fullsizable = function(opts) {
    options = $.extend({
      detach_id: null,
      navigation: false,
      openOnClick: true,
      closeButton: false,
      clickBehaviour: 'close',
      allowFullscreen: true,
      dynamic: null
    }, opts || {});
    $('body').append($image_holder);
    if (options.navigation) {
      $image_holder.append('<a id="fullsized_go_prev" href="#prev"></a><a id="fullsized_go_next" href="#next"></a>');
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
    if (options.closeButton) {
      $image_holder.append('<a id="fullsized_close" href="#close"></a>');
      $('#fullsized_close').click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        return closeViewer();
      });
    }
    if (options.allowFullscreen && hasFullscreenSupport()) {
      $image_holder.append('<a id="fullsized_fullscreen" href="#fullscreen"></a>');
      $('#fullsized_fullscreen').click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        return toggleFullscreen();
      });
    }
    selector = this;
    if (!options.dynamic) makeFullsizable();
    return this;
  };

  $.fullsizableDynamic = function(selector, opt) {
    if (opt == null) opt = {};
    return $(selector).fullsizable($.extend(opt, {
      dynamic: selector
    }));
  };

  $.fullsizableOpen = function(target) {
    var image, _i, _len, _results;
    if (options.dynamic) makeFullsizable();
    _results = [];
    for (_i = 0, _len = images.length; _i < _len; _i++) {
      image = images[_i];
      if (image.buffer_src === $(target).attr('href')) {
        _results.push(openViewer(image));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  hasFullscreenSupport = function() {
    var fs_dom;
    fs_dom = $image_holder.get(0);
    if (fs_dom.requestFullScreen || fs_dom.webkitRequestFullScreen || fs_dom.mozRequestFullScreen) {
      return true;
    } else {
      return false;
    }
  };

  closeFullscreen = function() {
    return toggleFullscreen(true);
  };

  toggleFullscreen = function(force_close) {
    var fs_dom;
    fs_dom = $image_holder.get(0);
    if (fs_dom.requestFullScreen) {
      if (document.fullScreen || force_close) {
        return document.exitFullScreen();
      } else {
        return fs_dom.requestFullScreen();
      }
    } else if (fs_dom.webkitRequestFullScreen) {
      if (document.webkitIsFullScreen || force_close) {
        return document.webkitCancelFullScreen();
      } else {
        return fs_dom.webkitRequestFullScreen();
      }
    } else if (fs_dom.mozRequestFullScreen) {
      if (document.mozFullScreen || force_close) {
        return document.mozCancelFullScreen();
      } else {
        return fs_dom.mozRequestFullScreen();
      }
    }
  };

}).call(this);
