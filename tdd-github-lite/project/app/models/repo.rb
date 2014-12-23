class Repo
  attr_reader :username

  def initialize(username, reponame)
    @username = username
    @reponame = reponame
    @info = get_repo_info(username, reponame)
    create_methods
  end

  def events
    @events ||= get_repo_events(@username, @reponame)
  end

  def create_methods
    @info.keys.each do |prop|
      self.class.send(:define_method, prop) { @info[prop] }
    end
  end

  def get_repo_info(username, reponame)
    endpoint = "/repos/#{username}/#{reponame}"
    Util.get_response(endpoint)
  end

  def get_repo_events(username, reponame)
    endpoint = "/repos/#{username}/#{reponame}/events"
    Util.get_response(endpoint)
  end
end
