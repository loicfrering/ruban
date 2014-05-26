Ruban
=====

A simple framework for building nice HTML5 based presentations.

Documentation
-------------

You'll find the documentation on a Ruban: http://loicfrering.github.io/ruban/.

Changelog
---------

### 0.3.1

* Add `first()` and `last()` functions to go to the first and last slide.
* Bind the `home` and `end` keys to these new functions.
* Introduce the title option which allows to display a fixed title for the
  presentation in the footer.
* Add a .center class to easily center text.
* Correctly set the `main` property of the bower.json.
* Update Font-Awesome to 4.1.0.

### 0.3.0

* Do not reset the steps when coming from the following slide but allow passing
  them in the backward direction.
* Do not entirely strip HTML tags in the generated table of contents. It allows
  to have Font-Awesome icons in the TOC.
* Do not display the pagination when printing because it is dynamically updated
  with JavaScript and thus static and wrong in the print. You can use the
  pagination capabilities of the printer's driver to get pagination in a print.
* Support navigating through the Ruban with left and right mouse clicks.
  Disabled by default because it prevents text selection and the display of the
  context menu.
* Support navigating with the mouse wheel. Disabled by default.

### 0.2.2

* Bind pageup and pagedown keys.
* Update Font-Awesome to 4.0.3.
* Update other dependencies versions.

### 0.2.1

* Improve and fix navigation with gestures on mobile devices.
* Fix an issue with resizing on Webkit.

### 0.2.0

* Move css and js files from dist/ to css/ and js/ directories.
* Do not generate the Table of Content's title.
* Add a quickstart distribution.
* Fix some resizing issues.
* Improve the documentation.

### 0.1.2

* Table of Contents automatic generation.
* StyleSheet dedicated to print media.
* Support adding extra details in <detail> tags.

### 0.1.1

* Support pagination.
* Fix a resizing issue.

### 0.1.0

* Initial release.

License
-------

Copyright (c) 2013 [Loïc Frering](https://github.com/loicfrering), licensed
under the MIT license. See the LICENSE file for more informations.
