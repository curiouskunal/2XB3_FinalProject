#!/usr/bin/env ruby
class Run

	#"backend(#{jdata[:start_year].to_s} , #{jdata[:period].to_s} , #{jdata[:temp].to_s}, #{jdata[:percip].to_s} , #{jdata[:accuracy].to_s})"

	def self.backend start_year,period,temp,percip,accuracy
		puts "start_year: #{start_year}"
		puts "period: #{period}"
		puts "temp: #{temp}"
		puts "percip: #{percip}"
		puts "accuracy: #{accuracy}"
	end


end
# Run.backend("a","b","c","d","e")