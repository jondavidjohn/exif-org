# media-org

[![Build Status](https://travis-ci.org/jondavidjohn/media-org.svg?branch=master)](https://travis-ci.org/jondavidjohn/media-org)

This is a tool for a very personal use case, organizing my family media.  I tried to wrangle
a few tools written in higher level languages, but always ran into problems trying to run them
in streamlined environments like RaspberryPi and most recently my Western Digital WD MyCloud EX2.

Bash to the rescue, viva la portabilidad!

## Disclaimer

This tool is inherently destructive and intentionally causes many side effects.  I have attempted
to test and document it well to allow confidence, but you must use this tool at your own risk.  It
moves files around your disk destructively.

## Usage

The goal is to take a directory full of photos and organize them based on a series of
date based indicators.  The date of the photo is deduced in the following order...

  1. Exif data extracted and the "Date and Time (Original)" tag is used.
  2. A date is detected in the filename itself in the format of "YYYY-MM-DD"
  3. The file modified can also be used as a last resort with the use of a flag.

Additionally Videos (.avi and .mov) are also sorted by file time.

The resulting directory structure results in something like this.

    Destination Directory
    ├── Photos
    │   ├── 2014
    │   │   ├── 06
    │   │   ├── 07
    │   └── 2015
    │       ├── 06
    │       ├── 07
    │       └── 08
    ├── Videos
    │   ├── 2014
    │   │   ├── 06
    │   │   ├── 07
    │   └── 2015
    │       ├── 06
    │       ├── 07
    │       └── 08
    └── Unsortable


Files that cannot be sorted properly are moved into the `Unsortable` directory.

Basic usage is as such

    usage: media-org [directory to sort from] [destination directory]

## Installation

    git clone --recursive https://github.com/jondavidjohn/media-org.git media-org
    cd media-org

    ### make sure it works in your environment first! ###
    make test

    make install

### Upgrade

    cd media-org
    git pull
    make test
    make uninstall
    make install
