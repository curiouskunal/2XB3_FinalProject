require './backend.rb'
require './SQL'
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

puts "Setting Tolerances"
Edge.setTolerances(1,5,10);
puts "Quering SQL File"
dataFile = 'test.csv';
puts "Parsing"
#BackEnd.setData( SQL.parse(2000,2))

BackEnd.parse (dataFile);
puts "Formulating Grid Network"
BackEnd.createGrid();
puts "Building Graphs"
BackEnd.createEdges();
puts "Triming Graph"
BackEnd.trimEdges();
puts "Testing Design"
tmp = BackEnd.checkRelated();
first=true;
checkedVals = Set.new
File.open '../Frontend/goodbad.json', 'w' do |file|
  file.write('{
  "STATIONS":['+"\n")
	tmp.each do |key,value|
		value.each do |station|
      unless first

				file.write(",")
      end
			first =false;
      checkedVals.add(station.code);
			if (key == station.code)
				file.write('{"Longitude":'+station.location.longitude.to_s+', "Latitude":'+station.location.latitude.to_s+', "goodBad":2}'+"\n")
      else
				file.write('{"Longitude":'+station.location.longitude.to_s+', "Latitude":'+station.location.latitude.to_s+', "goodBad":1}'+"\n")
      end
		end
  end
	BackEnd.parse (dataFile);
	stationList=BackEnd.getData();
	stationList.each do |stations|

		unless checkedVals.include? stations.code
			file.write(",")
			file.write('{"Longitude":'+stations.location.longitude.to_s+', "Latitude":'+stations.location.latitude.to_s+', "goodBad":0}'+"\n")
    end


  end
	file.write(' ]
}'+"\n")
end



tmp = BackEnd.getEdges();

File.open 'edges.txt', 'w' do |file|
  tmp.each do |edge|
    file.write (edge.to_s + "\n")
  end
end