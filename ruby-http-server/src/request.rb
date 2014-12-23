require 'cgi'

class Request
  attr_reader :request, :method, :resource, :data, :cookie

  def initialize(input)
    @headers = input[:headers]
    @request = @headers[0].split(" ")
    @method = request[0]
    @resource = request[1].split("?")[0]
    @data = input[:body] ? parse_query_string(input[:body]) : ""
    @cookie = parse_cookie if headers["Cookie"]
  end

  def params
    query = request[1].include?("?") ? request[1].split("?")[1] : ""
    parse_query_string(query)
  end

  def headers
    headers = @headers[1..-1]
    Hash[headers.collect { |header| header.split(": ") }]
  end

  def parse_query_string(string)
    pairs = string.split("&")
    Hash[pairs.collect { |pair| parse_and_decode_string_pair(pair) }]
  end

  def parse_and_decode_string_pair(string_pair)
    pair = string_pair.split("=")
    [ 
      CGI.escapeHTML(CGI.unescape(pair[0])),
      pair[1] ? CGI.escapeHTML(CGI.unescape(pair[1])) : ""
    ]
  end

  def parse_cookie
    headers["Cookie"].split("=")[1]
  end
end
