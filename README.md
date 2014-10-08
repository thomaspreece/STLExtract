# STLExtract

This is a gem that extracts various data about the 3d models contained in STL, OBJ and AMF files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'STLExtract'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install STLExtract

## Usage

Use the following command to get info about a file

```ruby
s = StlExtract.new( [FileName] )
```

Then you can access x,y,z and volume using

```ruby
s.x_value
s.y_value
s.z_value
s.volume
```

Should there be any errors with getting the details from the file then you can retrieve the error from 

```ruby
s.error
```

If error is -1 then program ran correctly and there is no error

## Contributing

1. Fork it ( https://github.com/thomaspreece10/STLExtract/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
