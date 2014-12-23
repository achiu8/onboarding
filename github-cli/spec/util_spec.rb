require_relative '../src/util'
require_relative '../src/user'
require_relative '../src/repo'

describe Util do
  let(:username) { "username" }
  let(:reponame) { "reponame" }
  let(:user_json) { { "name" => "test", "foo" => "bar" } }
  let(:repo_json) { { "owner" => { "login" => "foo" }, "name" => "bar" } }

  context "when valid request" do
    it "hits the correct user info endpoint" do
      user_endpoint = "/users/#{username}"
      allow(Util).to receive(:get_response).and_return(user_json)
      User.find(username)
      expect(Util).to have_received(:get_response).with(user_endpoint)
    end

    it "hits the correct repo info endpoint" do
      repo_endpoint = "/repos/#{username}/#{reponame}"
      allow(Util).to receive(:get_response).and_return(repo_json)
      Repo.find(username, reponame)
      expect(Util).to have_received(:get_response).with(repo_endpoint)
    end

    it "returns a json object" do
      http_response = double(:code => "200", :body => user_json.to_json)
      allow(Net::HTTP).to receive(:start).and_return(http_response)
      user_endpoint = "/users/#{username}"
      response = Util.get_response(user_endpoint)
      expect(response).to eq(user_json)
    end
  end

  context "when invalid request" do
    it "returns nil" do
      http_response = double(:code => "404")
      allow(Net::HTTP).to receive(:start).and_return(http_response)
      user_endpoint = "/users/#{username}"
      response = Util.get_response(user_endpoint)
      expect(response).to be_nil
    end
  end
end
