require './backend.rb'
require './Edge'

#!/usr/bin/env ruby
class Run

	#"backend(#{jdata[:start_year].to_s} , #{jdata[:period].to_s} , #{jdata[:temp].to_s}, #{jdata[:percip].to_s} , #{jdata[:accuracy].to_s})"

	def self.backend start_year,period,temp,percip,accuracy
		puts "start_year: #{start_year}"
		puts "period: #{period}"
		puts "temp: #{temp}"
		puts "percip: #{percip}"
		puts "accuracy: #{accuracy}"

    # Edge.setTolerances(20,20,20);
    # dataFile = 'test.csv';
    # BackEnd.parse (dataFile);
    # BackEnd.createGrid();
    # BackEnd.createEdges();
    # BackEnd.trimEdges();
    # puts BackEnd.graphEdges;


		f = File.open("./load.json", 'w')
		f.write('{"Graphs":false, "Cutting":false, "Testing":false, "loading":false}' )
		f.close
		f = File.open("./load.json", 'w')
		f.write('{"Graphs":true, "Cutting":false, "Testing":false, "loading":false}' )
		f.close
		sleep(1)
		f = File.open("./load.json", 'w')
		f.write('{"Graphs":true, "Cutting":true, "Testing":false, "loading":false}' )
		f.close
		sleep(1)
		f = File.open("./load.json", 'w')
		f.write('{"Graphs":true, "Cutting":true, "Testing":true, "loading":false}')
		f.close
		sleep(1)
		f = File.open("./load.json", 'w')
		f.write('{"Graphs":true, "Cutting":true, "Testing":true, "loading":true}' )
		f.close
    sleep(1)
    f = File.open("./load.json", 'w')
    f.write('{"Graphs":false, "Cutting":false, "Testing":false, "loading":false}' )
    f.close
	end
end
# puts "hi"
# Edge.setTolerances(20,20,20);
# dataFile = 'test.csv';
# BackEnd.parse (dataFile);
# BackEnd.createGrid();
# BackEnd.createEdges();
# BackEnd.trimEdges();
# tmp = BackEnd.getEdges();
# File.open 'edges.txt', 'w' do |file|
#   tmp.each do |edge|
#     file.write (edge.to_s + "\n")
#   end
# end