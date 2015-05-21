# LaTuXiT

Copyright &copy; 2012, 2013, 2014 Lester Hedges.

Released under the [GPL](http://www.gnu.org/copyleft/gpl.html).

## About
`latuxit` is a a command-line Linux clone of the excellent Mac OS X program
[LaTeXiT](http://pierre.chachatelier.fr/latexit). It provides a simple means of
creating cropped LaTeX typset equations in both PDF and PostScript format.

The program is a simple Bash script that requires no dependencies outside of the
standard Tex Live core (other than Ghostscript for additional PostScript support).
The script replicates two of LaTeXiT's key features: an equation library, and a reverse
lookup feature to allow editing of existing equations. `latuxit` works by hashing each
equation string and building a library. Metadata written as comments in the output PDF
and PostScript images allows `latuxit` to match an image to an equation in the library.
`latuxit` has full RGB color support and also accepts any of the 68 standard colors
known to dvips. Due to its command-line nature, `latuxit` provides a handy way of
processing many equations from a batch script.

## Installation
After cloning the repository `cd` to the `latuxit` directory and run:

```bash
$ sudo ./install.sh
```

`latuxit` can be completely removed from your system as follows:

```bash
$ sudo uninstall.sh
```

## Usage
`latuxit` can be run in a variety of different ways using equation input from the
command-line, an editor, or from stdin. Several different use cases are
illustrated below.

* Equation passed using the command-line option or typed in an editor.

``` bash
$ latuxit [options]
```

* Equation passed via stdin. (*three examples*)

``` bash
$ echo "equation" | latuxit [options]
$ cat [FILE] | latuxit [options]
$ latuxit < [FILE] [options]
```

* Existing image edited using reverse lookup feature. (*two examples*)

``` bash
$ latuxit [IMAGE]
$ latuxit [IMAGE] [options]
```

## Options
`latuxit` supports the following short- and long-form  command-line options. Invoking
`latuxit` when no equation has been passed using the command-line option or via stdin
will open the editor defined by the `LATUXIT_EDITOR` environment variable. The user
can then type an equation and `latuxit` will  proceed  as normal once the file has
been saved and closed.

``` bash
-e EQUATION, --equation EQUATION
```

`EQUATION` in LaTeX markup. No `$` symbols are needed. The `EQUATION` should be
surrounded by double quotation marks, i.e. `"EQUATION"`, to ensure that it is parsed
correctly. When the equation starts with a minus sign make sure the character is
enclosed in curly braces, i.e. `"{-}..."` , so that it isn't mistaken as an identifier
for a command-line argument. Alternatively, simply insert a blank space at the start of
the equation. This will be ignored by LaTeX when the equation is typset. If the line
break command `\\` is needed, e.g. in a matrix, then three backslashes should be used
to ensure that the equation is parsed correctly, i.e. `\\\`. If no `EQUATION` is
passed on the command-line or from stdin then `latuxit` will open the `EQUATION`
editor defined by the `LATUXIT_EDITOR` environment variable. If `pdflatex` fails to
process an `EQUATION` then the user will be given the opportunity to edit it again
in order to correct any mistakes.

``` bash
-c COLOR, --color COLOR
```
Where `COLOR` is one of the 68 standard colors defined in `~/.latuxit/latuxit.colors`,
or, alternatively, a `COLOR` in `{R,G,B}` format, where `R,G,B=[0-1.0]`, or `[0-255]`.
`RGB` colors should be surrounded by double quotation marks, i.e. `"{R,G,B}"`, to
ensure they are parsed correctly. Also make sure that there aren't any blank spaces on
either side of any of the `RGB` values.

``` bash
-o FILE_PREFIX, --output FILE_PREFIX
```
`FILE_PREFIX` is a prefix used for all output images, e.g `FILE_PREFIX.pdf`. The
default is `latuxit`.

``` bash
-l, --list
```
Lists all equations in the library along with their hash.

``` bash 
-s EQUATION, --search EQUATION
```
Searches the equation library for all partial matches of `EQUATION`. The matches are
output along with the corresponding hash.

``` bash
-m HASH, --md5 HASH
```
Run `latuxit` in "hash" mode. The `HASH` string is matched against equations in the
library. It should be long enough to ensure a unique match. Once a match is found,
`latuxit` will open the equation for editing with `LATUXIT_EDITOR`.

``` bash
-b, --batch
```
Run `latuxit` in "batch" mode. In batch mode, `latuxit` will no longer ask
the user to re-edit any failed equations. This is useful when processing a
large number of equations using a batch script, e.g. when the user doesn't
want to edit many potentially incorrect equations by hand, or deal with memory
issues by opening many instances of the `LATUXIT_EDITOR`.

``` bash
-p, --purge
```
Purge the equation library.

``` bash
-h, --help
```
Get help (loads the man page).

## Reverse lookup feature
Running `latuxit` on an image that was previously created with `latuxit` will search
the file for metadata and open the corresponding equation from the library in the
editor defined by the `LATUXIT_EDITOR` environment variable. This allows the user to
modify an existing `latuxit` image. The image and equation are overwritten unless a
different `FILE_PREFIX` is specified.

## Environment variables
`latuxit's` behavior is affected by the following environment  variables. These can be
sourced from `~/.latuxitrc` or `~/.latuxit/latuxitrc`.

``` bash
LATUXIT_EDITOR
```
This variable specifies the editor to be used for typing equations. The default option
is vim.

``` bash
LATUXIT_COLOR
```
The `COLOR` of the equation. The default is `Black`, but the command-line option `-c`
will take precedence.

``` bash
LATUXIT_LIBRARY_SIZE
```
The size of the `latuxit` equation library. The default is 1000.

``` bash
LATUXIT_POSTSCRIPT
```
Whether to also save a PostScript copy of the output PDF. The default is true.

``` bash
LATUXIT_PURGE_CONFIRMATION
```
Whether to ask for confirmation	before purging the equation library. The default
is true.

## Example workflow

### Basic usage
Suppose we want a nice red image of the canonical partition function... here's a short
example of a possible LaTuXiT workflow.

``` bash
$ latuxit -e "Z=\sum_s e^{\beta E_s}" -c "Red"
```

There should now be two files in the working directory: `latuxit.pdf`, and
`latuxuit.ps`. Let's open `latuxit.pdf` and see what it looks like

<p align="center">
  <img src="http://i179.photobucket.com/albums/w319/scratchmandoo/website/code/latuxit/partition_1_zps330dea8e.png"  width=200/>
</p>

Whoops, it looks like we missed a minus sign, and how about we make the equation green
instead. The following command will extract equation metadata from `latuxit.pdf` and
open the equation in an editor where it can be corrected. Easy!

``` bash
$ latuxit latuxit.pdf -c "{102,255,0}"
```
Let's check the modified image. Snazzy.

<p align="center">
  <img src="http://i179.photobucket.com/albums/w319/scratchmandoo/website/code/latuxit/partition_2_zpseedb3cab.png"  width=200/>
</p>

### Searching the equation library
Suppose you want to edit an equation but you've lost the image file. You can kind of
remember the syntax, but it's long and complicated so you don't really fancy attempting
to type it out again. What do you do then?

Thankfully `latuxit` offers a solution. As a starting point you could simply get
`latuxit` to list all of the equations in the library and use grep to look for matches.

``` bash
$ latuxit -l | grep "sin"
abade05b27e49e91c5873deabb8f82f2 "\cos^2 x +\sin^2 x = 1"
ee8ff71994abccb0897510910c944468 "\sin 2\theta = 2\sin \theta \cos \theta"
```

Note that this is equivalent to running `latuxit` in "search" mode, i.e.

``` bash
$ latuxit -s "sin"
```

The two column output shows a list of matching hashes from the library and the
corresponding equations. Say the first match is the equation that we want. To reprocess
it we can simply run `latuxit` in hash mode. The hash string that is passed as a
command-line argument should be long enough to ensure a unique match. `latuxit` will
abort if multiple matches are found. The equation will be opened in an editor so that
it can be modified prior to processing.

``` bash
$ latuxit -m "abad"
```

<p align="center">
  <img src="http://i179.photobucket.com/albums/w319/scratchmandoo/website/code/latuxit/pythag_zps2a141f16.png"  width=200/>
</p>

## Credits
* [LaTeXiT](http://pierre.chachatelier.fr/latexit), for the inspiration.
* Ideas taken from [Giovanni Lanzani](http://www.lanzani.nl/latexit.html).
