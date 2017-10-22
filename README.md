# Photos and Movies Relocate Script with EXIF Information

## Overview

Relocate photo and movie files in a current directory to Date/Time directories (ex. 20171023/) with EXIF Information

## Installation

- Install [Ruby](https://www.ruby-lang.org/)
- Install [ExifTool](https://www.sno.phy.queensu.ca/~phil/exiftool/)
- Download **image-relocate.rb**
    - Move the script to a directory included in PATH.
    - Add executable permission (ex. `chmod 755 image-relocate.rb`)

## Usage

Move the directory where photos are located. Then execute image-relocate.rb.

    $ image-relocate.rb

## Customize

Edit following part of image-relocate.rb directly.

    DIR_FORMAT  = "%F"

This is Date/Time directory format. (Default is %F = %Y-%m-%d. ex. 2015-06-10)
Format of [Time#strftime](http://ruby-doc.org/core-2.2.0/Time.html#method-i-strftime) is available.

For example,

    DIR_FORMAT  = "%Y%m%d"     -> ex. 20150610

    DIR_FORMAT  = "%y%m"       -> ex. 1506

## Original Script

- <https://github.com/mo-ya/photo-relocate>

## Test Environment

- ruby 2.4.1p111
- exiftool 10.53
