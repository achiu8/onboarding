require_relative '../router'
require_relative '../request'
require_relative '../user'

describe Router do
  let(:router) { Router.new }

  it "should create new get routes" do
    expect {
      router.get "/test"
    }.to change { router.routes["GET"].count }.by(1)
  end

  it "should create new post routes" do
    expect {
      router.post "/test"
    }.to change { router.routes["POST"].count }.by(1)
  end

  it "should execute the block corresponding to a route" do
    router.get("/test") { "test" }
    request = Request.new({
      :headers =>["GET /test HTTP/1.1"]
    })
    response = router.execute(request, {})
    expect(response).to eq("test")
  end

  it "should redirect after successful login" do
    users = { "andy" => { "pass" => "test", "visits" => 0 }}
    body = "username=andy&password=test"
    request = Request.new({
      :headers =>["POST /login HTTP/1.1", "Content-Length: #{body.bytesize}"],
      :body => body
    })
    response = router.execute(request, users)
    expect(response.status).to eq(303)
  end

  it "should redirect to login page from profile if user not logged in" do
    users = { "andy" => { "pass" => "test", "visits" => 0, "session" => "foo" }}
    request = Request.new({
      :headers =>["GET /profile HTTP/1.1"]
    })
    response = router.execute(request, users)
    expect(response.status).to eq(303)
  end

  it "should redirect to profile page from register if user logged in" do
    session = "foo"
    users = { "andy" => { "pass" => "test", "visits" => 0, "session" => session }}
    request = Request.new({
      :headers =>["GET /register HTTP/1.1", "Cookie: username=#{session}"]
    })
    response = router.execute(request, users)
    expect(response.status).to eq(303)
  end

  it "should be able to add new users to the server" do
    body = "username=bob&password=smith"
    request = Request.new({
      :headers =>["POST /register HTTP/1.1", "Content-Length: #{body.bytesize}"],
      :body => body
    })
    expect {
      router.execute(request, User.all) 
    }.to change { User.all.count }.by(1)
  end

  it "should display all users on welcome page" do
    users = User.all.map(&:first)
    request = Request.new({
      :headers =>["GET /welcome HTTP/1.1"]
    })
    response = router.execute(request, User.all)
    users.each do |user|
      expect(response.body).to include(user)
    end
  end
end
