require 'rails_helper'

describe "new repo", :type => :feature do
  let(:repo) { double(:name => "test_repo", :watchers_count => 1) }

  before do
    allow(Util).to receive(:post).and_return ""
    allow(Repo).to receive(:new).and_return repo
  end

  it "shows the form when authenticated user visits own page" do
    visit "/users/achiu8"
    expect(page).to have_selector "form"
  end

  it "allows new repo to be created" do
    visit "/users/achiu8"
    fill_in "repo[reponame]", :with => repo.name
    click_on "Save Repo"
    expect(page).to have_content repo.name
  end
end
