require 'benchmark'

class Integer
  def to_HASHHTTPStatus
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

  def to_ARRAYHTTPStatus
    arr = []
    arr[100] = '100 Continue'
    arr[101] = '101 Switching protocols'
    arr[102] = '102 Processing'
    arr[103] = '103 Early Hints'
    arr[200] = '200 OK'
    arr[201] = '201 Created'
    arr[202] = '202 Accepted'
    arr[203] = '203 Non-Authorative Infromation'
    arr[204] = '204 No Content'
    arr[205] = '205 Reset Content'
    arr[206] = '206 Partial Content'
    arr[207] = '207 Multi-Status'
    arr[208] = '208 Already Reported'
    arr[226] = '226 IM Used'
    arr[300] = '300 Multiple Choices'
    arr[301] = '301 Moved Permanently'
    arr[302] = '302 Found'
    arr[303] = '303 See Other'
    arr[304] = '304 Not Modified'
    arr[305] = '305 Use Proxy'
    arr[306] = '306 Switch Proxy'
    arr[307] = '307 Temporary Redirect'
    arr[308] = '308 Permanent Redirect'
    arr[400] = '400 Bad Request'
    arr[401] = '401 Unauthorized'
    arr[402] = '402 Payment Required'
    arr[403] = '403 Forbidden'
    arr[404] = '404 Not Found'
    arr[405] = '405 Method Not Allowed'
    arr[406] = '406 Not Acceptable'
    arr[407] = '407 Proxy Authentication Required'
    arr[408] = '408 Request Timeout'
    arr[409] = '409 Conflict'
    arr[410] = '410 Gone'
    arr[412] = '412 Precondition Failed'
    arr[413] = '413 Payload Too Large'
    arr[414] = '414 URI Too Long'
    arr[415] = '415 Unsupported Media Type'
    arr[416] = '416 Range Not Satisfiable'
    arr[417] = '417 Expectation Failed'
    arr[418] = "418 I'm a teapot"
    arr[421] = '421 Misdirected Request'
    arr[422] = '422 Unprocessable Entity'
    arr[423] = '423 Locked'
    arr[424] = '424 Failed Dependency'
    arr[425] = '425 Too Early'
    arr[426] = '426 Upgrade Required'
    arr[428] = '428 Precondition Required'
    arr[429] = '429 Too Many Requests'
    arr[431] = '431 Request Header Fields Too Large'
    arr[451] = '451 Unavailable For Legal Reasons'
    arr[500] = '500 Internal Server Error'
    arr[501] = '501 Not Implemented'
    arr[502] = '502 Bad Gateway'
    arr[503] = '503 Service Unavailable'
    arr[504] = '504 Gateway Timeout'
    arr[505] = '505 HTTP Version Not Supported'
    arr[506] = '506 Variant Also Negotiates'
    arr[507] = '507 Insufficient Storage'
    arr[508] = '508 Loop Detected'
    arr[510] = '510 Not Extended'
    arr[511] = '511 Network Authentication Required'
    arr.freeze
    arr[self]
  end
end

Benchmark.bm do |x|
  x.report('array') { 1000.times { 400.to_ARRAYHTTPStatus } }
  x.report('hash') { 100.times { 400.to_HASHHTTPStatus } }
end
