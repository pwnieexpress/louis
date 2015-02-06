# Louis

[![Gem Version](https://badge.fury.io/rb/louis.svg)](http://badge.fury.io/rb/louis)

There is a public registry maintained by the IANA that is required to be used
by all vendors operating in certains spaces. Ethernet, Bluetooth, and Wireless
device manufacturers are all assigned unique prefixes. This database is
available publicly online and can be used to identify the manufacturer of these
devices. This library provides an easy mechanism to perform these lookups.

It is important to note that the way the lookup occur in this gem right now is
on the slower side, especially the first time a lookup is done as it doesn't
load it's database until then. This will improve over time as I already have
ideas on how to make the performance better.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'louis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install louis

## Usage

```ruby
Louis.lookup('84:3a:4b:49:bc:f0')
=> {"short_vendor"=>"IntelCor", "long_vendor"=>"Intel Corporate"}
```

When the Vendor information isn't known it will instead return:

```ruby
=> {"long_vendor"=>"Unknown", "short_vendor"=>"Unknown"}
```

## OUI Database

The textual database in this gem is from the [Wireshark][1] project,
specifically sourced [from their source][2]. The file itself is licensed under
GPLv2 on it's own and subsequent use needs to conform to it's licensing terms.

## Contributing

1. Fork it ( https://github.com/pwnieexpress/louis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[1]: https://wireshark.org/
[2]: https://code.wireshark.org/review/gitweb?p=wireshark.git;a=blob_plain;f=manuf
