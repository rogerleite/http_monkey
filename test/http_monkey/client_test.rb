require "test_helper"

describe HttpMonkey::Client do

  subject do
    HttpMonkey::Client.new
  end

  it "#at" do
    subject.at("http://server.com").must_be_instance_of(HttpMonkey::EntryPoint)
  end

  describe "configuration attributes" do
    it "#net_adapter" do
      subject.must_respond_to(:net_adapter)
    end
    it "#storage" do
      subject.must_respond_to(:storage)
    end
  end

  describe "#configure" do
    it "returns self" do
      subject.configure.must_be_same_as(subject)
    end
    it "yields Configuration instance" do
      flag = "out block"
      subject.configure do
        self.must_be_instance_of(HttpMonkey::Configuration)
        flag = "inner block"
      end
      flag.must_equal("inner block")
    end
  end

end
