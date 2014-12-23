require 'socket'
require_relative './router'
require_relative './client'
require_relative './response'
require_relative './request'
require_relative './user'

class Server
  def initialize(port)
    @port = port
    @router = Router.new
  end

  def start
    server = TCPServer.new "localhost", @port
    loop do
      client = Client.new(server.accept)
      request = Request.new(client.request)
      response = route(request)
      client.puts(response)
      client.close
    end
  end

  def route(request)
    response = @router.execute(request, User.all)
    response.headers + "\n" + response.body
  end
end
