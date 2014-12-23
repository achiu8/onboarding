require 'rails_helper'

describe Repo do
  let(:username) { "username" }
  let(:reponame) { "reponame" }
  let(:json) { { "name" => "test", "foo" => "bar" } }
  let(:events) { [{ "type" => "type1" }, { "type" => "type2" }] }

  it "should create methods for all properties" do
    allow(Util).to receive(:get_response).and_return(json)
    repo = Repo.new(username, reponame)
    json.keys.each do |prop|
      expect(repo).to respond_to(prop.to_sym)
    end
  end

  it "should respond with original property values" do
    allow(Util).to receive(:get_response).and_return(json)
    repo = Repo.new(username, reponame)
    json.each do |prop, value|
      expect(repo.send(prop.to_sym)).to eq(value)
    end
  end

  it "should be able to get, store, and access repo events" do
    allow_any_instance_of(Repo).to receive(:get_repo_events).and_return(events)
    allow(Util).to receive(:get_response).and_return(json)
    repo = Repo.new(username, reponame)
    expect(repo.events).to eq(events)
    expect(repo.events.first["type"]).to eq("type1")
  end

  it "should hit the correct endpoint" do
    repo_endpoint = "/repos/#{username}/#{reponame}"
    expect(Util).to receive(:get_response).with(repo_endpoint).and_return(json)
    Repo.new(username, reponame)
  end

  it "should only make one request to the api upon creation" do
    expect(Util).to receive(:get_response).once.and_return(json)
    Repo.new(username, reponame)
  end
end
