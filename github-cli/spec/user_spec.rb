require_relative '../src/util'
require_relative '../src/user'

describe User do
  let(:name) { "name" }
  let(:json) { { "login" => name, "foo" => "bar" } }
  let(:repos) { [repo_json, repo_json] }
  let(:repo_json) { { "owner" => { "login" => "foo" }, "name" => "bar", "watchers_count" => 0 } }

  describe ".find" do
    context "given valid username" do
      it "returns a User object" do
        allow(Util).to receive(:get_response).and_return(json)
        user = User.find(name)
        expect(user).to be_a User
      end

      it "hits the correct endpoint" do
        user_endpoint = "/users/#{name}"
        allow(Util).to receive(:get_response).and_return(json)
        User.find(name)
        expect(Util).to have_received(:get_response).with(user_endpoint)
      end

      it "makes only one request to the api upon creation" do
        allow(Util).to receive(:get_response).and_return(json)
        User.find(name)
        expect(Util).to have_received(:get_response).once
      end
    end
    
    context "given invalid username" do
      it "returns nil" do
        allow(Util).to receive(:get_response).and_return(nil)
        user = User.find(name)
        expect(user).to be_nil
      end
    end
  end

  describe "#create_methods" do
    it "creates methods for all properties" do
      allow(Util).to receive(:get_response).and_return(json)
      user = User.find(name)
      json.keys.each do |prop|
        expect(user).to respond_to(prop.to_sym)
      end
    end

    it "creates methods that respond with original property values" do
      allow(Util).to receive(:get_response).and_return(json)
      user = User.find(name)
      json.each do |prop, value|
        expect(user.send(prop.to_sym)).to eq(value)
      end
    end
  end

  describe "#repos" do
    it "returns all of a user's repos" do
      allow(User).to receive(:find).and_return(User.new(json))
      allow(Util).to receive(:get_response).and_return(repos)
      allow(Repo).to receive(:find).and_return(Repo.new(repo_json))
      user = User.find(name)
      user_repos = user.repos
      expect(user_repos.count).to eq(repos.count)
    end
  end

  describe "#get_user_repos" do
    it "returns an array of Repo objects" do
      allow(User).to receive(:find).and_return(User.new(json))
      allow(Util).to receive(:get_response).and_return(repos)
      allow(Repo).to receive(:find).and_return(Repo.new(repo_json))
      user = User.find(name)
      user_repos = user.repos
      expect(user_repos[0]).to be_a Repo
    end
  end
end
