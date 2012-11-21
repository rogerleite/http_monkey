require "test_helper"

class Counter
  @@counter = 0
  def self.value
    @@counter
  end
  def self.increment
    @@counter += 1
  end
end

RedirectApp = Rack::Builder.new do
  map "/" do
    run lambda { |env|
      [301, {"Content-Type" => "text/plain", "Location" => "http://localhost:4000/home"}, ["Redirecting ..."]]
    }
  end

  map "/home" do
    run lambda { |env|
      [200, {"Content-Type" => "text/plain"}, ["home sweet home"]]
    }
  end

  map "/redirect3times" do
    run lambda { |e| [301, {"Location" => "http://localhost:4000/redirect2times"}, ["Should Redirect"]]}
  end
  map "/redirect2times" do
    run lambda { |e| [301, {"Location" => "http://localhost:4000/redirect1times"}, ["Should Redirect"]]}
  end
  map "/redirect1times" do
    run lambda { |e| [301, {"Location" => "http://localhost:4000/home"}, ["Should Redirect"]]}
  end

  map "/infinite-redirect" do
    run lambda { |env|
      Counter.increment
      if Counter.value > 10
        [200, {}, ["Give up, i can't blow yu machine"]]
      else
        [301, {"Location" => "http://localhost:4000/infinite-redirect"}, ["Stop with you can"]]
      end
    }
  end

  map "/no-location" do
    run lambda { |env| [301, {}, ["no location header"]] }
  end
end

describe "Integration Specs - Middleware Follow Redirects" do

  def self.before_suite
    @server = MinionServer.new(RedirectApp).start
  end

  def self.after_suite
    @server.shutdown
  end

  let(:client) do
    HttpMonkey.build do
      middlewares.use HttpMonkey::M::FollowRedirect, :max_tries => 3
    end
  end

  it "follow redirects" do
    response = client.at("http://localhost:4000").get
    response.body.must_equal("home sweet home")
  end

  it "follow redirects in chain" do
    response = client.at("http://localhost:4000/redirect3times").get
    response.body.must_equal("home sweet home")
  end

  it "respect max_tries" do
    lambda {
      response = client.at("http://localhost:4000/infinite-redirect").get
    }.must_raise(RuntimeError)
  end

  it "raises exception in lack of Location" do
    lambda {
      response = client.at("http://localhost:4000/no-location").get
    }.must_raise(RuntimeError)
  end
end
