class Activity
  attr_reader :number, :title, :reponame, :status

  def initialize(args)
    @number = args.fetch("number", 0)
    @title = args.fetch("title", "")
    @reponame = args.fetch("reponame", "")
    @status = args["merged_at"] ? "Merged" : "Proposed"
  end
end
