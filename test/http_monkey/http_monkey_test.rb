require "test_helper"

describe HttpMonkey do

  subject { HttpMonkey }

  it "#at" do
    subject.at("http://google.com.br").must_be_instance_of(HttpMonkey::EntryPoint)
  end

  it "#configure" do
    flag = "out block"
    subject.configure do
      self.must_be_instance_of(HttpMonkey::Configuration)
      flag = "inside block"
    end
    flag.must_equal("inside block")
  end

  describe "#build" do
    it "wont be same client" do
      subject.build.wont_be_same_as(HttpMonkey.default_client)
    end
  end

end
