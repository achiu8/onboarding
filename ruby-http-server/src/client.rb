class Client
  attr_reader :client, :request

  def initialize(client)
    @client = client
    @request = { :headers => [], :body => nil }
    build_request
  end

  def build_request
    line = ""
    has_body = false
    content_length = 0
    while line != "\r\n"
      line = @client.gets
      if line.include?("Content-Length")
        has_body = true
        content_length = line.split(": ")[1].chomp.to_i
      end
      @request[:headers] << line.chomp
    end

    @request[:headers].pop
    @request[:body] = @client.read(content_length) if has_body
  end

  def puts(content)
    @client.puts(content)
  end

  def close
    @client.close
  end
end
