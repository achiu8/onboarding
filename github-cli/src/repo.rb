require_relative 'util'

class Repo
  def self.find(username, reponame)
    endpoint = "/repos/#{username}/#{reponame}"
    data = Util.get_response(endpoint)
    self.new(data) if data
  end

  def initialize(data)
    @username = data["owner"]["login"]
    @reponame = data["name"]
    @data = data
    create_methods
  end

  def events
    @events ||= get_repo_events(@username, @reponame).sort_by { |e| e['created_at'] }.reverse
  end

  def create_methods
    @data.keys.each do |prop|
      self.class.send(:define_method, prop) { @data[prop] }
    end
  end

  def get_repo_events(username, reponame)
    endpoint = "/repos/#{username}/#{reponame}/events"
    Util.get_response(endpoint)
  end
end
