itex2MML
--------

Parses iTex (more or less a subset of LaTeX) into MathML. Originally written by Paul Gartside at the beginning of the Mozilla MathML project, later maintained by Jacques Distler. The nLab version began from the current version of the latter as of October 2021.

Usage
-----

Send in iTex on stdin, e.g.

`echo -n "\$x^{2}\$" | ./itex2MML`

Compilation
-----------

Simply run the following.

`make`

A compiled binary is included in the repository for convenience.

License
-------

The original itex2MML, and that maintained by Jacques Distler, was licensed under GPL, MPL, and LGPL. We impose no restrictions whatsoever except for the restrictions coming from GPL, MPL, and LGPL as they apply to the code of Gartside and Distler, and except that we do not permit anything which would legally override this sentence.
