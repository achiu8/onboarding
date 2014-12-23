require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  describe "GET show" do
    let(:username) { "mattbaker" }
    let(:repo1) { double(:watchers_count => 1) }
    let(:repo2) { double(:watchers_count => 2) }
    let(:repos) { [repo2, repo1] }
    let(:user) { double(:name => "Matt Baker", :repos => repos) }

    before do
      allow(User).to receive(:find).and_return user
      allow(User).to receive(:new).and_return user
      allow(user).to receive(:repos).and_return repos
      allow(user).to receive(:activities).and_return []
      get :show, { :username => "mattbaker" }
    end

    it "renders the show view" do
      expect(response).to render_template 'show'
    end

    it "assigns @user" do
      expect(assigns(:user)).to eq user
    end

    it "assigns @repos to be array of user's repos sorted by watchers count" do
      expect(assigns(:repos)).to eq repos
    end

    it "calls User#find with username param" do
      expect(User).to have_received(:find).with username
    end

    it "creates a new User object using username" do
      expect(User).to have_received(:find).with username
    end
  end
end
