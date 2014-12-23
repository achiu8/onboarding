require 'rails_helper'

describe "repo page", :type => :feature do
  let(:repo) { double(:name => "test_repo") }
  let(:repo1) { double(:name => "repo1", :watchers_count => 1) }
  let(:repo2) { double(:name => "repo2", :watchers_count => 2) }
  let(:repos) { [repo2, repo1] }
  let(:user) do
    double(
      :name => "Matt Baker",
      :login => "mattbaker",
      :location => "Chicago, IL",
      :email => "mbaker.pdx@gmail.com",
      :followers => 38,
      :following => 1,
      :repos => repos
    )
  end

  before do
    allow(Repo).to receive(:new).and_return repo
    allow(User).to receive(:find).and_return user
    allow(user).to receive(:activities).and_return []
  end

  it "displays the name of the repo and its owner" do
    visit "/users/#{user.login}/#{repo.name}"
    expect(page).to have_content repo.name
    expect(page).to have_content user.login
  end

  it "has link to owner's profile page" do
    visit "/users/#{user.login}/#{repo.name}"
    click_on user.login
    expect(page).to have_selector "h1.user-name"
  end
end
