require "test_helper"

describe HttpMonkey::Client do

  subject do
    HttpMonkey::Client.new
  end

  it "#at" do
    subject.at("http://server.com").must_be_instance_of(HttpMonkey::EntryPoint)
  end

  describe "default values" do
    it "#net_adapter" do
      subject.net_adapter.must_equal(:net_http)
    end
  end

  describe "#configure" do
    it "#net_adapter" do
      subject.configure do
        net_adapter(:curb)
      end
      subject.net_adapter.must_equal(:curb)
    end
  end

end
