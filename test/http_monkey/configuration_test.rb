require "test_helper"

describe HttpMonkey::Configuration do

  subject do
    HttpMonkey::Configuration.new
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
    it "sets value using block" do
      subject.behaviours do
        on(200) do
          "ok"
        end
      end
      subject.behaviours.find(200).call.must_equal("ok")
    end
  end

end
