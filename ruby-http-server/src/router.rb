require_relative './response'
require 'securerandom'

class Router
  attr_reader :routes

  def initialize
    @routes = { "GET" => {}, "POST" => {} }
    config
  end

  def get(resource, &block)
    @routes["GET"][resource] = { "action" => block, "before" => increment_visits }
  end

  def post(resource, &block)
    @routes["POST"][resource] = { "action" => block }
  end

  def increment_visits
    Proc.new do |request, users|
      user = get_user(request.cookie, users)
      users[user]["visits"] += 1 if user
    end
  end

  def execute(request, users)
    route = @routes[request.method][request.resource]
    if route
      route["before"].call(request, users) if route["before"]
      route["action"].call(request, users)
    else
      not_found
    end
  end

  def config
    get "/welcome" do |request, users|
      user = get_user(request.cookie, users)
      generate_response({
        :resource => "/welcome",
        :params => user ? { "user" => user } : {},
        :user => user
      })
    end

    get "/profile" do |request, users|
      user = get_user(request.cookie, users)
      if user
        generate_response({
          :resource => "/profile",
          :params => { "user" => user },
          :user => user
        })
      else
        redirect("/login", request.params, user)
      end
    end

    get "/visit" do |request, users, user|
      user = user || get_user(request.cookie, users)
      generate_response({
        :resource => "/visit",
        :params => { "visits" => users[user] ? users[user]["visits"].to_s : "0" },
        :user => user
      })
    end

    get "/login" do |request, users|
      user = get_user(request.cookie, users)
      if user
        redirect("/welcome", request.params, user)
      else
        generate_response({
          :resource => "/login",
          :params => request.params,
          :user => user
        })
      end
    end

    post "/login" do |request, users|
      user = authenticate(request, users)

      if user
        redirect("/visit", request.params, user)
      else
        redirect("/login", request.params, user)
      end
    end

    get "/logout" do |request, users|
      generate_response({
        :resource => "/welcome",
        :params => request.params,
        :user => nil
      })
    end

    get "/register" do |request, users|
      user = get_user(request.cookie, users)
      if user
        redirect("/profile", request.params, user)
      else
        generate_response({
          :resource => "/register",
          :params => request.params,
          :user => user
        })
      end
    end

    post "/register" do |request, users|
      user = request.data["username"]
      pass = request.data["password"]
      User.new(user, pass)

      redirect("/welcome", request.params, user)
    end

    get "/api/visits" do |request, users|
      user = request.params["user"]
      accept = request.headers["Accept"]
      content_type = accept == "*/*" ? "text/html" : accept

      if users.keys.include?(user)
        count = users[user]["visits"]
        data = { "user" => user, "count" => count }
        generate_response({
          :resource => "/api/visits",
          :params => data,
          :user => user,
          :content_type => content_type
        })
      else
        not_found(content_type)
      end
    end
  end

  def generate_response(opts)
    Response.new(opts)
  end

  def not_found(content_type = "text/html")
    generate_response({
      :status => 404,
      :params => { "message" => "not found" },
      :content_type => content_type
    })
  end

  def redirect(resource, params, user)
    generate_response({
      :params => params,
      :status => 303,
      :redirect => resource,
      :user => user
    })
  end

  def authenticate(request, users)
    user = request.data["username"]
    pass = request.data["password"]

    if users.key?(user)
      if pass == users[user]["pass"]
        users[user]["session"] = SecureRandom.hex
        user
      else
        nil
      end
    else
      nil
    end
  end

  def get_user(session, users)
    users.keys.find { |user| users[user]["session"] == session }
  end
end
