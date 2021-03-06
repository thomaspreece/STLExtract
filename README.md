# STLExtract

This is a gem that extracts various data about the 3d models contained in STL, OBJ and AMF files. It makes use of the multi-platform Slic3r program to extract data and works fine on Windows, Mac and Linux. It was orginally developed for a 3D printer marketplace built on Ruby on Rails.

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

First create a new StlExtract object using the following command.

```ruby
s = StlExtract.new()
```

Then use the following command to get info about a file specified as an argument. Note that even on Windows that folders are separated by a forward slash '/' in the argument.

```ruby
 s.get_info("C:/Users/Tom/Documents/champagne_bottle.stl")
```

You can automate the above two commands by specifying the optional file path in the new construct as shown below

```ruby
s = StlExtract.new("C:/Users/Tom/Documents/champagne_bottle.stl")
```

Should there be any errors with getting the details from the file then you can retrieve the error from 

```ruby
s.error
```

The error will be a string value containing text about the error or false if the program ran correctly and there was no error. If there was no errors then you can access x,y,z,volume and if file needs repair using

```ruby
s.x
s.y
s.z
s.volume
s.repair
```

Should the STL file need repairing we can use the following command

```ruby
s.repair_file("C:/Users/Tom/Documents/champagne_bottle.stl")
```

to create a fixed file named [OrginalName]_fixed.obj so in our above example we will now have a file named champagne_bottle_fixed.obj in C:/Users/Tom/Documents/.
If no argument is given to repair_file it automatically uses the last string passed to new() or get_info()


## Contributing

1. Fork it ( https://github.com/thomaspreece10/STLExtract/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
