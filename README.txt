================================================================================
=========================== GCC ARM Template Project ===========================
================================================================================


== Table of contents ==

1. Install
   A. Dependencies
   B. Limitations
2. License
3. Revisions

=== 1. Install ===

== 1.A. Dependencies ==

ARM cross compiler
* https://launchpad.net/gcc-arm-embedded
* Note: The CodeSourcery toolchain may work but is not the targeted toolchain.

CMake 2.8 or newer
* http://www.cmake.org

GNU compatible make
* Windows: http://gnuwin32.sourceforge.net/packages/make.htm
** MingW and CygWin make should work as drop-in substitutes.
* Mac OS X: Installed with X-Code or available through Fink/MacPorts.
* Linux: Installed with any GNU compiler, may already be installed.

== 1.A.i. Optional dependencies ==

USB driver
* Windows: http://sourceforge.net/projects/libwdi/files/zadig/
* Mac OS X/Linux: TODO

Programming utility/OpenOCD
* http://openocd.sourceforge.net/

=== 2. License ===

The template project and makefiles are licensed under the MIT License as
specified in License.txt.

=== 3. Revisions ===
Date        Author              Changes
2013/6/25   RJB                 Initial document
2013/7/4    RJB                 Updated dependencies
2013/7/23   RJB                 Updated dependencies