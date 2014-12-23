require_relative '../response'

describe Response do
  let(:user) { "andy" }
  let(:valid_response) { Response.new({ :resource => "/test" }) }
  let(:invalid_response) { Response.new({ :resource => "/foobar" }) }

  it "should return status code 200 for valid resource" do
    expect(valid_response.status).to eq(200)
  end

  it "should return status code 404 for invalid resource" do
    expect(invalid_response.status).to eq(404)
  end

  it "should return content length for valid resource" do
    content_length = valid_response.body.bytesize
    expect(valid_response.content_length).to eq(content_length)
  end

  it "should return the appropriate content for a valid resource" do
    expect(valid_response.body).to include("This is a test page.")
  end

  it "should return 404 page for an invalid resource" do
    expect(invalid_response.body).to include("404 Not Found")
  end

  it "should respond to query parameters" do
    response = Response.new({
      :resource => "/test",
      :params => { "foo" => "bar" }
    })
    expect(response.body).to include("bar")
  end

  it "should display the logged-in user's name on the profile page" do
    response = Response.new({
      :resource => "/profile",
      :params => { "user" => user }
    })
    expect(response.body).to include(user)
  end

  it "should display the correct number of visits" do
    visits = 5
    response = Response.new({
      :resource => "/visit",
      :params => { "visits" => visits.to_s }
    })
    expect(response.body).to include("You have visited this page #{visits} times.")
  end

  it "should return json when requested" do
    content_type = "application/json"
    user = "andy"
    count = 5
    data = { "user" => user, "count" => count }
    response = Response.new({
      :resource => "/api/visits",
      :params => data,
      :user => user,
      :content_type => content_type
    })
    expect(JSON.parse(response.body)).to eq(data)
  end

  it "should return not found for invalid user" do
    content_type = "application/json"
    message = { "message" => "not found" }
    response = Response.new({
      :status => 404,
      :params => message,
      :content_type => content_type
    })
    expect(JSON.parse(response.body)).to eq(message)
  end
end

