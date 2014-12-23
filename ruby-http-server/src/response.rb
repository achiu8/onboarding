require 'json'
require 'securerandom'

class Response
  attr_reader :status

  def initialize(opts)
    @resource = build_resource(opts.fetch(:resource, ""))
    @params = opts.fetch(:params, {})
    @user = opts.fetch(:user, nil)
    @status = opts.fetch(:status, status_code)
    @redirect = opts.fetch(:redirect, nil)
    @content_type = opts.fetch(:content_type, "text/html")
  end

  def build_resource(resource)
    "./views#{resource}.html"
  end

  def status_code
    File.exists?(@resource) ? 200 : 404
  end

  def status_message(status)
    case status
    when 200 then "OK"
    when 303 then "See Other"
    when 404 then "Not Found"
    end
  end

  def headers
    [
      "HTTP/1.1 #{@status} #{status_message(@status)}",
      "Location: #{@redirect}",
      "Server: My Server",
      "Content-Type: #{@content_type}; charset=UTF-8",
      "Content-Length: #{content_length}",
      "Set-Cookie: session=#{ set_session }",
      "Connection: close",
      ""
    ].join("\n")
  end
  
  def body
    case @content_type
    when "application/json"
      @params.to_json
    else
      body = fetch_page
      unless @params.empty?
        @params.each { |param, value| body.gsub!("{{#{param}}}", value.to_s) }
      else
        body.gsub!("{{user}}", "World")
      end
      body = display_users(body) if @resource == "./views/welcome.html"
      body
    end
  end

  def fetch_page
    case @status
    when 200 then File.read(@resource)
    when 404 then File.read("./views/404.html")
    else ""
    end
  end

  def display_users(body)
    users = User.all.map(&:first)
    users_list = users.map { |user| "<li>#{user}</li>" }.join("\n")
    body.gsub("{{users}}", users_list)
  end

  def content_length
    body.bytesize
  end

  def set_session
    User.all[@user] ? User.all[@user]["session"] : SecureRandom.hex
  end
end
