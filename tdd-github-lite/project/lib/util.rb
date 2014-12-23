require 'net/http'
require 'uri'
require 'json'

module Util
  def self.token
    "da5119967a79608ae8946325e20be579c8b29bd5"
  end

  def self.api_root
    "https://api.github.com"
  end

  def self.get_response(endpoint)
    uri = URI(api_root + endpoint)
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "token #{token}"
    res = Net::HTTP.start(uri.hostname,
                          uri.port,
                          :use_ssl => uri.scheme == "https") do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  end

  def self.post(endpoint, data)
    uri = URI(api_root + endpoint)
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "token #{token}"
    req.set_form_data(data)
    res = Net::HTTP.start(uri.hostname,
                          uri.port,
                          :use_ssl => uri.scheme == "https") do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  end
end
