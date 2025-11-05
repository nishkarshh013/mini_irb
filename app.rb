require "sinatra"
require_relative "./mini_irb"

set :bind, "0.0.0.0"
set :port, ENV["PORT"] || 4567

get "/" do
  erb :index
end

post "/eval" do
  input = params[:code]
  result = nil

  begin
    result = eval(input).inspect
  rescue Exception => e
    result = "Error: #{e.class} - #{e.message}"
  end

  result
end

