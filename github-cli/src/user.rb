require_relative 'util'
require_relative 'repo'

class User
  def self.find(username)
    endpoint = "/users/#{username}"
    data = Util.get_response(endpoint)
    self.new(data) if data
  end

  def initialize(data)
    @username = data["login"]
    @data = data
    create_methods
  end

  def repos
    @repos ||= get_user_repos(@username).sort_by(&:watchers_count).reverse
  end

  def create_methods
    @data.keys.each do |prop|
      self.class.send(:define_method, prop) { @data[prop] }
    end
  end

  def get_user_repos(username)
    endpoint = "/users/#{username}/repos"
    repos = Util.get_response(endpoint)
    repos.map { |repo| Repo.find(username, repo["name"]) }
  end
end
