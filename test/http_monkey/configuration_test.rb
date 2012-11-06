require "test_helper"

describe HttpMonkey::Configuration do

  subject do
    HttpMonkey::Configuration.new
  end

  describe "#clone" do
    it "#behaviours" do
      clone = subject.clone
      subject.behaviours.wont_be_same_as(clone.behaviours)
    end
    it "#middlewares" do
      clone = subject.clone
      subject.middlewares.wont_be_same_as(clone.middlewares)
    end
  end

  describe "#net_adapter" do
    it "returns value" do
      subject.net_adapter.must_equal(:net_http)
    end
    it "sets value" do
      subject.net_adapter(:curb)
      subject.net_adapter.must_equal(:curb)
    end
  end

  describe "#behaviours" do
    it "respond_to" do
      subject.must_respond_to(:behaviours)
    end
    it "returns value" do
      subject.behaviours.must_be_instance_of(HttpMonkey::Configuration::Behaviours)
    end
    it "sets value using block" do
      flag = "out block"
      subject.behaviours do
        self.must_respond_to(:on)
        flag = "inside block"
      end
      flag.must_equal("inside block")
    end
  end

  describe "#middlewares" do
    it "respond_to" do
      subject.must_respond_to(:middlewares)
    end
    it "returns value" do
      subject.middlewares.must_be_instance_of(HttpMonkey::Configuration::Middlewares)
    end
    it "sets value using block" do
      flag = "out block"
      subject.middlewares do
        self.must_respond_to(:use)
        flag = "inside block"
      end
      flag.must_equal("inside block")
    end
  end

end
