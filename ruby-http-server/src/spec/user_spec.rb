require_relative '../user'

describe User do
  it "should add new users to users hash" do
    expect { User.new("foo", "bar") }.to change { User.all.count }.by(1)
  end
end
