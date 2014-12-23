module View
  def self.display_user_repos(user, repos)
    print "\n"
    print "Name: #{user.name}\n"
    print "Location: #{user.location}\n"
    print "Public Repos: #{user.public_repos}\n\n"
    repos.each do |repo|
      print " * #{repo.name} (#{repo.watchers_count} watchers)\n"
    end
    print "\n"
  end

  def self.display_repo_feed(user, repo, events)
    print "\n"
    print "Name: #{user.name}\n"
    print "Location: #{user.location}\n"
    print "Repository: #{repo.name}\n"
    print "Events: #{events.count}\n\n"
    events.each do |event|
      action = event['type'][0..event['type'].index("Event") - 1]
      print " * #{action}ed by #{event['actor']['login']}\n"
    end
    print "\n"
  end

  def self.display_error
    print "Invalid arguments.\n"
  end
end
