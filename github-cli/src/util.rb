require 'net/http'
require 'uri'
require 'openssl'
require 'json'

module Util
  TOKEN = "da5119967a79608ae8946325e20be579c8b29bd5"
  ROOT = "https://api.github.com"

  def self.get_response(endpoint)
    uri = URI(ROOT + endpoint)
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "token #{TOKEN}"
    res = Net::HTTP.start(uri.hostname,
                          uri.port,
                          :use_ssl => uri.scheme == "https") do |http|
      http.request(req)
    end
    JSON.parse(res.body) if res.code == "200"
  end
end
