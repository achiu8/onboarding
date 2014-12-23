require_relative '../request'
require 'cgi'

describe Request do
  it "should parse out the method from the request" do
    request = Request.new({ :headers => ["GET /test HTTP/1.1"] })
    expect(request.method).to eq("GET")
  end

  it "should parse out the resource from the request" do
    request = Request.new({ :headers => ["GET /test HTTP/1.1"] })
    expect(request.resource).to eq("/test")
  end

  it "should parse out the query params from the request" do
    request = Request.new({ :headers => ["GET /test?foo=bar HTTP/1.1"] })
    expect(request.params["foo"]).to eq("bar")
  end

  it "should parse out headers into hash" do
    request = Request.new({
      :headers => [
        "GET /test HTTP/1.1",
        "Host: test",
        "Foo: bar"
      ]
    })
    expect(request.headers).to eq({ "Host" => "test", "Foo" => "bar" })
  end

  it "should parse out cookie value" do
    user = "andy"
    request = Request.new({
      :headers => ["GET /test HTTP/1.1", "Cookie: username=#{user}"]
    })
    expect(request.cookie).to eq(user)
  end

  it "should parse out form data from the request" do
    body = "foo=bar"
    request = Request.new({
      :headers => ["POST /test HTTP/1.1", "Content-Length: #{body.bytesize}"],
      :body => body
    })
    expect(request.data).to eq({ "foo" => "bar" })
  end

  it "should decode URL encoded values" do
    body = "username=foobar&password=%261234%26"
    input = {
      :headers => ["POST /test HTTP/1.1", "Content-Length: #{body.bytesize}"],
      :body => body
    }
    request = Request.new(input)
    creds = request.parse_query_string(input[:body])
    expect(creds["password"]).to eq(CGI.escapeHTML("&1234&"))
  end
end
