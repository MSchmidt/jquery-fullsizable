# jQuery fullsizable plugin
jQuery plugin to take full available browser space for image viewing. Also supports the native HTML5 fullscreen API in
modern browsers.


## Demo

Click on any image at <https://getmatilda.com/blogs/f71a03-london> see jquery-fullsizable in action.


## Example Usage
Use with default settings:

    $('a.fullsizable').fullsizable();
    // while a.fullsizable are links to big images

Example with options:

    $('a.fullsizable').fullsizable({
      detach_id: 'wrapper',
      navigation: true
    });


## Options
**detach_id** (optional, defaults to null) - id of an element that will be set to display: none after the curtain loaded.
This can be used to hide scrollbars on long pages by e.g. detaching a wrapper element.

**navigation** (optional, defaults to false) - set to true to show next and previous links.
Style links with #fullsized\_go\_prev and #fullsized\_go\_next

**openOnClick** (optional, defaults to true) - set to false to disable default behavior which fullsizes an image when clicking on a thumb.
See advanced section for more detail

**closeButton** (optional, defaults to false) - set to true to show a close link.
Style with #fullsized\_close

**clickBehaviour** (optional, 'next' or 'close', defaults to 'close') - whether a click on an opened image should close the viewer or open the next image.

**allowFullscreen** (optional, defaults to true) - enable native HTML5 fullscreen support in supported browsers.
Style with #fullsized\_fullscreen


## Styling
The packaged fullsizable.css stylesheet provides only the bare bones to make fullsizable work. Everything
else (basically the look of the buttons) is up to you. The simple.html example contains a few styles to give you an idea:

    #fullsized_go_prev, #fullsized_go_next, #fullsized_close, #fullsized_fullscreen {
      position: absolute;
      top: 50%;
      display: block;
      width: 30px;
      height: 30px;
      background-color: red;
    }
    #fullsized_go_prev {
      left: 25px;
    }
    #fullsized_go_next {
      right: 25px;
    }
    #fullsized_close {
      top: 0;
      right: 0;
    }
    #fullsized_fullscreen {
      top: 0;
      right: 40px;
      background-color: green;
    }
    :fullscreen #fullsized_fullscreen { background-color: blue; }
    :-webkit-full-screen #fullsized_fullscreen { background-color: blue; }
    :-moz-full-screen #fullsized_fullscreen { background-color: blue; }

Have a look at <https://getmatilda.com/blogs/f71a03-london> to find some inspiration on a possible style.


## Advanced Usage

### Dynamic loading
By default, *fullsizable* checks the selector fullsizable() was called on in the beginning and stores the
found images internally. In case some images get added, remove or reordered on the page, *fullsizable*
won't know about the change and may behave unexpected.

For this situation *fullsizable* includes a dynamic mode. In dynamic mode the selector will be run every
time a user enters the fullsized view.

You can make use of the dynamic mode by calling *fullsizable* via `$.fullsizableDynamic`:

    $.fullsizableDynamic(selector, options);

Example:

    $.fullsizableDynamic('#gallery a', {
      navigation: true
    });

### Custom trigger event
When using *fullsizable* in combination with a javascript MVC or any other advanced framework you may want
to customize when an image gets opened in fullsized view.

To do so, you should disable the default click event first:

    $('a.fullsizable').fullsizable({
      openOnClick: false
    });

Then you can call `$.fullsizableOpen` whenever you like by passing in the anchor element from the image
that should get opened.

    $('a').click(function(e) {
      e.preventDefault();
    });

    $('a').dblclick(function(e) {
      e.preventDefault();
      $.fullsizableOpen(this);
    });


## Changelog
* **1.6** - 26.02.2013
  * open sourced under MIT, no technical changes

* **1.5** - 12.04.2012
  * add allowFullscreen option (native HTML5 fullscreen support)

* **1.4** - 10.04.2012
  * add closeButton option
  * add clickBehaviour option
  * bugfix: remember scroll position when using detach option

* **1.3** - 25.08.2011
  * add openOnClick option to enable/disable default behavior
  * add dynamic mode for advanced usage scenarios
  * bugfix: closing curtain too early left blank page
  * bugfix: spinner appeared too late
  * bugfix: first image appeared uncropped sometimes

* **1.2** - 11.08.2011
  * add navigation option to enable next and previous links

* **1.1** - 29.05.2011
  * first stable version
  * keyboard support
  * intelligent preloading


## Copyright
(c) 2011-2013 Matthias Schmidt <http://m-schmidt.eu/>
