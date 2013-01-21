require "test_helper"

describe HttpMonkey::Configuration::Behaviours do

  subject { HttpMonkey::Configuration::Behaviours.new }

  it "#on_unknown" do
    subject.on_unknown { "ok" }
    subject.unknown_behaviour.call.must_equal("ok")
  end

  describe "#on" do
    before do
      subject.on_unknown # clears unknown_behaviour
    end
    it "support Integer code" do
      subject.on(1) { "test int" }

      subject.find(1).call.must_equal("test int")
      subject.find(2).must_be_nil
    end
    it "support Range code" do
      subject.on(90...100) { "test range" }

      subject.find(90).call.must_equal("test range")
      subject.find(99).call.must_equal("test range")
      subject.find(100).must_be_nil
    end
    it "support Array code (or anything that respond_to include?)" do
      subject.on([2,3]) { "test array" }

      subject.find(2).call.must_equal("test array")
      subject.find(3).call.must_equal("test array")
      subject.find(1).must_be_nil
    end
    it "support unknown_behaviour" do
      subject.on_unknown { "unknown" }
      subject.find(666).call.must_equal("unknown")
    end
  end

  it "#on_error" do
    subject.on_error { "on error" }
    subject.error_behaviour.call.must_equal("on error")
  end

end
