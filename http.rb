require 'cgi'
require 'socket'
require 'date'

# TODO:
# * Have requests parse parameters (form and json format)
# * Create route handler creators for all request methods
# * Let user expose files/paths

# HTTPHeader superclass
# Provides the basis of HTTP headers which both requests
# and responses share
class HTTPHeader

  attr_accessor :headers, :body, :parameters

  # Create a new header, optionally taking a body and some headers
  # @param first_line [String] the top first of the header
  # @param body [String] the body of the request
  # @param headers [Hash] http headers keys and values
  # @return [HTTPHeader]

  def initialize(first_line, body="", headers={}, parameters={})
    @headers=headers
    @first_line = first_line
    @body = body
    @parameters = parameters
  end

  # Generates a full HTML body string
  # @return [String] returns a full as a string
  def body
    headers = auto_headers.merge(@headers)
    @first_line + "\n" + headers.keys.map do |key|
      "#{key}: #{headers[key]}"
    end.join("\n") + "\n\n" + @body
  end

  # Autogenerated headers which can be overwritten by user
  # headers
  # @return [Hash]
  private def auto_headers
    {
      "Content-Length" => @body.length.to_s,
      "Date" => Time.now.to_datetime.httpdate,
    }
  end
end

# Represents an incoming HTTP request
class HTTPRequest < HTTPHeader

  attr_accessor :method, :path

  # Create a new request, optionally taking a body and some headers
  # @param method [String] request method, e.g GET or POST
  # @param path [String] path to requested resource
  # @param body [String] the body of the request
  # @param headers [Hash] http headers keys and values
  # @return [HTTPRequest]
  def initialize(method, path, body="", headers={}, parameters={})
    @method = method
    @path = path
    super("#{method} #{path} HTTP/1.1", body, headers, parameters)
  end

  # Create a new request by reading from a file or socket connection
  # @param file [IO] IO object to read request from (probably a socket)
  # @return [HTTPRequest]
  def self.read(file)
    lines = []
    line = file.gets
    line.chomp! unless line.nil?
    until line.nil? || line.empty?
      lines << line
      line = file.gets
      line.chomp! unless line.nil?
    end

    method = lines[0].split[0]
    path = lines[0].split[1]

    headers = {}
    index = nil
    body = ""
    lines[1..].each do |line|
      pair = line.split.map { |l| l.split(":") }
      headers.merge! pair[0] => pair[1]
    end

    unless headers["Content-Length"].nil?
      body = client.read(headers["Content-Length"].to_i)
    end

    HTTPRequest.new(method, path, body, headers)
  end
end

# to_HTTPStatus added for integer class 
class Integer
  # returns a HTTP status string
  # @return [String]
  def to_HTTPStatus
  {
    100 => '100 Continue',
    101 => '101 Switching protocols',
    102 => '102 Processing',
    103 => '103 Early Hints',
    200 => '200 OK',
    201 => '201 Created',
    202 => '202 Accepted',
    203 => '203 Non-Authorative Infromation',
    204 => '204 No Content',
    205 => '205 Reset Content',
    206 => '206 Partial Content',
    207 => '207 Multi-Status',
    208 => '208 Already Reported',
    226 => '226 IM Used',
    300 => '300 Multiple Choices',
    301 => '301 Moved Permanently',
    302 => '302 Found',
    303 => '303 See Other',
    304 => '304 Not Modified',
    305 => '305 Use Proxy',
    306 => '306 Switch Proxy',
    307 => '307 Temporary Redirect',
    308 => '308 Permanent Redirect',
    400 => '400 Bad Request',
    401 => '401 Unauthorized',
    402 => '402 Payment Required',
    403 => '403 Forbidden',
    404 => '404 Not Found',
    405 => '405 Method Not Allowed',
    406 => '406 Not Acceptable',
    407 => '407 Proxy Authentication Required',
    408 => '408 Request Timeout',
    409 => '409 Conflict',
    410 => '410 Gone',
    412 => '412 Precondition Failed',
    413 => '413 Payload Too Large',
    414 => '414 URI Too Long',
    415 => '415 Unsupported Media Type',
    416 => '416 Range Not Satisfiable',
    417 => '417 Expectation Failed',
    418 => "418 I'm a teapot",
    421 => '421 Misdirected Request',
    422 => '422 Unprocessable Entity',
    423 => '423 Locked',
    424 => '424 Failed Dependency',
    425 => '425 Too Early',
    426 => '426 Upgrade Required',
    428 => '428 Precondition Required',
    429 => '429 Too Many Requests',
    431 => '431 Request Header Fields Too Large',
    451 => '451 Unavailable For Legal Reasons',
    500 => '500 Internal Server Error',
    501 => '501 Not Implemented',
    502 => '502 Bad Gateway',
    503 => '503 Service Unavailable',
    504 => '504 Gateway Timeout',
    505 => '505 HTTP Version Not Supported',
    506 => '506 Variant Also Negotiates',
    507 => '507 Insufficient Storage',
    508 => '508 Loop Detected',
    510 => '510 Not Extended',
    511 => '511 Network Authentication Required',
  }.freeze[self]
  end
