require_relative 'http.rb'

server = HTTPServer.new

server.get "/" do
  "<h1>Hi!</h1>"
end

server.get "/hi" do
  "<h1>Hello!</h1>"
end


server.get "/stop" do
  server.abort
  ""
end

server.error 404 do |r|
  "<h1>The resource '#{r.path}' does not exist</h1>"
end

server.launch
