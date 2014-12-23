require 'rails_helper'

RSpec.describe ReposController, :type => :controller do
  let(:username) { "mattbaker" }

  describe "POST create" do
    it "responds to HTML" do
      request.accept = "text/html"
      post :create
      expect(response).to redirect_to "/users/#{User.current}"
    end

    it "responds to JavaScript" do
      request.accept = "application/javascript"
      post :create
      expect(response).to have_http_status 200
    end
  end

  describe "POST submit" do
    let(:response) { {
      "owner" => { "login" => "" },
      "name" => ""
    } }

    it "creates a new Repo object" do
      allow(Util).to receive(:post).and_return response
      expect(Repo).to receive(:new).and_return ""
      post :submit, :repo => { :reponame => "test" }
    end

    it "makes a post request to the api" do
      expect(Util).to receive(:post).and_return response
      expect(Repo).to receive(:new).and_return ""
      request.accept = "application/javascript"
      post :submit, :repo => { :reponame => "test" }
    end
  end
end