end

# Represents an HTTP response to be sent to clients
class HTTPResponse < HTTPHeader
  attr_reader :code

  # Create a new request, optionally taking a body and some headers
  # @param code [Integer] response code, e.g 200 or 404
  # @param body [String] the body of the request
  # @param headers [Hash] http headers keys and values
  # @return [HTTPRequest]
  def initialize(code, body="", headers={}, parameters={})
    @code = code
    super("HTTP/1.1 #{code.to_HTTPStatus}", body, headers, parameters)
  end

  # Overloaded autoheaders
  # @return [Hash]
  private def auto_headers
    {
      "Content-Length" => @body.length.to_s,
      "Date" => Time.now.to_datetime.httpdate,
      "Last-Modified" => Time.now.to_datetime.httpdate,
      "Content-Type" => "text/html; charset=utf-8",
    }
  end
end

# Superclass which represents a handler for a request
class HTTPHandler
  # Constructs a HTTPHandler object
  # @yield code block responsible for returning content as a string
  def initialize(&handler)
    @handler = handler
  end

  # Calls the handler with information about the request
  # @param request_info [HTTPRequest] information to pass to the block
  def handle request_info
	@handler.call request_info
  end
end

# Class which represents a handler for a http route/resource
class HTTPRoute < HTTPHandler
  attr_reader :method, :path
  # Constructs a HTTPRoute object
  # @param method [String] the expected method
  # @param path [String,Regex] the accepted path, just needs to respond to .matches?
  # @yield code block responsible for returning content as a string
  # @return [HTTPRoute]
  def initialize(method, path, &handler)
    @method = method
    @path = path
    super(&handler)
  end
end

# A class which represents a handler for a http error
class HTTPErrorRoute < HTTPHandler
  attr_reader :code
  # Constructs a HTTPErrorRoute object
  # @param method [String] the expected method
  # @param path [String,Regex] the accepted path, just needs to respond to .matches?
  # @yield code block responsible for returning content as a string
  # @return [HTTPRoute]
  def initialize(code, &handler)
    @code = code
    super(&handler)
  end
end

# Represents a server
class HTTPServer
  # Construct a HTTPServer object
  # @param port [Integer] port to listen on
  # @param host [String] host to listen on
  # @param log [Bool] if true server will print informative messages to stderr
  # @param server_name [String] server name to be used in error pages etc
  def initialize(port=8080, host="localhost", log=true, server_name="HTTPServer")
    @host = host
    @port = port
    @log = log
    @routes = []
    @error_routes = []
    @running = true # not running yet, but needed to make launching work
  end

  # Register a HTTPRoute for GET requests
  # @param path [String, Regex] path to match (just needs to respond to matches?)
  # @yield block responsible for generating html
  def get(path, &block)
    @routes << HTTPRoute.new("GET", path, &block) 
  end

  # Register a HTTPRoute for POST requests
  # @param path [String, Regex] path to match (just needs to respond to matches?)
  # @yield block responsible for generating html
  def post(path, &block)
    @routes << HTTPRoute.new("POST", path, &block)
  end

  # Register a HTTPErrorRoute
  # @param code [Integer] error code to cover
  # @yield block responsible for generating html
  def error(code, &block)
    @error_routes << HTTPErrorRoute.new(code, &block)
  end

  # Start the webserver and begin handling connections
  def launch
    STDERR.puts "Now listening on #{@host}:#{@port}!" if @log
    server = TCPServer.new @host, @port
    while @running
      client = server.accept

      request = HTTPRequest.read client
      STDERR.puts "#{request.method} request for resource '#{request.path}'." if @log

      response = handle request
      STDERR.puts "=> #{response.code}." if @log

      client.write(response.body)
      client.close

    end
  end

  # escape an html string
  # @param str [String] string to escape
  # @@return [String] escaped string
  def escape_html str
    CGI::escapeHTML str
  end

  # Stop the webserver
  def abort
    STDERR.puts "Stopping webserver" if @log
    @running = false
  end

  # Handle a request
  # @param request [HTTPRequest] request to handle
  # @return [String] response body as a string
  private def handle(request)

    routes = @routes.select do |route| 
      route.path.match?(request.path) && route.method == request.method
    end

    return handle_error(request, 404) if routes.empty?

    HTTPResponse.new(200, (routes.first.handle request))

  end

  # Handle an error
  # @param request [HTTPRequest] request which raised error
  # @return [String] response body as a string
  private def handle_error(request, code)

    routes = @error_routes.select do |route| 
      route.code == code
    end

    return default_error(code) if routes.empty?

    response = HTTPResponse.new(code, (routes.first.handle request))

  end

  # Return HTML code for given error
  # @param error [Integer] error code
  private def default_error(code)
    HTTPResponse.new(code, "<h1>Error #{code.to_HTTPStatus}<h1><hr><i>#{@server_name}</i>")
  end

end
