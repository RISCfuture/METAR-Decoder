# METAR Remarks Decoder

This command-line tool decodes METAR remarks into human-readable text. It's able
to handle all automated remarks and most human-generated remarks, as long as
they conform to the Federal Meteorological Handbook chapter 12.

## Requirements

Mac OS X 10.9, Xcode 5.1, and an Internet connection to download METARs.

## Usage

Simply run the command line tool with the ICAO code of the airport you wish to
decode METARs for:

```` bash
$ METAR\ Decoder PAFA
(R) temperature 11.1 °C, dewpoint 4.4 °C
(R) sea-level pressure 910.6 hPa
(R) barometric pressure 0.4 hPa higher than three hours ago and increasing more slowly
(R) few smoke at surface
(R) 24-hour temperature low 6.7 °C, high 21.1 °C
(R) automated weather observing (plus precipiation sensor)
````

Remarks are prefixed by an urgency:

|       |                                        |
|:------|:---------------------------------------|
| `(R)` | routine remark                         |
| `(C)` | remark indicates cautionary conditions |
| `(U)` | remark indicates dangerous conditions  |
| `(?)` | unknown or unparsed remark             |

## License

This code is released under the MIT License. See the `LICENSE` file for details.

## To-Dos

### Remarks not yet handled

* `TSB16E37` - thunderstorm begin/end
* `TS MOV SE` - thunderstorm movement
* `VCFU NE-SE` - fog in the vicinity, northeast to southeast

### Other to-do items

* `FU FEWxxx` decoded nonsensically as "few fog"
