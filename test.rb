require_relative 'http.rb'
require 'pp'

server = HTTPServer.new

server.get "/" do |r|
  pp r
  "<pre><code>Method: #{r.method}
Path: #{r.path}
Params: #{r.parameters}
Headers: #{r.headers}</pre></code>"
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
