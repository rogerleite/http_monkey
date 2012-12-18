require "test_helper"

describe "Integration Specs - Client" do

  def self.before_suite
    @@server = MinionServer.new(MirrorApp).start
  end

  def self.after_suite
    @@server.shutdown
  end

  it "response must be instance of Client::Response" do
    response = HttpMonkey.at("http://localhost:4000").get
    response.must_be_instance_of(HttpMonkey::Client::Response)
  end

end
