# jQuery fullsizable plugin v1.3
take full available browser space to show images

## Example Usage
Use with default settings:

    $('a.fullsizable').fullsizable();

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
(c) 2011 Matthias Schmidt <http://m-schmidt.eu/>
