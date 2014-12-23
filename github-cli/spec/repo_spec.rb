require_relative '../src/util'
require_relative '../src/repo'

describe Repo do
  let(:username) { "username" }
  let(:reponame) { "reponame" }
  let(:json) { { "owner" => { "login" => "foo" }, "name" => "bar" } }
  let(:events) { [{ "type" => "type1" }, { "type" => "type2" }] }

  describe ".find" do
    context "given valid username and reponame" do
      it "returns a Repo object" do
        allow(Util).to receive(:get_response).and_return(json)
        repo = Repo.find(username, reponame)
        expect(repo).to be_a Repo
      end

      it "hits the correct endpoint" do
        repo_endpoint = "/repos/#{username}/#{reponame}"
        allow(Util).to receive(:get_response).and_return(json)
        Repo.find(username, reponame)
        expect(Util).to have_received(:get_response).with(repo_endpoint)
      end

      it "makes only one request to the api upon creation" do
        allow(Util).to receive(:get_response).and_return(json)
        Repo.find(username, reponame)
        expect(Util).to have_received(:get_response).once
      end
    end
  
    context "given invalid reponame" do
      it "returns nil" do
        allow(Util).to receive(:get_response).and_return(nil)
        repo = Repo.find(username, reponame)
        expect(repo).to be_nil
      end
    end

  end

  describe "#create_methods" do
    it "creates methods for all properties" do
      allow(Util).to receive(:get_response).and_return(json)
      repo = Repo.find(username, reponame)
      json.keys.each do |prop|
        expect(repo).to respond_to(prop.to_sym)
      end
    end

    it "creates methods that respond with original property values" do
      allow(Util).to receive(:get_response).and_return(json)
      repo = Repo.find(username, reponame)
      json.each do |prop, value|
        expect(repo.send(prop.to_sym)).to eq(value)
      end
    end
  end

  describe "#events" do
    it "returns all of a repo's events" do
      allow_any_instance_of(Repo).to receive(:get_repo_events).and_return(events)
      allow(Util).to receive(:get_response).and_return(json)
      repo = Repo.find(username, reponame)
      expect(repo.events).to eq(events.reverse)
      expect(repo.events.first["type"]).to eq("type2")
    end
  end
end
