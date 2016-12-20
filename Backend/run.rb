require './backend.rb'
require './SQL'
require './Edge'

#!/usr/bin/env ruby
class Run

  #"backend(#{jdata[:start_year].to_s} , #{jdata[:period].to_s} , #{jdata[:temp].to_s}, #{jdata[:percip].to_s} , #{jdata[:accuracy].to_s})"

  def self.backend start_year, period, temp, percip, accuracy
    puts "start_year: #{start_year}"
    puts "period: #{period}"
    puts "temp: #{temp}"
    puts "percip: #{percip}"
    puts "accuracy: #{accuracy}"
    a = Time.new()
    puts  a.to_f

    BackEnd.resetVals();

    # Edge.setTolerances(20,20,20);
    # dataFile = 'test.csv';
    # BackEnd.parse (dataFile);
    # BackEnd.createGrid();
    # BackEnd.createEdges();
    # BackEnd.trimEdges();
    # puts BackEnd.graphEdges;

    f = File.open("./load.json", 'w')
    f.write('{"Graphs":true, "Cutting":false, "Testing":false, "loading":false}')
    f.close

    puts "Setting Tolerances"
    Edge.setTolerances(temp, percip, accuracy);
    puts "Quering SQL File"
    dataFile = 'test.csv';
    puts "Parsing"
    BackEnd.setData(SQL.parse(start_year, period)[0])
    #BackEnd.parse (dataFile);


    puts "Formulating Grid Network"
    BackEnd.createGrid();

    f = File.open("./load.json", 'w')
    f.write('{"Graphs":true, "Cutting":true, "Testing":false, "loading":false}')
    f.close

    puts "Building Graphs"
    BackEnd.createEdges();




    puts "Triming Graph"
    BackEnd.trimEdges();
    puts "Testing Design"

    f = File.open("./load.json", 'w')
    f.write('{"Graphs":true, "Cutting":true, "Testing":true, "loading":false}')
    f.close

    Run.writeOutputFile(start_year, period)

    f = File.open("./load.json", 'w')
    f.write('{"Graphs":true, "Cutting":true, "Testing":true, "loading":true}')
    f.close

    sleep(1)
    f = File.open("./load.json", 'w')
    f.write('{"Graphs":false, "Cutting":false, "Testing":false, "loading":false}')
    f.close
    puts"------------------"
    puts (Time.new-a).to_f;
    puts"------------------"
  end

  def self.futureCheck(start_year,period,tmp)

   # tmp = BackEnd.checkRelated();

    stationList=SQL.parse(start_year+period,2)[0];

    tmp.each do |key, value|
    #  value.each do |station|
    #    if (key == station.code && tmp[key].length>1)
          for i in 0..stationList.length-1
            if (stationList[i].code==key)

              tmpp = tmp[key]
              rmL8r=Array.new()
              for j in 0..tmpp.length-1
                for k in 0..stationList.length-1
                  if (stationList[k].code==tmpp[j].code)
                    if(!Edge.is_related?(stationList[k],stationList[i]))
                      rmL8r.push(j);
                    end
                  end
                end
              end
              for j in rmL8r.length-1..0
                tmpp.delete_at(j);
              end
            end
          end
      #  end
     # end
    end

    return tmp;
  end

  def self.writeOutputFile(start_year, period)

    tmp = Run.futureCheck(start_year,period,BackEnd.checkRelated());
    puts tmp.length
    #tmp =  SQL.parse(2000,2);
    first=true;
    checkedVals = Set.new
    File.open '../Frontend/goodbad.json', 'w' do |file|
      file.write('{"STATIONS":['+"\n")
      tmp.each do |key, value|
        value.each do |station|
          unless first
            file.write(",")
          end
          first =false;
          checkedVals.add(station.code);
          if (key == station.code && tmp[key].length>1)
            file.write('{"Name":"'+station.code+'", "Longitude":'+station.location.longitude.to_s+', "Latitude":'+station.location.latitude.to_s+', "goodBad":3}'+"\n")
          elsif (key == station.code)
            file.write('{"Name":"'+station.code+'", "Longitude":'+station.location.longitude.to_s+', "Latitude":'+station.location.latitude.to_s+', "goodBad":1}'+"\n")
          else
            file.write('{"Name":"'+station.code+'", "Longitude":'+station.location.longitude.to_s+', "Latitude":'+station.location.latitude.to_s+', "goodBad":2}'+"\n")
          end
        end
      end
      # BackEnd.parse (dataFile);
      #stationList=BackEnd.getData();
      stationList=SQL.parse(start_year, period)[0];

      stationList.each do |stations|

        unless checkedVals.include? stations.code
          unless first
            file.write(",")
          end
          first =false;
          file.write('{"Name":"'+stations.code+'", "Longitude":'+stations.location.longitude.to_s+', "Latitude":'+stations.location.latitude.to_s+', "goodBad":1}'+"\n")
        end
      end
      stationList=SQL.parse(start_year, period)[1];
      puts stationList.length
      stationList.each do |stations|
        unless first
          file.write(",")
        end
        first =false;
          file.write('{"Name":"'+stations.code+'", "Longitude":'+stations.location.longitude.to_s+', "Latitude":'+stations.location.latitude.to_s+', "goodBad":0}'+"\n")
      end
      file.write(' ]}'+"\n")
    end
  end
end


=begin

puts "Setting Tolerances"
Edge.setTolerances(10, 10, 10);
puts "Quering SQL File"
dataFile = 'test.csv';
puts "Parsing"
BackEnd.setData( SQL.parse(2000,2)[0])
#BackEnd.parse (dataFile);



puts "Formulating Grid Network"
BackEnd.createGrid();



puts "Building Graphs"
BackEnd.createEdges();




puts "Triming Graph"
BackEnd.trimEdges();
puts "Testing Design"



Run.writeOutputFile(2000,2);
=end


=begin

tmp = BackEnd.getEdges();

File.open 'edges.txt', 'w' do |file|
  tmp.each do |edge|
    file.write (edge.to_s + "\n")
  end
end
=end
