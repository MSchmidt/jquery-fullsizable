# jQuery fullsizable plugin
jQuery plugin to make use of the full available browser space for enjoyable image viewing. Also supports the native HTML5 fullscreen API in
modern browsers.

jQuery Plugin page: <http://plugins.jquery.com/fullsizable/>


## Demo

Look at the demo section on <http://mschmidt.github.io/jquery-fullsizable> to see jquery-fullsizable in action.


## Installation

You can install ``jquery-fullsizable`` by using [Bower](http://bower.io/).

```bash
bower install jquery-fullsizable
```


## Example Usage
Use with default settings:

```javascript
$('a.fullsizable').fullsizable();
// while a.fullsizable are links to big images
```

Example with options:

```javascript
$('a.fullsizable').fullsizable({
  detach_id: 'wrapper',
  clickBehaviour: 'next'
});
```

## Options
**detach_id** (optional, defaults to null) - id of an element that will temporarily be set to ``display: none`` after the curtain loaded.
This can be used to hide scrollbars on long pages by e.g. detaching a wrapper element.

**navigation** (optional, defaults to true) - show next and previous links when working with a set of images.
Style links with ``#fullsized_go_prev`` and ``#fullsized_go_next``

**closeButton** (optional, defaults to true) - show a close link.
Style with ``#fullsized_close``

**fullscreenButton** (optional, defaults to true) - show full screen button for native HTML5 fullscreen support in supported browsers.
Style with ``#fullsized_fullscreen``

**openOnClick** (optional, defaults to true) - set to false to disable default behaviour which fullsizes an image when clicking on a thumb.

**clickBehaviour** (optional, 'next' or 'close', defaults to 'close') - whether a click on an opened image should close the viewer or open the next image.

**preload** (optional, defaults to true) - lookup selector on initialisation, set only to false in combination with ``reloadOnOpen: true`` or ``fullsizable:reload`` event.

**reloadOnOpen** (optional, defaults to false) - lookup selector every time the viewer opens.

**loop** (optional, defaults to false) - don't hide prev/next button on first/last image, so images are looped


## Styling
The packaged ``fullsizable.css`` stylesheet provides only the bare bones to make fullsizable work. Everything
else (basically the look of the buttons) is up to you. The ``simple.html`` example contains a few styles to give you an idea:

```css
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
```

### Included theme

Since v2.0 there is also an ready-to-use theme bundled as ``jquery-fullsizable-theme.css``.
Have a look at the ``themed_with_touch.html`` example.


## Advanced Usage

### Dynamic loading (e.g for pages built with a MVC framework)
By default, *fullsizable* checks the selector ``fullsizable()`` was called on in the beginning and stores the
found images internally. In case some images get added, remove or reordered on the page, *fullsizable*
won't know about the change and may behave unexpected.

For this situation *fullsizable* includes the ``reloadOnOpen`` option. With this
options set to true the selector will be run every time a user enters the fullsized view.
Since this is true for the first opened image as well you should disable the ``preload``
option too to save the browser from doing the same work twice:

```javascript
$('#gallery a').fullsizable({
  preload: false,
  reloadOnOpen: true
});
```

### Adding touch events
Because of the variety of mobile and touch devices and their quirks, *fullsizable* doesn't add it's own touch
events. It would add too much code to the otherwise small library. Also if you are planning
to make your page touch-ready, you've most likely included a touch-framework
like [Hammer.js](http://hammerjs.github.io) already.

Use such a touch-framework in combination with the provided fullsizable triggers and event.

Here is an example for adding swipe events with
[TouchSwipe](https://github.com/mattbryson/TouchSwipe-Jquery-Plugin): (from ``themed_with_touch.html`` example)

```javascript
$('a').fullsizable({
  detach_id: 'container'
});

$(document).on('fullsizable:opened', function(){
  $("#jquery-fullsizable").swipe({
    swipeLeft: function(){
      $(document).trigger('fullsizable:next')
    },
    swipeRight: function(){
      $(document).trigger('fullsizable:prev')
    },
    swipeUp: function(){
      $(document).trigger('fullsizable:close')
    }
  });
});
```

### Custom triggers and events
When using *fullsizable* in combination with a javascript MVC or any other advanced framework you may want
to customize the whole flow of loading images, opening the viewer, etc.

Therefor the following triggers and events are available:

Events: ``fullsizable:opened``

Triggers: ``fullsizable:open``, ``fullsizable:close``, ``fullsizable:next``, ``fullsizable:prev``, ``fullsizable:reload``


## Changelog
* **2.1.0** - 25.06.2015
  * allow custom function for ``clickBehaviour`` option (thanks to MatoTominac)
  * add ``loop`` option (thanks to pohlaniacz)
  * add bower support

* **2.0.2** - 03.09.2014
  * fullsizable:opened returns selector of element which triggered the viewer

* **2.0.1** - 15.07.2014
  * hiding UI elements works more reliably now

* **2.0** - 13.07.2014
  * add events and triggers for more advanced usage (e.g. adding touch events)
  * hide UI elements while navigating with keyboard or other events
  * better defaults for most common use case of having a gallery with multiple images
  * clean up DOM after the viewer is closed
  * remove dynamic mode and add options to achieve the same
  * fix distortion issue in IE11 (#3)

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


## Contributing
This plugin is written in CoffeeScript and then "compiled" into JavaScript. Please try to make changes to the ``jquery-fullsizable.coffee`` file directly and compile with ``coffee -c js/jquery-fullsizable.coffee``.


## Copyright
(c) 2011-2015 Matthias Schmidt <http://m-schmidt.eu/> & <http://pixelflush.com/>
