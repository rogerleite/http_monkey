require "test_helper"

describe HttpMonkey::Configuration::Behaviours do

  subject { HttpMonkey::Configuration::Behaviours.new }

  describe "#on" do
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
  end

  it "#on_unknown" do
    subject.on_unknown { "ok" }
    subject.unknown_behaviour.call.must_equal("ok")
  end

  describe "#execute" do
    it "uses find" do
      subject.on(666) { "OK" }

      result = nil
      subject.execute(666) do |behaviour|
        result = behaviour.call
      end
      result.must_equal("OK")
    end
    it "uses unknown" do
      subject.on_unknown { "OK" }
      subject.on(200) { "200 OK" }

      result = nil
      subject.execute(666) do |behaviour|
        result = behaviour.call
      end
      result.must_equal("OK")
    end
    it "raises exception" do
      subject.on(666) { raise "error" }
      lambda {
        subject.execute(666) do |behaviour|
          behaviour.call
        end
      }.must_raise(RuntimeError)
    end
  end

end
