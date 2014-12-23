require_relative '../client'

describe Client do
  it "should read and parse multiple line requests" do
    input = StringIO.new("GET /spec/test HTTP/1.1\r\nUser-Agent: test\r\n\r\n")
    client = Client.new(input)
    expect(client.request).to eq({
      :headers => ["GET /spec/test HTTP/1.1", "User-Agent: test"],
      :body => nil
    })
  end

  it "should recognize and parse post request form data" do
    input = StringIO.new(
      "POST /test HTTP/1.1\r\nContent-Length: 4\r\n\r\ntest")
    client = Client.new(input)
    expect(client.request[:body]).to eq("test")
  end

  it "should close stream" do
    input = StringIO.new("GET /spec/test HTTP/1.1\r\nUser-Agent: test\r\n\r\n")
    client = Client.new(input)
    client.close
    expect(client.client.closed?).to eq(true)
  end
end

