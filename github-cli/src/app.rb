require_relative 'user'
require_relative 'view'

module App
  def self.run(username = nil, reponame = nil)
    if username && !reponame
      user = User.find(username)
      if user
        repos = user.repos
        View.display_user_repos(user, repos)
      else
        View.display_error
      end
    elsif username && reponame
      user = User.find(username)
      if user
        repo = Repo.find(username, reponame)
        events = repo.events
        View.display_repo_feed(user, repo, events)
      else
        View.display_error
      end
    else
      View.display_error
    end
  end
end
