HTTPServer
==========
HTTPServer is a simple yet powerful webserver framework for ruby.

Background
----------
HTTPServer was initially created to fufill the need of a temporary webserver which could be used for a login api with callbacks. This was hard to achieve with existing webbrick based webservers as they do not only spew output but also are painful to stop. HTTPServer solves this by being simple, optionally letting the user mute all output and having a simple `abort` method, callable by routes.

The api which prompted the creation of this project in the first place was the github api. As it's oath login method mandates the usage of a local webserver.

Project structure
-----------------
Currently the `http.rb` file contains the entire library and `test.rb` is used for testing. Once the project is more mature it should be defined as a gem.

Depends
-------
At the time of writing the project only depends on the ruby standard libraries.

Example Usage
-------------
Here is a simple example of how http.rb could be used

```rb
require_relative 'http.rb'

server = HTTPServer.new 80, 0.0.0.0

server.expose "resources/images", "/img"

server.get "/" do
%Q[<form action="/search" method="get">
  <label for="query">query</label>
  <input type="text" name="query"><br>
  <input type="submit" value="search">
</form>]
end

server.get "/search" do |r|
%Q["<h1>Search results for '#{r.parameters['query']}'</h1>"]
end
```
