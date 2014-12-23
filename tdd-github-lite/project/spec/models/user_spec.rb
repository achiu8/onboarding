require 'rails_helper'

describe User do
  let(:name) { "name" }
  let(:json) { { "name" => "test", "foo" => "bar" } }
  let(:repos) { [{ "name" => "repo1" }, { "name" => "repo2" }] }
  let(:activities) do
    [
      { "type" => "PullRequestEvent" },
      { "type" => "PushEvent" },
      { "type" => "PullRequestEvent" }
    ]
  end

  describe "#initialize" do
    it "creates methods for all properties" do
      allow(Util).to receive(:get_response).and_return(json)
      user = User.find(name)
      json.keys.each do |prop|
        expect(user).to respond_to(prop.to_sym)
      end
    end

    it "responds with original property values" do
      allow(Util).to receive(:get_response).and_return(json)
      user = User.find(name)
      json.each do |prop, value|
        expect(user.send(prop.to_sym)).to eq(value)
      end
    end

    it "hits the correct endpoint" do
      user_endpoint = "/users/#{name}"
      expect(Util).to receive(:get_response).with(user_endpoint).and_return(json)
      User.find(name)
    end

    it "only makes one request to the api upon creation" do
      expect(Util).to receive(:get_response).once.and_return(json)
      User.find(name)
    end
  end

  describe "#get_user_repos" do
    it "is be able to get, store, and access user repos" do
      allow_any_instance_of(User).to receive(:get_user_repos).and_return(repos)
      allow(Util).to receive(:get_response).and_return(json)
      user = User.find(name)
      expect(user.repos).to eq(repos)
      expect(user.repos.first["name"]).to eq("repo1")
    end
  end

  describe "#get_user_activities" do
    it "is be able to get, store, and access user activities" do
      allow_any_instance_of(User).to receive(:get_user_activities).and_return(activities) 
      allow(Util).to receive(:get_response).and_return(json)
      user = User.find(name)
      expect(user.activities).to eq(activities)
    end
  end
  
  describe ".current" do
    it "returns the username of the authenticated user" do
      expect(User.current).to eq "achiu8"
    end
  end
end
