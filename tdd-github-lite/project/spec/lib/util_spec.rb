require 'rails_helper'

describe Util do
  let(:username) { "username" }
  let(:reponame) { "reponame" }
  let(:json) { { "name" => "test", "foo" => "bar" } }

  it "should have a valid token" do
    uri = URI(Util.api_root + "/user")
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "token #{Util.token}"
    res = Net::HTTP.start(uri.hostname,
                          uri.port,
                          :use_ssl => uri.scheme == "https") do |http|
      http.request(req)
    end
    expect(res.code).to eq("200")
  end

  it "should hit the correct user info endpoint" do
    user_endpoint = "/users/#{username}"
    expect(Util).to receive(:get_response).with(user_endpoint).and_return(json)
    User.find(username)
  end

  it "should hit the correct repo info endpoint" do
    repo_endpoint = "/repos/#{username}/#{reponame}"
    expect(Util).to receive(:get_response).with(repo_endpoint).and_return(json)
    Repo.new(username, reponame)
  end
end
