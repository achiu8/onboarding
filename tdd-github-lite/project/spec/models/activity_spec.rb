require 'rails_helper'

describe Activity do
  let(:args) do
    {
      "number" => 1,
      "title" => "Updates from master",
      "reponame" => "sequoias-2014/a-star-challenge",
      "merged_at" => nil
    }
  end

  it "creates a new Activity object and sets attributes" do
    activity = Activity.new(args)
    expect(activity.number).to eq args["number"]
    expect(activity.title).to eq args["title"]
    expect(activity.reponame).to eq args["reponame"]
    expect(activity.status).to eq "Proposed"
  end
end
