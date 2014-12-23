class User
  def self.find(username)
    self.new(username)
  end

  def self.current
    endpoint = "/user"
    Util.get_response(endpoint)["login"]
  end

  def initialize(username)
    @username = username
    @info = get_user_info(@username)
    create_methods
  end

  def repos
    @repos ||= get_user_repos(@username)
  end

  def activities
    @activities ||= get_user_activities(@username)
  end

  def create_methods
    @info.keys.each do |prop|
      self.class.send(:define_method, prop) { @info[prop] }
    end
  end

  def get_user_info(username)
    endpoint = "/users/#{username}"
    Util.get_response(endpoint)
  end

  def get_user_repos(username)
    endpoint = "/users/#{username}/repos"
    res = Util.get_response(endpoint)
    repos = res.map { |repo| repo["name"] }
    repos.map { |repo| Repo.new(username, repo) }
  end

  def get_user_activities(username)
    endpoint = "/users/#{username}/events/public"
    res = Util.get_response(endpoint).select do |activity|
      activity["type"] == "PullRequestEvent"
    end

    res.map do |activity|
      Activity.new({
        "number" => activity["payload"]["pull_request"]["number"],
        "title" => activity["payload"]["pull_request"]["title"],
        "reponame" => activity["repo"]["name"],
        "merged_at" => activity["payload"]["merged_at"]
      })
    end
  end
end
