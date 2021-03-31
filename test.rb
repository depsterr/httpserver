require_relative 'http.rb'
require 'pp'

server = HTTPServer.new

server.get "/" do |r|
%Q[<pre><code>Method: #{r.method}
Path: #{r.path}
Params: #{r.parameters}
Headers: #{r.headers}</pre></code>

<form action="/submit" method="post">
  <label for="username">username</label>
  <input type="text" name="username"><br>
  <label for="password">password</label>
  <input type="password" name="password"><br>
  <input type="submit" value="Give me your credentials :)">
</form>]
end

server.post "/submit" do |r|
%Q[<p>username: #{r.parameters["username"]}<br>
password: #{r.parameters["password"]}</p>]
end

server.get "/stop" do
  server.abort
  ""
end

server.error 404 do |r|
  "<h1>The resource '#{r.path}' does not exist</h1>"
end

server.launch
