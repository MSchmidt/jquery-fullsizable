# jQuery fullsizable plugin v1.2
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
Oh boy. Gonne write something here later.

## Changelog
* **unreleased**
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
