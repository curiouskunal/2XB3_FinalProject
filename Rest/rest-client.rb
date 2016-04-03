#!/usr/bin/env ruby
require 'json' 
require 'rest-client' 

class Client
attr_reader :input, :output, :num
  
  def initialize x,y,z 
    @input = x 
    @output = y
    @days = z
  end 



  def callBackend
    response = RestClient.post 'http://localhost:8080/run', :data => {input: @input ,output: @output, num: @days }.to_json, :accept => :json 
    puts JSON.parse(response,:symbolize_names => true) 
  end 
end
