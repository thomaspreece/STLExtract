require "STLExtract/version"
require 'io/console'

class StlExtract 

	def initialize(file)
		#Set our values to -1 
		@x_value = -1
		@y_value = -1
		@z_value = -1
		@volume = -1  
		@error = -1
		#Find gem location
		gemPath = File.expand_path('../../', __FILE__)	

		if OS.windows?
			#Open slic3r with filename supplied
			io = IO.popen(gemPath+'/Slic3r/Win/slic3r-console.exe --info '+file+" 2>&1")
		elsif OS.mac?
			#Set file to be executable
			if File.chmod(0744,gemPath+'/Slic3r/Mac/Slic3r.app/Contents/MacOS/slic3r')
				#Open slic3r with filename supplied
				io = IO.popen(gemPath+'/Slic3r/Mac/Slic3r.app/Contents/MacOS/slic3r --info '+file+" 2>&1")
			else
				#RuntimeError
				raise "Could not make Slic3r executable"
			end
		elsif OS.linux?
			#Open slic3r with filename supplied
			if File.chmod(0744,gemPath+'/Slic3r/Linux/bin/slic3r')
				#Execute file
				io = IO.popen(gemPath+'/Slic3r/Linux/bin/slic3r --info '+file+" 2>&1")
			else
				#RuntimeError
				raise "Could not make Slic3r executable"				
			end
		else
			#RuntimeError
			raise "Could not detect platform from: "+RUBY_PLATFORM
		end
		
		
		
		io.each do |s|
			#If output contains size, extract size information using regex
			if s.include? "size"
				sizeMatch = s.match( /x=(\d+\.\d+)[^y]+y=(\d+\.\d+)[^z]+z=(\d+\.\d+)/ )
				if sizeMatch!=nil 
					@x_value = sizeMatch.values_at( 1 )[0]
					@y_value = sizeMatch.values_at( 2 )[0]
					@z_value = sizeMatch.values_at( 3 )[0]
				end
			end
			#If output contains volume, extract volume information using regex
			if s.include? "volume"
				volMatch = s.match( /volume\:[^\d]+(\d+\.\d+)/ )
				if volMatch!=nil 
					@volume = volMatch.values_at( 1 )[0]
				end			  
			end
			
			#Check Slic3r output for errors
			if s.include? "Input file must have .stl, .obj or .amf(.xml) extension"
				@error = "Filetype not STL, OBJ or AMF "+file
			end
			if s.include? "Failed to open"
				@error = "Could not find: "+file
			end 
			if s.include? "The file"
				@error = "Corrupted file: "+file
			end
		end
		
		#Check that all required data is extracted
		if ((@x_value==-1 || @y_value==-1 || @z_value==-1 || @volume==-1 ) && @error == -1)
			@error = "Could not extract all data"
		end		
	end
  
	def x_value()
		#Return stored x value
		@x_value
	end
  
	def y_value()
		#Return stored y value
		@y_value
	end

	def z_value()
		#Return stored z value
		@z_value
	end

	def volume()
		#Return stored volume
		@volume
	end  

	def error()
		#Return stored volume
		@error
	end  	
end



module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end
