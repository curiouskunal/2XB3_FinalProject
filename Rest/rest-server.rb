require 'sinatra' 
require 'json' 

require '../Backend/FilteringCSV.rb'

filter = FilteringCSV.new

set :port, 8080 
set :environment, :production 

post '/run' do 
  return_message = {} 
  jdata = JSON.parse(params[:data],:symbolize_names => true)
  filter.filterCSVdata(jdata[:input].to_s, jdata[:output].to_s, jdata[:days].to_i)
  
  return_message[:status] = 'done' 
  return_message.to_json 
end 