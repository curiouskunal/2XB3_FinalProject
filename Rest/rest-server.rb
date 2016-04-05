require 'sinatra' 
require 'json'

Dir.chdir("../Backend/")
require './run.rb'

filter = FilteringCSV.new

set :port, 8080 
set :environment, :production 


# Frontend sample input:
# http://localhost:8080{"start_year":1986,"period":1,"temp":0,"percip":0,"accuracy":0}

get '/query/:data' do

	:data.to_json  

  	jdata = JSON.parse(params[:data],:symbolize_names => true)

  	Run.backend(jdata[:start_year].to_i,jdata[:period].to_i,jdata[:temp].to_i,jdata[:percip].to_i,jdata[:accuracy].to_i)
  	
  	return_message = {} 
  	return_message[:status] = "backend(#{jdata[:start_year].to_s} , #{jdata[:period].to_s} , #{jdata[:temp].to_s}, #{jdata[:percip].to_s} , #{jdata[:accuracy].to_s})"
  	return_message.to_json 
end


get '/terminate' do
	body "I'll be back..."
	# maybe clean things up here...
	logger.info "Received terminate request!"
	Thread.new { sleep 1; Process.kill 'INT', Process.pid }
	halt 200
end