# StringyFi

Convert MusicXML to PIC assembler for running on the Boldport Club Stringy.

## About the Stringy

The [Stringy](https://www.boldport.com/products/stringy/) is an open source hardware project
from the wonderful [Boldport Club](http://www.boldport.club/).

The Stringy was Project #14 from June 2017, and is a remix of
[MadLab's 'Funky guitar'](http://www.madlab.org/kits/guitar.html).

## About StringyFi

StringyFi is a simple gem that converts MusicXML source files to
a PIC assembler source format that can be compiled and programmed to the Stringy.

See [LEAP#349 DemoBurner](https://github.com/tardate/LittleArduinoProjects/tree/master/BoldportClub/stringy/DemoBurner)
for a complete example of this in practice.

StringyFi has some serious limitations, some of which are in its implementation of MusicXML parsing,
some are fundamental limitations of the Stringy. I have found that most scores need tweaking
to be reproduced acceptably on the Stringy, and some are just too complex (without re-writing the Stringy firmware en-masse).
Some key points to note:

* The String uses ony 2-bit (4 levels) of note duration, so the conversion squeezes the score into 4 note durations as best as possible
* many notation features ignored: slides, ties etc

## Installation

Add this line to your application's Gemfile:

    gem 'stringyfi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stringyfi

## Usage

The StringyFi executable accepts a file path to the MusicXML source to convert,
and emits the assembler source on STDOUT (so it can be redirected as appropriate).

For example:

    $ stringyfi ./spec/fixtures/music_xml/chromatic.xml > ../CustomDemo.X/demo.tun

The
[spec/fixtures](./spec/fixtures/music_xml)
contains a few examples that are also used in tests.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
(6. Join Boldport Club!)
