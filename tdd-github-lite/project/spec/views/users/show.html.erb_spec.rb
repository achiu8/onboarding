require 'rails_helper'

describe "users/show" do
  let(:username) { "mattbaker" }
  let(:repo1) { double(:name => "repo1", :watchers_count => 1) }
  let(:repo2) { double(:name => "repo2", :watchers_count => 2) }
  let(:repos) { [repo2, repo1] }
  let(:activity) do
    double(
      :number => 1,
      :title => "Updates from master",
      :reponame => "sequoias-2014/a-star-challenge",
      :status => "Merged"
    )
  end
  let(:activities) { [activity] }
  let(:user) do
    double(
      :name => "Matt Baker",
      :login => username,
      :location => "Chicago, IL",
      :email => "mbaker.pdx@gmail.com",
      :followers => 38,
      :following => 1,
      :repos => repos,
      :activities => activities
    )
  end

  before do
    assign(:user, user)
    assign(:authenticated_user, username)
    assign(:repos, repos)
    assign(:activities, activities)
    render
  end

  it "displays user's basic info" do
    assert_select '.user-name', { :count => 1, :text => user.name }
    assert_select '.user-login', { :count => 1, :text => user.login }
    assert_select '.user-location', { :count => 1, :text => user.location }
    assert_select '.user-email', { :count => 1, :text => user.email }
    assert_select '.user-followers', { :count => 1, :text => user.followers }
    assert_select '.user-following', { :count => 1, :text => user.following }
  end

  it "lists user's popular repos" do
    assert_select '.popular-repo', { :count => repos.length }
  end

  it "displays each repo's name and watchers count" do
    assert_select '.repo-name', repo1.name
    assert_select '.repo-name', repo2.name
    assert_select '.repo-watchers', repo1.watchers_count.to_s
    assert_select '.repo-watchers', repo2.watchers_count.to_s
  end

  it "lists user's recent activity" do
    assert_select '.contribution-activity', { :count => activities.length }
  end

  it "displays basic info for each activity" do
    assert_select '.activity-number', activity.number
    assert_select '.activity-title', activity.title
    assert_select '.activity-reponame', activity.reponame
    assert_select '.activity-status', activity.status
  end

  it "shows form if authenticated user visits own page" do
  end
end
