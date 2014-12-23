require 'rails_helper'

describe "repos/show" do
  let(:username) { "mattbaker" }
  let(:repo) { double(:name => "repo1", :watchers_count => 1) }
  let(:user) { double(:name => "Matt Baker", :login => username) }

  before do
    assign(:user, user)
    assign(:repo, repo)
    render
  end

  it "displays name of repo" do
    assert_select '.repo-name', { :count => 1, :text => repo.name }
  end

  it "displays owner's name" do
    assert_select '.user-name', { :count => 1, :text => user.login }
  end

  it "has a link to owner's profile page" do
    assert_select 'a', { :count => 1, :text => user.login }
  end
end
