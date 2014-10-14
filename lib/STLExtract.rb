require "STLExtract/version"
require 'io/console'

class StlExtract 
	def repair_file(file=nil)
		@error = false
		
		if file==nil
			#Check for file to repair in local @file
			if @file!=nil
				#Use file found in @file to repair
				file = @file
			else
				#No file provided, give error
				@error = "No file provided to repair"
			end
		else
			#Use file provided to function in repair
		end
		
		#If no errors, repair file
		if @error == false
			io = IO.popen(@slic3r_path+" --repair \""+file+"\" 2>&1")
			io.each do |s|
				if s.include? "No such file"
					@error = "Incorrect filename"
				end
			end
		end
	end
	
	def get_info(file)
		#Set @file to use later in repair
		@file = file
	
		#Set our initial values to nil and false for error
		@x_value = nil
		@y_value = nil
		@z_value = nil
		@volume = nil
		@repair = nil
		@error = false
		
		#Open slic3r with filename supplied
		io = IO.popen(@slic3r_path+" --info \""+file+"\" 2>&1")
		
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
			#If output contains repair stats
			if s.include? "needed repair"
				sizeMatch = s.match( /needed repair:[^y]+(yes|no)/ )
				if sizeMatch!=nil 
					if sizeMatch.values_at( 1 )[0]=="yes"
						@repair = true
					else
						@repair = false
					end
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
		if ((@x_value==nil || @y_value==nil || @z_value==nil || @volume==nil || @repair==nil ) && @error == false)
			@error = "Could not extract all data"
		end	
	end
	
	def initialize(file=nil)
		#Set our initial values to nil and false for error 
		@x_value = nil
		@y_value = nil
		@z_value = nil
		@volume = nil
		@repair = nil
		@error = false
		
		#Find Slic3r location
		@slic3r_path = File.expand_path('../../', __FILE__)
		if OS.windows?
			@slic3r_path = @slic3r_path + '/Slic3r/Win/slic3r-console.exe'
		elsif OS.mac?
			@slic3r_path = @slic3r_path + '/Slic3r/Mac/Slic3r.app/Contents/MacOS/slic3r'
		elsif OS.linux?
			@slic3r_path = @slic3r_path + '/Slic3r/Linux/bin/slic3r'
		else
			#RuntimeError
			raise "Could not detect platform from: "+RUBY_PLATFORM
		end		
		
		#Unix systems (Mac and Linux) require that file be executable
		if OS.unix?
			if File.chmod(0744,@slic3r_path) == 0
				#RuntimeError
				raise "Could not make Slic3r executable"
			end
		end	
		
		if file!=nil
			get_info(file)
		end
	end
  
	def x()
		#Return stored x value
		@x_value
	end
  
	def y()
		#Return stored y value
		@y_value
	end

	def z()
		#Return stored z value
		@z_value
	end

	def volume()
		#Return stored volume
		@volume
	end  
	
	def repair()
		#Return stored volume
		@repair
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
