require_relative '../src/app'

describe App do
  let(:user) { double(:repos => nil) }
  let(:repo) { double(:events => nil) }
  let(:username) { "foo" }
  let(:reponame) { "bar" }

  before do
    allow(View).to receive(:display_error).and_return(nil)
    allow(View).to receive(:display_user_repos).and_return(nil)
    allow(View).to receive(:display_repo_feed).and_return(nil)
  end

  context "when given valid username and no reponame" do
    it "creates new User object" do
      allow(User).to receive(:new).and_return(nil)
      App.run(username)
      expect(User).to have_received(:new)
    end

    it "fetches user's repos" do
      allow(User).to receive(:find).and_return(user)
      allow(user).to receive(:repos).and_return(nil)
      App.run(username)
      expect(user).to have_received(:repos)
    end
    
    it "displays user repos output" do
      allow(User).to receive(:find).and_return(user)
      App.run(username)
      expect(View).to have_received(:display_user_repos)
    end
  end

  context "when given invalid username and no reponame" do
    it "displays error message" do
      allow(User).to receive(:find).and_return(nil)
      App.run(username)
      expect(View).to have_received(:display_error)
    end
  end

  context "when given valid username and reponame" do
    it "creates new User object" do
      allow(User).to receive(:new).and_return(nil)
      App.run(username, reponame)
      expect(User).to have_received(:new)
    end

    it "creates new Repo object" do
      allow(User).to receive(:new).and_return(user)
      allow(Repo).to receive(:find).and_return(repo)
      App.run(username, reponame)
      expect(Repo).to have_received(:find)
    end

    it "fetches repo's events" do
      allow(User).to receive(:find).and_return(user)
      allow(Repo).to receive(:find).and_return(repo)
      allow(repo).to receive(:events).and_return(nil)
      App.run(username, reponame)
      expect(repo).to have_received(:events)
    end
    
    it "displays repo feed output" do
      allow(User).to receive(:find).and_return(user)
      allow(Repo).to receive(:find).and_return(repo)
      allow(repo).to receive(:events).and_return(nil)
      App.run(username, reponame)
      expect(View).to have_received(:display_repo_feed)
    end
  end

  context "when given invalid username and reponame" do
    it "displays error message" do
      allow(User).to receive(:find).and_return(nil)
      App.run(username, reponame)
      expect(View).to have_received(:display_error)
    end
  end

  context "when given no arguments" do
    it "displays error message" do
      App.run
      expect(View).to have_received(:display_error)
    end
  end
end
