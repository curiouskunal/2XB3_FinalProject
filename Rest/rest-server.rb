require 'sinatra' 
require 'json' 

require '../Backend/FilteringCSV.rb'

filter = FilteringCSV.new

set :port, 8080 
set :environment, :production 


# Frontend sample input:
# http://localhost:8080/say/{"start_year":1986,"period":1,"temp":0,"percip":0,"accuracy":0}

get '/:data' do

	:data.to_json  

  	jdata = JSON.parse(params[:data],:symbolize_names => true)

  	# put call here
  	
  	return_message = {} 
  	return_message[:status] = "backend(#{jdata[:start_year].to_s} , #{jdata[:period].to_s} , #{jdata[:temp].to_s}, #{jdata[:percip].to_s} , #{jdata[:accuracy].to_s})"
  	return_message.to_json 
end


#filteringCSV Testing
get '/test/:data' do
	
	:data.to_json

  	# "Hello #{params['input']} , #{params['output']} , #{params['days']}!"

  	jdata = JSON.parse(params[:data],:symbolize_names => true)
  	
  	"Hello #{jdata[:input].to_s} , #{jdata[:output].to_s} , #{jdata[:days].to_s}!"
 	
 	filter.filterCSVdata('../Backend/data/Testing.csv','./data/RESTout.csv', 30)

 	return_message[:status] = "Running Filtering with #{jdata[:input].to_s} , #{jdata[:output].to_s} , #{jdata[:days].to_s}!" 
  	return_message.to_json  
end
